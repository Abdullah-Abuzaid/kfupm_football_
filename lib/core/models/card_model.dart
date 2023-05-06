// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/tournament_player_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';

enum CardType {
  red,
  yellow,
}

class TournamentCard {
  CardType? type;
  DateTime? takenAt;
  String? forId;
  String? givenBy;
  String? atMatchId;
  String? tournamentId;
  String? teamID;
  TournamentCard({
    this.type,
    this.takenAt,
    this.teamID,
    this.givenBy,
    this.atMatchId,
    this.tournamentId,
    this.forId,
  });

  TournamentCard copyWith({
    CardType? type,
    DateTime? takenAt,
    String? givenBy,
    String? atMatch,
    String? tournament,
  }) {
    return TournamentCard(
      type: type ?? this.type,
      takenAt: takenAt ?? this.takenAt,
      givenBy: givenBy ?? this.givenBy,
      atMatchId: atMatch ?? this.atMatchId,
      tournamentId: tournament ?? this.tournamentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cardtype': type?.name,
      "match_id": atMatchId,
      "team_id": teamID,
      "tournament_id": tournamentId,
      "referee_id": givenBy,
      "takenat": takenAt?.toIso8601String(),
      "kfupm_id": forId,
    };
  }

  factory TournamentCard.fromMap(Map<String, dynamic> map) {
    return TournamentCard(
      type: CardType.values.firstWhere((element) => element.name == map['cardtype']),
      takenAt: DateTime.parse(map['takenat']),
      givenBy: map['referee_id'],
      atMatchId: map['match_id'],
      forId: map['kfupm_id'],
      tournamentId: map['tournament_id'],
    );
  }

  // String toJson() => json.encode(toMap());

  factory TournamentCard.fromJson(String source) => TournamentCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TournamentCard(type: $type, takenAt: $takenAt, givenBy: $givenBy, )';
  }

  @override
  bool operator ==(covariant TournamentCard other) {
    if (identical(this, other)) return true;

    return other.type == type && other.takenAt == takenAt && other.givenBy == givenBy;
  }

  @override
  int get hashCode {
    return type.hashCode ^ takenAt.hashCode ^ givenBy.hashCode;
  }
}
