// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kfupm_football/core/models/kfupm_member.dart';

class Authentication extends ChangeNotifier {
  static final supabase = Supabase.instance.client;

  KFUPMMemeber? member;
  Session? session;
  Authentication({
    this.member,
    this.session,
  }) {
    retrieveUserData();
  }

  Authentication copyWith({
    KFUPMMemeber? member,
    Session? session,
  }) {
    return Authentication(
      member: member ?? this.member,
      session: session ?? this.session,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final res = await supabase.auth.signUp(password: password, email: email);
    // member = await AuthServices.fetchUserWithUid(session?.user.id ?? "");
    session = res.session;
    notifyListeners();
    return res;
  }

  void signout() {
    supabase.auth.signOut();
    session = null;
    member = null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(password: password, email: email);
    session = res.session;
    member = await AuthServices.fetchUserWithUid(session?.user.id ?? "");
    notifyListeners();
  }

  void setMember(KFUPMMemeber? member) {
    this.member = member;
    notifyListeners();
  }

  Future<void> retrieveUserData() async {
    if (session == null) return;
    member = await AuthServices.fetchUserWithUid(session!.user.id);
    notifyListeners();
    print(member?.email);
  }
}
