// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kfupm_football/core/models/field_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';

enum MatchType {
  points,
  knockout,
}

class TournamentMatch {
  List<MatchTeam>? participantTeams;
  num? points;
  Field? field;
  DateTime? startDate;
  DateTime? endDate;
  KFUPMMemeber? referee;
  String? tournamentId;
  String? id;
  TournamentMatch({
    this.tournamentId,
    this.id,
    this.participantTeams,
    this.points,
    this.field,
    this.startDate,
    this.endDate,
    this.referee,
    this.type,
  });
  MatchType? type;

  // TournamentMatch copyWith({
  //   List<TournamentTeam>? participantTeams,
  //   String
  //   num? points,
  //   Field? field,
  //   DateTime? startDate,
  //   DateTime? endDate,
  //   KFUPMMemeber? referee,
  //   Tournament? tournament,
  // }) {
  //   return TournamentMatch(
  //     participantTeams: participantTeams ?? this.participantTeams,
  //     points: points ?? this.points,
  //     field: field ?? this.field,
  //     startDate: startDate ?? this.startDate,
  //     endDate: endDate ?? this.endDate,
  //     referee: referee ?? this.referee,
  //     tournament: tournament ?? this.tournament,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'match_id': id,
      'referee_id': referee?.kfupmId,
      'field_id': field?.id,
      'enddate': endDate?.toIso8601String(),
      'startdate': startDate?.toIso8601String(),
      'matchtype': type?.name,
      'points': points,
      'tournament_id': tournamentId,
    };
  }

  factory TournamentMatch.fromMap(Map<String, dynamic> map) {
    return TournamentMatch(
      points: map['points'] != null ? map['points'] as num : null,
      startDate: map['startdate'] != null ? DateTime.parse(map['startdate']) : null,
      endDate: map['enddate'] != null ? DateTime.tryParse(map['enddate']) : null,
      type: MatchType.values.byName(map['matchtype']),
      id: map['match_id'],
      tournamentId: map['tournament_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TournamentMatch.fromJson(String source) =>
      TournamentMatch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Match(participantTeams: $participantTeams, points: $points, field: $field, startDate: $startDate, endDate: $endDate, referee: $referee )';
  }

  @override
  bool operator ==(covariant TournamentMatch other) {
    if (identical(this, other)) return true;

    return listEquals(other.participantTeams, participantTeams) &&
        other.points == points &&
        other.field == field &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.referee == referee;
  }

  @override
  int get hashCode {
    return participantTeams.hashCode ^
        points.hashCode ^
        field.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        referee.hashCode;
  }
}
