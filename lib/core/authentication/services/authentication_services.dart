import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthServices {
  static final supabase = Supabase.instance.client;

  static Future<void> postUser(KFUPMMemeber memeber) async {
    await supabase.from('person').insert(memeber.toPersonMap());
    await supabase.from('kfupm_member').insert(memeber.toKFUPMMemberMap());
    await supabase.from("person_phonenumbers").insert(memeber.toPhoneNumbers());
    if (memeber.type! == MemberType.player) {
      await supabase.from("player").insert({"kfupm_id": memeber.kfupmId});
    } else if (memeber.type! == MemberType.referee) {
      await supabase.from('referee').insert({
        {"kfupm_id": memeber.kfupmId, "referee_id": Uuid().v1()}
      });
    }
  }

  static Future<List<KFUPMMemeber>> fetchManagers(String? query) async {
    final k = await supabase
        .from("person")
        .select()
        .like("type", "${MemberType.manager.name}")
        .like("name", "%${query ?? ""}%") as List<dynamic>;
    return k.map((e) => KFUPMMemeber.fromTable(e)).toList();
  }

  static Future<List<KFUPMMemeber>> fetchReferees() async {
    final k = (await supabase.from("person").select().like("type", "${MemberType.referee.name}")) as List;
    if (k.isEmpty) return [];
    return k.map((e) => KFUPMMemeber.fromTable(e)).toList();
  }

  static Future<List<KFUPMMemeber>> fetchCoaches(String? query) async {
    final k = await supabase
        .from("person")
        .select()
        .like("type", "${MemberType.coach.name}")
        .like("name", "%${query ?? ""}%") as List<dynamic>;
    return k.map((e) => KFUPMMemeber.fromTable(e)).toList();
  }

  static Future<List<KFUPMMemeber>> fetchPlayers(String? query) async {
    final k = await supabase
        .from("person")
        .select()
        .like("type", "${MemberType.player.name}")
        .like("name", "%${query ?? ""}%") as List<dynamic>;
    return k.map((e) => KFUPMMemeber.fromTable(e)).toList();
  }

  static Future<List<KFUPMMemeber>> fetchAllUsers() async {
    final result = await supabase.from("person").select() as List;
    if (result.isEmpty) return [];
    return result.map((e) => KFUPMMemeber.fromTable(e)).toList();
  }

  static Future<KFUPMMemeber> fetchUser(String kfupmId) async {
    final k = ((await supabase.from("person").select().eq("kfupm_id", kfupmId)) as List)
        .map((e) => KFUPMMemeber.fromTable(e))
        .first;

    return k;
  }

  static Future<KFUPMMemeber> fetchUserWithUid(String uid) async {
    final k =
        ((await supabase.from("person").select().eq("uid", uid)) as List).map((e) => KFUPMMemeber.fromTable(e)).first;

    return k;
  }
}
