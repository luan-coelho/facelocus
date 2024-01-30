class Item<T> {
  Item({
    this.content,
    this.isExpanded = false,
  });

  T? content;
  bool isExpanded;

  List<Item<T>> generateItems(List items) {
    return List<Item<T>>.generate(items.length, (int index) {
      return Item(
        content: items[index],
      );
    });
  }
}
