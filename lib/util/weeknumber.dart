int weeknumber(DateTime today) {
  // Weird thing, 1 January is always in week 1 apparently
  DateTime jan1 = DateTime(today.year, 1, 1);

  // use thursday to compare
  DateTime thursday = today.subtract(Duration(days: (today.weekday - 4)));

  // Thursday in week 1
  DateTime first = jan1.subtract(Duration(days: (jan1.weekday - 4)));

  // get the difference and add 1
  return 1 + (thursday.difference(first).inDays / 7).round();
}
