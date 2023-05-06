// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MatchSubstitution {
  final String playerleaving;
  final String team_id;
  final String match_id;
  final String playerjoining;
  final DateTime happenedat;
  MatchSubstitution({
    required this.playerleaving,
    required this.team_id,
    required this.match_id,
    required this.playerjoining,
    required this.happenedat,
  });

  MatchSubstitution copyWith({
    String? playerleaving,
    String? team_id,
    String? match_id,
    String? playerjoining,
    DateTime? happenedat,
  }) {
    return MatchSubstitution(
      playerleaving: playerleaving ?? this.playerleaving,
      team_id: team_id ?? this.team_id,
      match_id: match_id ?? this.match_id,
      playerjoining: playerjoining ?? this.playerjoining,
      happenedat: happenedat ?? this.happenedat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playerleaving': playerleaving,
      'team_id': team_id,
      'match_id': match_id,
      'playerjoining': playerjoining,
      'happenedat': happenedat.toIso8601String(),
    };
  }

  factory MatchSubstitution.fromMap(Map<String, dynamic> map) {
    return MatchSubstitution(
      playerleaving: map['playerleaving'] as String,
      team_id: map['team_id'] as String,
      match_id: map['match_id'] as String,
      playerjoining: map['playerjoining'] as String,
      happenedat: DateTime.parse(map['happenedat']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchSubstitution.fromJson(String source) =>
      MatchSubstitution.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MatchSubstitution(playerleaving: $playerleaving, team_id: $team_id, match_id: $match_id, playerjoining: $playerjoining, happenedat: $happenedat)';
  }

  @override
  bool operator ==(covariant MatchSubstitution other) {
    if (identical(this, other)) return true;

    return other.playerleaving == playerleaving &&
        other.team_id == team_id &&
        other.match_id == match_id &&
        other.playerjoining == playerjoining &&
        other.happenedat == happenedat;
  }

  @override
  int get hashCode {
    return playerleaving.hashCode ^ team_id.hashCode ^ match_id.hashCode ^ playerjoining.hashCode ^ happenedat.hashCode;
  }
}
