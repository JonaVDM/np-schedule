int weeknumber(DateTime today) {
  // Weird thing, 4 January is always in week 1 apparently
  DateTime jan4 = DateTime(today.year, 1, 4);

  // use thursday to compare
  DateTime thursday = today.subtract(Duration(days: (today.weekday - 4)));

  // Thursday in week 1
  DateTime first = jan4.subtract(Duration(days: (jan4.weekday - 4)));

  // get the difference and add 1
  return 1 + (thursday.difference(first).inDays / 7).round();
}
