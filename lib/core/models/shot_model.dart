// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/tournament_player_model.dart';

import 'team_model.dart';
import 'tournament_team_model.dart';

enum ShotType {
  penalty,
  free_kick,
  normal,
}

class Shot {
  num? distanceFromGoal;
  ShotType? type;
  DateTime? time;
  String? tournamentID;
  String? matchID;

  // TournamentMatch? match;
  KFUPMMemeber? shotby;
  KFUPMMemeber? assistedBy;
  KFUPMMemeber? shotOnGoalie;
  Team? forTeam;
  Team? againstTeam;
  bool? isGoal;
  Shot({
    this.matchID,
    this.distanceFromGoal,
    this.time,
    this.tournamentID,
    this.shotby,
    this.assistedBy,
    this.shotOnGoalie,
    this.forTeam,
    this.againstTeam,
    this.isGoal,
    this.type,
  });

  // Shot copyWith({
  //   num? distanceFromGoal,
  //   DateTime? time,
  //   TournamentMatch? match,
  //   TournamentPlayer? player,
  //   TournamentPlayer? assistedBy,
  //   TournamentPlayer? shotOnGoalie,
  //   TournamentTeam? forTeam,
  //   TournamentTeam? againstTeam,
  //   bool? isGoal,
  // }) {
  //   return Shot(
  //     distanceFromGoal: distanceFromGoal ?? this.distanceFromGoal,
  //     time: time ?? this.time,
  //     match: match ?? this.match,
  //     shotby: player ?? this.shotby,
  //     assistedBy: assistedBy ?? this.assistedBy,
  //     shotOnGoalie: shotOnGoalie ?? this.shotOnGoalie,
  //     forTeam: forTeam ?? this.forTeam,
  //     againstTeam: againstTeam ?? this.againstTeam,
  //     isGoal: isGoal ?? this.isGoal,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'distancefromgoal': distanceFromGoal,
      'time': time?.toIso8601String(),
      'isgoal': isGoal,
      "shoton": shotOnGoalie!.kfupmId,
      "shotby": shotby!.kfupmId,
      "assistedby": assistedBy?.kfupmId,
      "tournament_id": tournamentID,
      "match_id": matchID,
      "againstteam": againstTeam!.id,
      "forteam": forTeam!.id,
      "shottype": type?.name
    };
  }

  factory Shot.fromMap(Map<String, dynamic> map) {
    return Shot(
      distanceFromGoal: map['distancefromgoal'] != null ? map['distancefromgoal'] as num : null,
      time: map['time'] != null ? DateTime.parse(map['time']) : null,
      type: ShotType.values.byName(map['shottype']),
      isGoal: map['isgoal'] != null ? map['isgoal'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Shot.fromJson(String source) => Shot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Shot(distanceFromGoal: $distanceFromGoal, time: $time,  player: $shotby, assistedBy: $assistedBy, shotOnGoalie: $shotOnGoalie, forTeam: $forTeam, againstTeam: $againstTeam, isGoal: $isGoal)';
  }

  @override
  bool operator ==(covariant Shot other) {
    if (identical(this, other)) return true;

    return other.distanceFromGoal == distanceFromGoal &&
        other.time == time &&
        other.shotby == shotby &&
        other.assistedBy == assistedBy &&
        other.shotOnGoalie == shotOnGoalie &&
        other.forTeam == forTeam &&
        other.againstTeam == againstTeam &&
        other.isGoal == isGoal;
  }

  @override
  int get hashCode {
    return distanceFromGoal.hashCode ^
        time.hashCode ^
        shotby.hashCode ^
        assistedBy.hashCode ^
        shotOnGoalie.hashCode ^
        forTeam.hashCode ^
        againstTeam.hashCode ^
        isGoal.hashCode;
  }
}
