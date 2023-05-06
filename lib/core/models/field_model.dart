import 'dart:convert';

class Field {
  String? name;
  String? id;
  String? building;
  String? room;
  int? width;
  int? length;
  int? crowdSize;
  Field({
    this.name = "No Name",
    this.id = "No ID",
    this.building = "none",
    this.room = "none",
    this.width,
    this.length,
    this.crowdSize,
  });

  Field copyWith({
    String? name,
    String? id,
    String? building,
    String? room,
    int? width,
    int? length,
    int? crowdSize,
  }) {
    return Field(
      name: name ?? this.name,
      id: id ?? this.id,
      building: building ?? this.building,
      room: room ?? this.room,
      width: width ?? this.width,
      length: length ?? this.length,
      crowdSize: crowdSize ?? this.crowdSize,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (id != null) {
      result.addAll({'id': id});
    }
    if (building != null) {
      result.addAll({'building': building});
    }
    if (room != null) {
      result.addAll({'room': room});
    }
    if (width != null) {
      result.addAll({'width': width});
    }
    if (length != null) {
      result.addAll({'length': length});
    }
    if (crowdSize != null) {
      result.addAll({'crowdsize': crowdSize});
    }

    return result;
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    return Field(
      name: map['name'],
      id: map['id'],
      building: map['building'],
      room: map['room'],
      width: map['width'],
      length: map['length'],
      crowdSize: map['crowdsize'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Field.fromJson(String source) => Field.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Field(name: $name, id: $id, building: $building, room: $room, width: $width, length: $length, crowdSize: $crowdSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Field &&
        other.name == name &&
        other.id == id &&
        other.building == building &&
        other.room == room &&
        other.width == width &&
        other.length == length &&
        other.crowdSize == crowdSize;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        building.hashCode ^
        room.hashCode ^
        width.hashCode ^
        length.hashCode ^
        crowdSize.hashCode;
  }
}
