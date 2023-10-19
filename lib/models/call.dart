class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverPic;
  final String receiverName;
  final String receiverId;
  final String callId;
  final bool hasDialled;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverPic,
    required this.receiverName,
    required this.callId,
    required this.hasDialled,
    required this.receiverId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverPic': receiverPic,
      'receiverName': receiverName,
      'receiverId': receiverId,
      'callId': callId,
      'hasDialled': hasDialled,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerPic: map['callerPic'] as String,
      receiverPic: map['receiverPic'] as String,
      receiverName: map['receiverName'] as String,
      receiverId: map['receiverId'] as String,
      callId: map['callId'] as String,
      hasDialled: map['hasDialled'] as bool,
    );
  }
}
