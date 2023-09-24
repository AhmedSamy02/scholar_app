import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF274460);
const kSenderColor = Color(0xFF006389);
const kMessagesCollection = 'messages';
const kMessage = 'body';
const kDate = 'Date';
const kSender = 'sender';
void showSnackBar(BuildContext currContext, String text) {
  ScaffoldMessenger.of(currContext).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.';
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address.';

  return null;
}
