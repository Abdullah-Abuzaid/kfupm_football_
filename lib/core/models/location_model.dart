import 'dart:convert';

class Location {
  String? building;
  String? name;
  String? room;
  String? floor;
  Location({
    this.building = "none",
    this.name = "none",
    this.room = "none",
    this.floor = "none",
  });

  Location copyWith({
    String? building,
    String? name,
    String? room,
    String? floor,
  }) {
    return Location(
      building: building ?? this.building,
      name: name ?? this.name,
      room: room ?? this.room,
      floor: floor ?? this.floor,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (building != null) {
      result.addAll({'building': building});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (room != null) {
      result.addAll({'room': room});
    }
    if (floor != null) {
      result.addAll({'floor': floor});
    }

    return result;
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      building: map['building'],
      name: map['name'],
      room: map['room'],
      floor: map['floor'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) => Location.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Location(building: $building, name: $name, room: $room, floor: $floor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Location &&
        other.building == building &&
        other.name == name &&
        other.room == room &&
        other.floor == floor;
  }

  @override
  int get hashCode {
    return building.hashCode ^ name.hashCode ^ room.hashCode ^ floor.hashCode;
  }
}
