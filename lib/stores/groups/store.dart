import 'package:flutter_flux/flutter_flux.dart';
import 'package:np_schedule/classes/group.dart';


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

  // Getters/loader
  void _loadAll() {
    this._loadClasses();
    this._loadTeachers();
    this._loadRooms();
  }
  void _loadClasses() {}
  void _loadTeachers() {}
  void _loadRooms() {}

  // Getters
  List<Group> get classes => List<Group>.unmodifiable(_classes);
  List<Group> get teachers => List<Group>.unmodifiable(_teachers);
  List<Group> get rooms => List<Group>.unmodifiable(_rooms);
}


Action<void> reloadAllAction = Action<void>();
Action<void> reloadClassesAction = Action<void>();
Action<void> reloadTeachersAction = Action<void>();
Action<void> reloadRoomsAction = Action<void>();
