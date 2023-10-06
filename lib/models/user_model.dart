// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  UserModel copyWith({
    String? name,
    String? uid,
    String? profilePic,
    bool? isOnline,
    String? phoneNumber,
    List<String>? groupId,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      isOnline: isOnline ?? this.isOnline,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupId: (map['groupId'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, profilePic: $profilePic, isOnline: $isOnline, phoneNumber: $phoneNumber, groupId: $groupId)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.uid == uid &&
        other.profilePic == profilePic &&
        other.isOnline == isOnline &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.groupId, groupId);
  }

  @override
  int get hashCode {
    return name.hashCode ^ uid.hashCode ^ profilePic.hashCode ^ isOnline.hashCode ^ phoneNumber.hashCode ^ groupId.hashCode;
  }
}
