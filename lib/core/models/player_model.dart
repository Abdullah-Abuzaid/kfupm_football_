import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/core/models/card_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/providers/player_model_provider.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';

import 'name_model.dart';

class Player extends KFUPMMemeber {
  List<Tournament>? tournamentPlayed;
  List<TournamentCard>? cardGotten;

  Player({
    this.tournamentPlayed,
    this.cardGotten,
    String? kfupmId,
    Name? name,
    DateTime? dob,
    String? email,
    String? uid,
    String? nationalId,
    List<String>? phoneNumbers,
    MemberType? type = MemberType.player,
    String? department = "No Department",
  }) : super(
          uid: uid,
          type: type,
          department: department,
          kfupmId: kfupmId,
          name: name,
          dob: dob,
          email: email,
          nationalId: nationalId,
          phoneNumbers: phoneNumbers,
        );

  Player copyWith({
    MemberType? type,
    String? kfupmId,
    Name? name,
    DateTime? dob,
    String? email,
    String? nationalId,
    List<String>? phoneNumbers,
    String? department = "No Department",
  }) {
    return Player(
      tournamentPlayed: tournamentPlayed,
      cardGotten: cardGotten,
      department: department,
      kfupmId: kfupmId,
      name: name,
      dob: dob,
      email: email,
      nationalId: nationalId,
      phoneNumbers: phoneNumbers,
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
    result.addAll({"department": department});

    return result;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      kfupmId: map['kfupm_id'] ?? 'No KFUPM ID',
      name: Name.fromMap(map['name']),
      dob: DateTime.parse(map['dob']),
      email: map['email'] ?? '',
      nationalId: map['national_id'] ?? 'No National ID',
      uid: map['uid'],
      department: map['department'] ?? "Department",
    );
  }

  String toJson() => json.encode(toMap());

  factory Player.fromJson(String source) => Player.fromMap(json.decode(source));

  @override
  String toString() =>
      'Player(department: $department,kfupmId: $kfupmId, name: $name, dob: $dob, email: $email, nationalId: $nationalId, phoneNumbers: $phoneNumbers)';
}
