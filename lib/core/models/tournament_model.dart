import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';

class Tournament {
  String id;
  String name;
  String? description;
  int prizePool;
  DateTime startDate;
  DateTime endDate;
  KFUPMMemeber? madeBy;
  List<TournamentMatch>? plannedMatches;
  List<TournamentTeam>? teams;
  Tournament({
    this.madeBy,
    this.description,
    required this.prizePool,
    this.teams,
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.plannedMatches,
  });

  // Tournament copyWith({
  //   String? id,
  //   String? name,
  //   DateTime? startDate,
  //   DateTime? endDate,
  //   List<TournamentMatch>? plannedMatches,
  // }) {
  //   return Tournament(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     startDate: startDate ?? this.startDate,
  //     endDate: endDate ?? this.endDate,
  //     plannedMatches: plannedMatches ?? this.plannedMatches,
  //   );
  // }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'startdate': startDate.toIso8601String()});
    result.addAll({'enddate': endDate.toIso8601String()});
    result.addAll({"description": description ?? ""});
    result.addAll({"prizepool": prizePool});
    result.addAll({"madeby": madeBy!.kfupmId});

    return result;
  }

  factory Tournament.fromMap(Map<String, dynamic> map) {
    return Tournament(
      prizePool: map['prizepool'],
      description: map['description'],
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      startDate: DateTime.parse(map['startdate']),
      endDate: DateTime.parse(map['enddate']),
    );
  }

  // String toJson() => json.encode(toMap());

  factory Tournament.fromJson(String source) => Tournament.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Tournament(id: $id, name: $name, startDate: $startDate, endDate: $endDate, plannedMatches: $plannedMatches)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tournament &&
        other.id == id &&
        other.name == name &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.plannedMatches, plannedMatches);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ startDate.hashCode ^ endDate.hashCode ^ plannedMatches.hashCode;
  }
}
