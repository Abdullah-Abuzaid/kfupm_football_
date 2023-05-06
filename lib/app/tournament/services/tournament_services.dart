import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/providers/team_providers.dart';
import 'package:kfupm_football/app/teams/services/team_services.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/models/card_model.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/match_player_model.dart';
import 'package:kfupm_football/core/models/match_substitution.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/models/tournament_player_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/field_model.dart';
import '../../../core/models/player_model.dart';
import '../../../core/models/shot_model.dart';

class TournamentServices {
  static final supabase = Supabase.instance.client;

  static Future<void> createNewTournament(Tournament tournament) async {
    await supabase.from("tournament").insert(tournament.toMap());
  }

  static Future<List<Tournament>> fetchTournaments(Ref ref) async {
    final result = await supabase.from("tournament").select() as List;
    if (result.isEmpty) return [];
    final tournaments = result.map((e) => Tournament.fromMap(e)).toList();
    final futures = result.map((e) async {
      final tournament = Tournament.fromMap(e);

      tournament.madeBy = await AuthServices.fetchUser(e['madeby']);
      tournament.teams = await fetchTournamentTeams(tournament.id, ref);
      tournament.plannedMatches = await fetchTournamentMatches(tournament.id, ref);

      return tournament;
    });
    return (await Future.wait(futures)).toList();
  }

  // static Future<List<TournamentMatch>> fetchTournamentMatches(String tournamentId) async {
  //   final result = (await supabase.from("match").select().match({"tournament_id": tournamentId})) as List;

  //   if (result.isEmpty) return [];
  //   final matchesFutures = result.map((e) async {
  //     TournamentMatch.fromMap(e);
  //   });
  // }

  static Future<void> addTournamentMatch(List<MatchTeam> teams, TournamentMatch match) async {
    await supabase.from("match").insert(match.toMap());

    final futures = teams.map((e) async {
      await supabase.from("compete_in_match").insert({
        'tournament_id': match.tournamentId,
        'team_id': e.team!.id,
        'match_id': match.id,
      });
      final futures = e.players!.map((player) async {
        await supabase.from("match_player").insert(player.toMap());
      });

      await Future.wait(futures);
    });

    await Future.wait(futures);
  }

  static Future<void> addTeamToTournament(String teamId, String tournamentId) async {
    await supabase.from("team_compete_in_tourney").insert(
      {
        "team_id": teamId,
        "tournament_id": tournamentId,
        "joinedat": DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<void> removeTeamFromTournament(String teamId, String tournamentId) async {
    await supabase.from("team_compete_in_tourney").update({
      "leavedat": DateTime.now().toIso8601String(),
    }).match(
      {
        "team_id": teamId,
        "tournament_id": tournamentId,
      },
    ).is_(
      "leavedat",
      null,
    );
  }

  static Future<bool> addPlayerToTournamentRoster(String teamId, String tournamentId, String kfupmId) async {
    await supabase.from("tournament_roster").insert({
      "tournament_id": tournamentId,
      "kfupm_id": kfupmId,
      "team_id": teamId,
      "joinedat": DateTime.now().toIso8601String(),
    });
    return true;
  }

  static Future<void> removePlayerToTournamentRoster(String teamId, String tournamentId, String kfupmId) async {
    await supabase.from("tournament_roster").update({
      "leavedat": DateTime.now().toIso8601String(),
    }).match({
      "tournament_id": tournamentId,
      "kfupm_id": kfupmId,
      "team_id": teamId,
    }).is_(
      "leavedat",
      null,
    );
  }

  static Future<bool> isPlayerInTournament(String tournamentId, String kfupmId) async {
    final check = (await supabase.from("tournament_roster").select().match({
      "tournament_id": tournamentId,
      "kfupm_id": kfupmId,
    }).is_("leavedat", null)) as List;

    if (check.isNotEmpty) return true;

    return false;
  }

  static Future<List<TournamentTeam>> fetchTournamentTeams(String tournamentId, Ref ref) async {
    var result = [];

    try {
      result = (await supabase.from("team_compete_in_tourney").select().match({"tournament_id": tournamentId}));
    } catch (e) {
      print(e.toString());
    }
    if (result == null || result.isEmpty) return [];

    final futures = result.map((e) async {
      final team = await TeamServices.fetchTeam(e['team_id']);
      final players = await fetchTournamentTeamPlayers(tournamentId, e['team_id']);

      return TournamentTeam(team: team, players: players);
    });
    final k = await Future.wait(futures);

    return k;
  }

  static Future<TournamentMatch> fetchMatch(String matchId, Ref ref) async {
    final result = await supabase.from("match").select().is_("id", matchId) as List;
    final teams = (await supabase.from("compete_in_match").select().is_("match_id", matchId)) as List;
    final field = await fetchField(result.first['field_id']);
    final referee = await AuthServices.fetchUser(result.first['referee_id']);
    final teamInMatch = (await ref.read(fetchTeamsProvider.future))
        .where((element) => result.map((e) => e['team_id']).contains(element.id))
        .toList();

    final match = TournamentMatch.fromMap(result.first);
    match.field = field;
    match.referee = referee;

    final futures = teamInMatch.map((e) async {
      final players = await fetchMatchPlayers(matchId, e.id);
      return MatchTeam(team: e, players: players);
    });

    match.participantTeams = await Future.wait(futures);
    return match;
  }

  static Future<List<TournamentMatch>> fetchTournamentMatches(String tournamentID, Ref ref) async {
    final result = await supabase.from("match").select().match({"tournament_id": tournamentID}) as List;
    if (result.isEmpty) return [];
    final futures = result.map((matchJson) async {
      final teams =
          (await supabase.from("compete_in_match").select().match({"match_id": matchJson['match_id']})) as List;
      final field = await fetchField(matchJson['field_id']);
      final referee = await AuthServices.fetchUser(matchJson['referee_id']);
      final teamInMatch = (await ref.read(fetchTeamsProvider.future))
          .where((element) => teams.map((e) => e['team_id']).contains(element.id))
          .toList();

      final match = TournamentMatch.fromMap(matchJson);
      match.field = field;
      match.referee = referee;

      final teamFutures = teamInMatch.map((e) async {
        final players = await fetchMatchPlayers(match.id!, e.id);

        return MatchTeam(team: e, players: players);
      });

      match.participantTeams = await Future.wait(teamFutures);

      return match;
    });
    return await Future.wait(futures);
  }

  static Future<Field> fetchField(String fieldId) async {
    final result = (await supabase.from("field").select().match({"id": fieldId})) as List;

    return Field.fromMap(result.first);
  }

  static Future<List<MatchPlayer>> fetchMatchPlayers(String matchId, String teamId) async {
    final result = (await supabase.from("match_player").select().match({
      "match_id": matchId,
      'playfor': teamId,
    })) as List;
    if (result.isEmpty) return [];
    final futures = result.map((e) async {
      final matchPlayer = MatchPlayer.fromMap(e);

      matchPlayer.member = await AuthServices.fetchUser(e['kfupm_id']);
      matchPlayer.shots = await fetchPlayerMatchShots(e['kfupm_id'], matchId);
      matchPlayer.cards = await fetchPlayerMatchCards(e['kfupm_id'], matchId);

      return matchPlayer;
    });

    return await Future.wait(futures);
  }

  static Future<List<Shot>> fetchTeamShots(String forTeam, String matchId) async {
    final result = (await supabase.from("shots").select().match({
      "forteam": forTeam,
      "match_id": matchId,
    })) as List;

    final futures = result.map((e) async {
      final shot = Shot.fromMap(e);
      shot.againstTeam = await TeamServices.fetchTeam(e['againstteam']);
      shot.forTeam = await TeamServices.fetchTeam(e['forteam']);
      if (e['assistedby'] != null) shot.assistedBy = await AuthServices.fetchUser(e['assistedby']);
      shot.shotOnGoalie = await AuthServices.fetchUser(e['shoton']);
      shot.shotby = await AuthServices.fetchUser(e['shotby']);

      return shot;
    }).toList();

    return await Future.wait(futures);
  }

  static Future<List<TournamentPlayer>> fetchTournamentTeamPlayers(String tournamentId, String teamId) async {
    final result = (await supabase.from("tournament_roster").select().match({
      "tournament_id": tournamentId,
      "team_id": teamId,
    })) as List;
    if (result.isEmpty) return [];

    final futures = result.map((e) async {
      final player = await fetchTournamentPlayer(e['kfupm_id'], tournamentId);
      return player;
    });

    return await Future.wait(futures);
  }

  static Future<List<TournamentCard>> fetchPlayerTournamentCards(String kfupmId, String tournamentId) async {
    final result = (await supabase.from("card").select().match({
      "kfupm_id": kfupmId,
      "tournament_id": tournamentId,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => TournamentCard.fromMap(e)).toList();
  }

  static Future<List<Shot>> fetchPlayerTournamentShots(String kfupmId, String tournamentId) async {
    final result = (await supabase.from("shots").select().match({
      "shotby": kfupmId,
      "tournament_id": tournamentId,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => Shot.fromMap(e)).toList();
  }

  static Future<List<Shot>> fetchPlayerTournamentAssists(String kfupmId, String tournamentId) async {
    final result = (await supabase.from("shots").select().match({
      "assistedby": kfupmId,
      "tournament_id": tournamentId,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => Shot.fromMap(e)).toList();
  }

  static Future<List<Shot>> fetchPlayerTournamentShoton(String kfupmId, String tournamentId) async {
    final result = (await supabase.from("shots").select().match({
      "shoton": kfupmId,
      "tournament_id": tournamentId,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => Shot.fromMap(e)).toList();
  }

  static Future<TournamentPlayer> fetchTournamentPlayer(String kfupmId, String tournamentId) async {
    final member = await AuthServices.fetchUser(kfupmId);
    final shots = await fetchPlayerTournamentShots(kfupmId, tournamentId);
    final defendedShots = await fetchPlayerTournamentShoton(kfupmId, tournamentId);
    final assists = await fetchPlayerTournamentAssists(kfupmId, tournamentId);
    final cards = await fetchPlayerTournamentCards(kfupmId, tournamentId);

    return TournamentPlayer(
        memeber: member, cards: cards, shots: shots, defendedShots: defendedShots, assists: assists);
  }

  static Future<List<TournamentCard>> fetchPlayerMatchCards(String kfupmId, String matchID) async {
    final result = (await supabase.from("card").select().match({
      "kfupm_id": kfupmId,
      "match_id": matchID,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => TournamentCard.fromMap(e)).toList();
  }

  static Future<List<Shot>> fetchPlayerMatchShots(String kfupmId, String matchID) async {
    final result = (await supabase.from("shots").select().match({
      "shotby": kfupmId,
      "match_id": matchID,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => Shot.fromMap(e)).toList();
  }

  static Future<List<Shot>> fetchPlayerMatchAssists(String kfupmId, String matchID) async {
    final result = (await supabase.from("shots").select().match({
      "assistedby": kfupmId,
      "match_id": matchID,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => Shot.fromMap(e)).toList();
  }

  static Future<List<Shot>> fetchPlayerMatchShoton(String kfupmId, String matchID) async {
    final result = (await supabase.from("shots").select().match({
      "shoton": kfupmId,
      "match_id": matchID,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => Shot.fromMap(e)).toList();
  }

  static Future<MatchPlayer> fetchMatchPlayer(String kfupmId, String matchID, String teamID) async {
    final member = await AuthServices.fetchUser(kfupmId);
    final shots = await fetchPlayerMatchShots(kfupmId, matchID);
    final cards = await fetchPlayerMatchCards(kfupmId, matchID);
    return MatchPlayer(matchId: matchID, ismvp: false, team: teamID, member: member, shots: shots, cards: cards);
  }

  static Future<void> insertShot(Shot shot) async {
    await supabase.from("shots").insert(shot.toMap());
  }

  static Future<void> insertCard(TournamentCard card) async {
    await supabase.from("card").insert(card.toMap());
  }

  static Future<void> makePlayerSubstitution(
      {required MatchPlayer playerIn,
      required MatchPlayer playerOut,
      required String matchID,
      required DateTime happenendAt,
      required String teamID}) async {
    await supabase.from("player_in_out").insert({
      'playerleaving': playerOut.member!.kfupmId,
      'playerjoining': playerIn.member!.kfupmId,
      'happenedat': happenendAt.toIso8601String(),
      'team_id': teamID,
      'match_id': matchID,
    });
    //Player in
    await supabase.from("match_player").insert(playerIn.toMap());
    //Player Out
    supabase.from("match_player").update({
      "endedat": happenendAt.toIso8601String(),
    }).match({
      "kfupm_id": playerOut.member!.kfupmId!,
      "match_id": matchID,
      "playfor": teamID,
    }).is_("endat", null);
  }

  static Future<List<MatchSubstitution>> fetchMatchSubstitutions(String matchID) async {
    final result = (await supabase.from("player_in_out").select().match({
      "match_id": matchID,
    })) as List;
    if (result.isEmpty) return [];

    return result.map((e) => MatchSubstitution.fromMap(e)).toList();
  }
}
