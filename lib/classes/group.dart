class Group {
  String id;
  String name;
  bool isStared = false;

  static const int teachers = 1;
  static const int classes = 2;
  static const int rooms = 3;

  Group(this.id, this.name, [this.isStared]);

  Group.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = json['code'];
}
