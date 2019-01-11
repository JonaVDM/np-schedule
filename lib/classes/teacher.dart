class Teacher {
  String name;
  String id;

  Teacher({this.name, this.id});

  Teacher.fromJson(Map<String, dynamic> json)
      : this.name = json['code'],
        this.id = json['id'];
}
