// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:kfupm_football/core/models/card_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/shot_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';

class TournamentPlayer {
  // TournamentTeam team;
  KFUPMMemeber memeber;
  List<Shot>? shots;
  List<Shot>? assists;
  List<Shot>? defendedShots;
  List<TournamentMatch>? matches;
  List<TournamentCard>? cards;
  TournamentPlayer({
    required this.memeber,
    // required this.team,
    this.shots,
    this.assists,
    this.defendedShots,
    this.matches,
    required this.cards,
  });

  TournamentPlayer copyWith({
    TournamentTeam? team,
    List<Shot>? tournamnetShots,
    List<TournamentMatch>? matches,
    List<TournamentCard>? cards,
    KFUPMMemeber? memeber,
  }) {
    return TournamentPlayer(
      memeber: memeber ?? this.memeber,
      // team: team ?? this.team,
      shots: tournamnetShots ?? this.shots,
      matches: matches ?? this.matches,
      cards: cards ?? this.cards,
    );
  }

  factory TournamentPlayer.fromMap(Map<String, dynamic> map) {
    return TournamentPlayer(
      memeber: map['member'],
      // team: TournamentTeam.fromMap(map['team'] as Map<String, dynamic>),
      shots: List<Shot>.from(
        (map['tournamnetShots'] as List).map<Shot>(
          (x) => Shot.fromMap(x as Map<String, dynamic>),
        ),
      ),
      matches: List<TournamentMatch>.from(
        (map['matches'] as List).map<TournamentMatch>(
          (x) => TournamentMatch.fromMap(x as Map<String, dynamic>),
        ),
      ),
      cards: List<TournamentCard>.from(
        (map['cards'] as List).map<TournamentCard>(
          (x) => TournamentCard.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory TournamentPlayer.fromJson(String source) =>
      TournamentPlayer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TournamentPlayer(  tournamnetShots: $shots, matches: $matches, cards: $cards)';
  }

  @override
  bool operator ==(covariant TournamentPlayer other) {
    if (identical(this, other)) return true;

    return listEquals(other.shots, shots) && listEquals(other.matches, matches) && listEquals(other.cards, cards);
  }

  @override
  int get hashCode {
    return shots.hashCode ^ matches.hashCode ^ cards.hashCode;
  }
}
