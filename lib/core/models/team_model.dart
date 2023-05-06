import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/location_model.dart';
import 'package:kfupm_football/core/models/player_model.dart';

class Team {
  String id;
  Location location;
  String website;
  String email;
  KFUPMMemeber? manager;
  KFUPMMemeber? coach;
  List<KFUPMMemeber>? coaches;
  List<KFUPMMemeber>? managers;
  List<String> contactNumbers;
  List<KFUPMMemeber>? players;
  String? imageUrl;
  String name;
  Team({
    this.players,
    this.coaches,
    this.managers,
    required this.name,
    this.imageUrl,
    required this.id,
    required this.location,
    required this.website,
    required this.email,
    this.manager,
    this.coach,
    required this.contactNumbers,
  });

  Team copyWith({
    String? id,
    String? name,
    Location? location,
    String? website,
    String? email,
    KFUPMMemeber? manager,
    KFUPMMemeber? coach,
    List<String>? contactNumbers,
    String? imageUrl,
  }) {
    return Team(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      location: location ?? this.location,
      website: website ?? this.website,
      email: email ?? this.email,
      manager: manager ?? this.manager,
      coach: coach ?? this.coach,
      contactNumbers: contactNumbers ?? this.contactNumbers,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'location': location.toMap()});
    result.addAll({'website': website});
    result.addAll({'email': email});
    result.addAll({'manager': manager?.toMap()});
    result.addAll({'coach': coach?.toMap()});
    result.addAll({'contactNumbers': contactNumbers});
    result.addAll({"imageUrl": imageUrl});
    result.addAll({'name': name});
    return result;
  }

  Map<String, dynamic> toTeamMap() {
    return {
      'building': location.building,
      'room': location.room,
      "name": name,
      "imageUrl": imageUrl,
      "website": website,
      "email": email,
      "id": id,
    };
  }

  List<Map<String, dynamic>> toPhoneNumbers() {
    return contactNumbers.map((e) => {"number": e, "team_id": id}).toList();
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      name: map["name"],
      imageUrl: map['imageUrl'],
      id: map['id'] ?? '',
      location: Location(building: map['building'], room: map['room']),
      website: map['website'] ?? '',
      email: map['email'] ?? '',
      contactNumbers: List<String>.from([]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Team.fromJson(String source) => Team.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Team(id: $id, location: $location, website: $website, email: $email, manager: $manager, coach: $coach, contactNumbers: $contactNumbers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Team &&
        other.id == id &&
        other.location == location &&
        other.website == website &&
        other.email == email &&
        other.manager == manager &&
        other.coach == coach &&
        listEquals(other.contactNumbers, contactNumbers);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        location.hashCode ^
        website.hashCode ^
        email.hashCode ^
        manager.hashCode ^
        coach.hashCode ^
        contactNumbers.hashCode;
  }
}
