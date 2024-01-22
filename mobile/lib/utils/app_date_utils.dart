class AppDateUtils {
  static String getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado'
    ];
    return daysOfWeek[date.weekday - 1];
  }
}
