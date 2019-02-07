import 'dart:async';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/util/fetch_group.dart';
import 'package:np_schedule/util/api_url.dart' as url;
import 'package:np_schedule/util/file_name.dart' as file;
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleStore extends Store {
  List<Group> _classes = [];
  List<Group> _teachers = [];
  List<Group> _rooms = [];

  SharedPreferences _preferences;

  Group _selected;

  ScheduleStore() {
    this._loadAll();
    triggerOnAction(reloadAllAction, (nothing) => this._loadAll());
    triggerOnAction(reloadClassesAction, (nothing) => this._loadClasses());
    triggerOnAction(reloadTeachersAction, (nothing) => this._loadTeachers());
    triggerOnAction(reloadRoomsAction, (nothing) => this._loadRooms());
    triggerOnAction(saveGroup, _saveSelected);
  }

  // Setters/loader
  void _loadAll() async {
    await this._loadPreferences();
    await this._loadClasses();
    await this._loadTeachers();
    await this._loadRooms();
    await this._loadSelected();
    trigger();
  }

  Future<void> _loadClasses() async {
    this._classes = await fetchGroup(file.classes, url.classes);
  }

  Future<void> _loadTeachers() async {
    this._teachers = await fetchGroup(file.teachers, url.teachers);
  }

  Future<void> _loadRooms() async {
    this._rooms = await fetchGroup(file.rooms, url.rooms);
  }

  Future<void> _loadSelected() async {
    String name = this._preferences.getString('group_name');
    String id = this._preferences.getString('group_id');
    this._selected = Group(id, name);
  }

  Future<void> _loadPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  _saveSelected(Group group) async {
    this._preferences.setString('group_name', group.name);
    this._preferences.setString('group_id', group.id);
    this._selected = group;
  }

  // Getters
  List<Group> get classes => List<Group>.unmodifiable(_classes);
  List<Group> get teachers => List<Group>.unmodifiable(_teachers);
  List<Group> get rooms => List<Group>.unmodifiable(_rooms);
  Group get selected => _selected;
}

// Token
final StoreToken scheduleStoreToken = StoreToken(ScheduleStore());

// Actions
final Action<void> reloadAllAction = Action<void>();
final Action<void> reloadClassesAction = Action<void>();
final Action<void> reloadTeachersAction = Action<void>();
final Action<void> reloadRoomsAction = Action<void>();
final Action<Group> saveGroup = Action<Group>();
