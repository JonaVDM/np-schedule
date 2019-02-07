String domain = 'https://sa-nprt.xedule.nl';
String cookie = 'User=1f043ffb-68c4-4bf4-ab14-55cf0f500e9e';

String schedule = '$domain/api/schedule';
String rooms = '$domain/api/facility/';
String classes = '$domain/api/group/';
String teachers = '$domain/api/docent/';

Map<String, String> header = {
  'Cookie': cookie,
};
