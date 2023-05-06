import 'dart:convert';

import 'package:kfupm_football/core/models/kfupm_member.dart';

class Name {
  String firstName;
  String middleName;
  String lastName;
  Name({
    this.firstName = "no name",
    this.middleName = "no name",
    this.lastName = "no name",
  });

  Name copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
  }) {
    return Name(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'firstName': firstName});
    result.addAll({'middleName': middleName});
    result.addAll({'lastName': lastName});

    return result;
  }

  factory Name.fromMap(Map<String, dynamic> map) {
    return Name(
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Name.fromJson(String source) => Name.fromMap(json.decode(source));

  @override
  String toString() => 'Name(firstName: $firstName, middleName: $middleName, lastName: $lastName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Name &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode => firstName.hashCode ^ middleName.hashCode ^ lastName.hashCode;
}
