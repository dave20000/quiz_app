import 'dart:convert';

class Tags {
  final String? name;
  Tags({
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Tags.fromMap(Map<String, dynamic> map) {
    return Tags(
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tags.fromJson(String source) => Tags.fromMap(json.decode(source));
}
