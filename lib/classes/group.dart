class Group {
  String id;
  String name;

  static int teachers = 1;
  static int classes = 2;

  Group(this.id, this.name);

  Group.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = json['code'];
}
