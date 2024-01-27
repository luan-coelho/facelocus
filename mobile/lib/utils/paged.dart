import 'dart:async';

class Paged<T> {
  final StreamController<Paged<T>> notifier =
      StreamController<Paged<T>>.broadcast();

  Function(int)? load;

  final int? expectedPageSize;

  Paged({this.load, this.expectedPageSize});

  List<T> items = [];
  int page = 0;

  bool _hasMore = true;
  bool _paging = false;
  bool _failed = false;

  bool get loading => _paging;
  bool get loadingInitial => _paging && page == 1 && items.isEmpty;
  bool get refreshing => _paging && page == 1 && items.isNotEmpty;
  bool get loadingMore => _paging && page > 1;
  bool get loadedAll => !_hasMore;
  bool get noData => !_hasMore && items.isEmpty;
  bool get failed => _failed;

  void next() async {
    clearFailed();

    if (load == null || !_hasMore || _paging) return;

    try {
      page += 1;
      _paging = true;
      notifier.add(this);

      var nextItems = await load!(page);
      _hasMore = !(nextItems == null ||
          nextItems.isEmpty ||
          (expectedPageSize != null && nextItems.length < expectedPageSize));
      items.addAll(nextItems);

      _paging = false;
    } catch (_) {
      page -= 1;
      _paging = false;
      _failed = true;
    }

    notifier.add(this);
  }

  void reload() => {reset(), next()};

  Future<void> refresh() async {
    clearFailed();

    if (load == null) return;

    try {
      page = 1;
      _paging = true;
      notifier.add(this);

      var nextItems = await load!(page);
      _hasMore = !(nextItems == null ||
          nextItems.isEmpty ||
          (expectedPageSize != null && nextItems.length < expectedPageSize));
      items = nextItems;

      _paging = false;
    } catch (_) {
      _paging = false;
      _failed = true;
    }

    notifier.add(this);
  }

  void clearFailed() {
    if (_failed) {
      page = 0;
      _failed = false;
      notifier.add(this);
    }
  }

  void reset() => {items.clear(), page = 0, _paging = false, _hasMore = true};

  void dipose() => notifier.close();
}
