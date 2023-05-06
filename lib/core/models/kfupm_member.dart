import 'dart:convert';
import 'dart:math';

import 'package:kfupm_football/core/models/person_model.dart';

import 'name_model.dart';

enum MemberType {
  player,
  admin,
  coach,
  manager,
  referee,
}

class KFUPMMemeber extends Person {
  String? department;
  MemberType? type;
  String? uid;
  KFUPMMemeber({
    String? kfupmId,
    Name? name,
    DateTime? dob,
    String? email,
    String? nationalId,
    List<String>? phoneNumbers,
    this.uid,
    this.type = MemberType.player,
    this.department = "No Department",
  }) : super(
          dob: dob,
          kfupmId: kfupmId,
          name: name,
          email: email,
          nationalId: nationalId,
          phoneNumbers: phoneNumbers,
        );

  KFUPMMemeber copyWith({
    MemberType? type,
    String? department,
    String? kfupmId,
    Name? name,
    DateTime? dob,
    String? email,
    String? nationalId,
    List<String>? phoneNumbers,
  }) {
    return KFUPMMemeber(
      type: type ?? this.type,
      department: department ?? this.department,
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

    result.addAll({'kfupmI_d': kfupmId});
    result.addAll({'name': name?.firstName});
    result.addAll({'dob': dob});
    result.addAll({'email': email});
    result.addAll({'national_id': nationalId});
    result.addAll({'phoneNumbers': phoneNumbers});
    result.addAll({"department": department});
    result.addAll({"type": type});
    result.addAll({" uid": uid});

    return result;
  }

  Map<String, dynamic> toPersonMap() {
    return {
      'type': type?.name,
      'kfupm_id': kfupmId!,
      'name': name!.firstName,
      'dateofbirth': dob!.toIso8601String(),
      'email': email!,
      'national_id': nationalId!,
      "uid": uid!,
    };
  }

  List<Map<String, dynamic>> toPhoneNumbers() {
    if (phoneNumbers == null) return [];
    return phoneNumbers!
        .map((e) => {
              "number": e,
              "kfupm_id": kfupmId,
            })
        .toList();
  }

  Map<String, dynamic> toKFUPMMemberMap() {
    return {
      'kfupm_id': kfupmId!,
      'national_id': nationalId!,
      "department": department,
    };
  }

  factory KFUPMMemeber.fromMap(Map<String, dynamic> map) {
    return KFUPMMemeber(
      type:
          MemberType.values.firstWhere((element) => element.name.toLowerCase() == map['type'].toString().toLowerCase()),
      kfupmId: map['kfupmId'] ?? '',
      name: Name.fromMap(map['name']),
      dob: DateTime(map['dob']),
      email: map['email'] ?? '',
      nationalId: map['nationalId'] ?? '',
      phoneNumbers: List<String>.from(map['phoneNumbers']),
      department: map['department'],
      uid: map['auth_uid'],
    );
  }

  factory KFUPMMemeber.fromTable(Map<String, dynamic> map) {
    return KFUPMMemeber(
      department: map['department'],
      type: MemberType.values.byName(map['type']),
      kfupmId: map['kfupm_id'],
      name: Name(firstName: map['name']),
      dob: DateTime.parse(map['dateofbirth']),
      email: map['email'],
      nationalId: map['national_id'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KFUPMMemeber.fromJson(String source) => KFUPMMemeber.fromMap(json.decode(source));

  @override
  String toString() =>
      'KFUPMMemeber(department: $department,kfupmId: $kfupmId, name: $name, dob: $dob, email: $email, nationalId: $nationalId, phoneNumbers: $phoneNumbers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KFUPMMemeber && other.department == department;
  }

  @override
  int get hashCode => department.hashCode;
}
