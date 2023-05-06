import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kfupm_football/core/models/name_model.dart';

class Person {
  String? kfupmId;
  Name? name;
  DateTime? dob;
  String? email;
  String? nationalId;
  List<String>? phoneNumbers;
  Person({
    this.kfupmId,
    this.name,
    this.dob,
    this.email,
    this.nationalId,
    this.phoneNumbers,
  }) {
    kfupmId = kfupmId ?? "No ID";
    name = name ?? Name();

    email = email ?? "No Email";
    nationalId = nationalId ?? "No National Id";
  }

  Person copyWith({
    String? kfupmId,
    Name? name,
    DateTime? dob,
    String? email,
    String? nationalId,
    List<String>? phoneNumbers,
  }) {
    return Person(
      kfupmId: kfupmId ?? this.kfupmId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'kfupmId': kfupmId});
    result.addAll({'name': name?.toMap()});
    result.addAll({'dob': dob});
    result.addAll({'email': email});
    result.addAll({'nationalId': nationalId});
    result.addAll({'phoneNumbers': phoneNumbers});

    return result;
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      kfupmId: map['kfupmId'] ?? '',
      name: Name.fromMap(map['name']),
      dob: DateTime(map['dob']),
      email: map['email'] ?? '',
      nationalId: map['nationalId'] ?? '',
      phoneNumbers: List<String>.from(map['phoneNumbers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Person(kfupmId: $kfupmId, name: $name, dob: $dob, email: $email, nationalId: $nationalId, phoneNumbers: $phoneNumbers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Person &&
        other.kfupmId == kfupmId &&
        other.name == name &&
        other.dob == dob &&
        other.email == email &&
        other.nationalId == nationalId &&
        listEquals(other.phoneNumbers, phoneNumbers);
  }

  @override
  int get hashCode {
    return kfupmId.hashCode ^
        name.hashCode ^
        dob.hashCode ^
        email.hashCode ^
        nationalId.hashCode ^
        phoneNumbers.hashCode;
  }
}
