class SchoolClass {
  String id;
  String name;

  SchoolClass(this.id, this.name);

  SchoolClass.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.name = json['code'];
}
