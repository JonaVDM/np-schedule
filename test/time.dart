import 'package:amo_schedule/models/schedule.dart' as model;

main(List<String> args) {
  loadData();
}

void loadData() async {
  model.Schedule s = await model.fetch();
  print(s.perDay());
}
