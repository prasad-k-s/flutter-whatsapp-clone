class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;

  Group(
      {required this.senderId,
      required this.name,
      required this.groupId,
      required this.lastMessage,
      required this.groupPic,
      required this.membersUid});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      groupPic: map['groupPic'] as String,
      membersUid: (map['membersUid'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}
