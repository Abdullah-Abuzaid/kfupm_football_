// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kfupm_football/core/models/card_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/shot_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';

enum FieldType {
  GK,
  RB,
  RWB,
  CB,
  LB,
  LWB,
  CDM,
  CM,
  CAM,
  RM,
  RW,
  LM,
  LW,
  RF,
  CF,
  LF,
  ST,
}

class MatchPlayer {
  KFUPMMemeber? member;
  List<Shot>? shots;
  List<TournamentCard>? cards;
  DateTime? startat;
  DateTime? endat;
  FieldType? fieldType;
  String matchId;
  bool ismvp;
  String team;
  MatchPlayer({
    this.cards,
    this.shots,
    required this.matchId,
    this.member,
    this.startat,
    this.endat,
    this.fieldType,
    required this.ismvp,
    required this.team,
  });

  MatchPlayer copyWith(
      {KFUPMMemeber? member,
      DateTime? startat,
      DateTime? endat,
      FieldType? fieldType,
      TournamentMatch? match,
      bool? ismvp,
      String? team,
      String? matchId}) {
    return MatchPlayer(
        member: member ?? this.member,
        startat: startat ?? this.startat,
        endat: endat ?? this.endat,
        fieldType: fieldType ?? this.fieldType,
        ismvp: ismvp ?? this.ismvp,
        team: team ?? this.team,
        matchId: matchId ?? this.matchId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kfupm_id': member?.kfupmId,
      'startat': startat?.toIso8601String(),
      'endat': endat?.toIso8601String(),
      'field_type': fieldType?.name,
      'ismvp': ismvp,
      'match_id': matchId,
      'playfor': team,
    };
  }

  factory MatchPlayer.fromMap(Map<String, dynamic> map) {
    return MatchPlayer(
      matchId: map['match_id'],
      startat: DateTime.parse(map['startat']),
      endat: DateTime.tryParse(map['endat'] ?? ""),
      fieldType: FieldType.values.byName(map['field_type']),
      ismvp: map['ismvp'] as bool,
      team: map['playfor'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchPlayer.fromJson(String source) => MatchPlayer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MatchPlayer(member: $member, startat: $startat, endat: $endat, fieldType: $fieldType , ismvp: $ismvp, team: $team)';
  }

  @override
  bool operator ==(covariant MatchPlayer other) {
    if (identical(this, other)) return true;

    return other.member == member &&
        other.startat == startat &&
        other.endat == endat &&
        other.fieldType == fieldType &&
        other.ismvp == ismvp &&
        other.team == team;
  }

  @override
  int get hashCode {
    return member.hashCode ^ startat.hashCode ^ endat.hashCode ^ fieldType.hashCode ^ ismvp.hashCode ^ team.hashCode;
  }

  int getGoals() {
    if (shots == null || (shots?.isEmpty ?? true)) return 0;
    return shots!.where((element) => element.isGoal!).length;
  }
}
