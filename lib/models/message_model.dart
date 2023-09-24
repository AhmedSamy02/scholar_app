import 'package:scholar_app/constants.dart';

class Message {
  final String message;
  final String sender;
  Message(this.message, this.sender);
  factory Message.fromJson(json) {
    return Message(
      json[kMessage],
      json[kSender],
    );
  }
}
