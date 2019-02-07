import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/classes/group.dart';
import 'package:np_schedule/util/fetch_group.dart';
import 'package:np_schedule/util/api_url.dart' as url;
import 'package:np_schedule/util/file_name.dart' as file;

class GroupStore extends Store {
  List<Group> _classes = [];
  List<Group> _teachers = [];
  List<Group> _rooms = [];

  GroupStore() {
    this._loadAll();
    triggerOnAction(reloadAllAction, (nothing) => this._loadAll());
    triggerOnAction(reloadClassesAction, (nothing) => this._loadClasses());
    triggerOnAction(reloadTeachersAction, (nothing) => this._loadTeachers());
    triggerOnAction(reloadRoomsAction, (nothing) => this._loadRooms());
  }

  // Setters/loader
  void _loadAll() {
    this._loadClasses();
    this._loadTeachers();
    this._loadRooms();
  }
  void _loadClasses() async {
    this._classes = await fetchGroup(file.classes, url.classes);
  }
  void _loadTeachers() async {
    this._teachers = await fetchGroup(file.teachers, url.teachers);
  }
  void _loadRooms() async {
    this._rooms = await fetchGroup(file.rooms, url.rooms);
  }

  // Getters
  List<Group> get classes => List<Group>.unmodifiable(_classes);
  List<Group> get teachers => List<Group>.unmodifiable(_teachers);
  List<Group> get rooms => List<Group>.unmodifiable(_rooms);
}

// Token
final StoreToken groupStoreToken = StoreToken(GroupStore());

// Actions
final Action<void> reloadAllAction = Action<void>();
final Action<void> reloadClassesAction = Action<void>();
final Action<void> reloadTeachersAction = Action<void>();
final Action<void> reloadRoomsAction = Action<void>();
