import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamServices {
  static final supabase = Supabase.instance.client;

  static Future<bool> postTeam(Team team, PlatformFile file) async {
    var success = false;

    final path = (await uploadFile("teams/${team.name}/${file.name}", file.bytes!));
    team.imageUrl = path;
    try {
      await supabase.from("team").insert(team.toTeamMap());
      team.toPhoneNumbers().forEach((element) async {
        await supabase.from("team_contactnumbers").insert(element);
      });

      success = true;
    } catch (e) {
      print(e.toString());
      print("Team Insertion Failed");
    }
    await assignTeamCoach(team.coach!.kfupmId!, team.id);
    await assignTeamManager(team.manager!.kfupmId!, team.id);
    return success;
  }

  static Future<void> assignTeamManager(String managerId, String teamId) async {
    await supabase
        .from("managed_team")
        .update({"endedat": DateTime.now().toIso8601String()}).match({"team_id": teamId}).is_("endedat", null);

    await supabase.from("managed_team").insert(
      {"startedat": DateTime.now().toIso8601String(), "manager_id": managerId, "team_id": teamId},
    );
  }

  static Future<void> assignTeamCoach(String coachId, String teamId) async {
    await supabase
        .from("coached_team")
        .update({"endedat": DateTime.now().toIso8601String()}).match({"team_id": teamId}).is_("endedat", null);

    await supabase.from("coached_team").insert(
      {"startedat": DateTime.now().toIso8601String(), "coach_id": coachId, "team_id": teamId},
    );
  }

  static Future<String> uploadFile(String path, Uint8List bytes) async {
    final relativePath = await supabase.storage.from("storage").uploadBinary(path, bytes);
    return supabase.storage.from("public").getPublicUrl(relativePath).replaceFirst("public/", "");
  }

  static Future<List<Team>> fetchTeams() async {
    final result = await supabase.from("team").select() as List;

    final teams = result.map((e) => Team.fromMap(e)).toList();

    final futures = await teams.map((team) async {
      team.players = await fetchTeamPlayers(team.id);

      try {
        final coachId = ((await supabase
                .from("coached_team")
                .select()
                .filter("team_id", "eq", team.id)
                .is_("endedat", null)) as List)
            .first['coach_id'];
        team.coach = await AuthServices.fetchUser(coachId);
      } catch (e) {
        print(e.toString());
      }
      try {
        final managerId = ((await supabase
                .from("managed_team")
                .select()
                .filter("team_id", "eq", team.id)
                .is_("endedat", null)) as List)
            .first['manager_id'];
        team.manager = await AuthServices.fetchUser(managerId);
      } catch (e) {
        print(e.toString());
      }
    });
    await Future.wait(futures);

    return teams;
  }

  static Future<List<KFUPMMemeber>> fetchTeamPlayers(String teamId) async {
    final result =
        (await supabase.from("player_play_in_team").select().eq("team_id", teamId).is_("leavedat", null)) as List;
    if (result.length == 0) return [];
    final ids = result.map((e) => e['kfupm_id']).toList();

    final users = (await AuthServices.fetchAllUsers()).where((element) => ids.contains(element.kfupmId)).toList();

    return users;
  }

  static Future<void> addPlayerInTeam(String playerKfupmId, String teamId) async {
    await supabase.from("player_play_in_team").insert({
      "joinedat": DateTime.now().toIso8601String(),
      "team_id": teamId,
      "kfupm_id": playerKfupmId,
    });
  }

  static Future<void> removePlayerFromTeam(String playerKfupmId, String teamId) async {
    await supabase.from("player_play_in_team").update({
      "leavedat": DateTime.now().toIso8601String(),
    }).match({"team_id": teamId, "kfupm_id": playerKfupmId}).is_(
      "leavedat",
      null,
    );
  }

  static Future<void> makeCaptain(String playerKfupmId, String teamId) async {
    await supabase.from("player_play_in_team").update({
      "iscaptain": false,
    }).match({"team_id": teamId}).is_(
      "iscaptain",
      true,
    );
    await supabase.from("player_play_in_team").update({
      "iscaptain": true,
    }).match({"team_id": teamId, "kfupm_id": playerKfupmId}).is_("leavedat", null);
  }

  static Future<Team> fetchTeam(String teamId) async {
    final result = await supabase.from("team").select().match({"id": teamId});
    return Team.fromMap(result.first);
  }
}
