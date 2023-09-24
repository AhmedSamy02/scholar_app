/*
*Difference between FutureBuilder and StreamBuilder
?FutureBuilder
requests the data for one time and waits on it until it reaches and stop listening
to the changes
?StreamBuilder
It always listens to the data and all the changes that may occurs to it you can say it's
LiveData listener


*/

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scholar_app/constants.dart';
import 'package:scholar_app/models/message_model.dart';
import 'package:scholar_app/screens/login_screen.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'HomeScreen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  GlobalKey<FormState> messageKey = GlobalKey();

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  TextEditingController messageController = TextEditingController();

  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
      .collection(kMessagesCollection)
      .orderBy(kDate)
      .snapshots();
  final ScrollController scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    email = ModalRoute.of(context)!.settings.arguments as String;
  }

  late final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Sign Out'),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              }
            },
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Image.asset(
                'assets/images/scholar.png',
              ),
            ),
            const Text('Chat')
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
            stream: _messagesStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  }
                });
                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<Message> messagesList = [];
                            for (var i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              messagesList.add(
                                  Message.fromJson(snapshot.data!.docs[i]));
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: BubbleSpecialThree(
                                text: messagesList[index].message,
                                isSender: messagesList[index].sender == email,
                                color: messagesList[index].sender == email
                                    ? kSenderColor
                                    : kPrimaryColor,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    MessageBar(
                      onSend: (value) {
                        sendMessage(value);
                        //*Controlling your scroll in the list
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastEaseInToSlowEaseOut);
                      },
                      messageBarColor: const Color.fromARGB(38, 39, 68, 96),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      Fluttertoast.showToast(msg: 'Can\'t Send an empty message');
    }
    return null;
  }

  Future<void> sendMessage(String data) {
    // Call the user's CollectionReference to add a new user
    return messages
        .add({
          kMessage: data,
          kDate: DateTime.now().toUtc().toIso8601String(),
          kSender: email,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
