class ClassRoom {
  String code;
  String id;

  ClassRoom([
    this.code,
    this.id,
  ]);

  ClassRoom.fromJson(Map<String, dynamic> json)
      : this.code = json['code'],
        this.id = json['id'];
}
