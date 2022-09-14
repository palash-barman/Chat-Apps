
class MessageModel {
  String? type;
  String? sender;
  String? message;
  bool? seen;
  DateTime? time;

  MessageModel({this.type, this.sender, this.message, this.seen, this.time});

  MessageModel.fromMap(Map<String, dynamic> map) {
    type = map["type"];
    sender = map["sender"];
    message = map["message"];
    seen = map["seen"];
    time = map["time"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "sender": sender,
      "message": message,
      "seen": seen,
      "time": time
    };
  }
}