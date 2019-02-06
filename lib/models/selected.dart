import 'package:shared_preferences/shared_preferences.dart';
import 'package:np_schedule/classes/group.dart';

class Selected {
  void save(Group group) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('group_name', group.name);
    preferences.setString('group_id', group.id);
  }

  Future<Group> load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString('group_name');
    String id = preferences.getString('group_id');
    return Group(id, name);
  }

  Future<bool> empty() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString('group_name') ?? 'nah mate this does not exist';
    return name == 'nah mate this does not exist';
  }
}
