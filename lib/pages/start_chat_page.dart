import 'package:flutter/material.dart';
import 'package:my_chat_app/pages/chat_page.dart';
import 'package:my_chat_app/utils/constants.dart';
import 'package:my_chat_app/utils/generator.dart';

class StartChatPage extends StatefulWidget {
  const StartChatPage({Key? key}) : super(key: key);


  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const StartChatPage(),
    );
  }

  @override
  State<StartChatPage> createState() => _StartChatPageState();
}

class _StartChatPageState extends State<StartChatPage> {
  final _formKey = GlobalKey<FormState>();

  final _roomNameController = TextEditingController();

  Future<void> _createRoomName() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final roomName = _roomNameController.text;
    try {
      String profileID = supabase.auth.currentSession!.user.id;
      await supabase.from('chat_rooms').insert(
        {
          'profile_id': profileID,
          'room_name': roomName,
          'encryption_key': sha1RandomString()
        },
      );
      Navigator.pop(context);
      Navigator.of(context).push(ChatPage.route());
    } catch (error) {
      context.showErrorSnackBar(message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {
            _createRoomName();
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  decoration: const InputDecoration(hintText: "Room Name"),
                  controller: _roomNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Room Name is Empty';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}