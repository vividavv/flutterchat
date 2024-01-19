import 'package:flutter/material.dart';
import 'package:my_chat_app/models/chat_room.dart';
import 'package:my_chat_app/pages/chat_page.dart';
import 'package:my_chat_app/pages/register_page.dart';
import 'package:my_chat_app/pages/start_chat_page.dart';
import 'package:my_chat_app/utils/constants.dart';


class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);


  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatRoomPage(),
    );
  }

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  var chatRooms;

  Future<List<Map<String, dynamic>>> _getChatRoom() async {
    chatRooms = supabase.from('chat_rooms').select().order('created_at');
    return chatRooms;
  }

  @override
  void initState() {
    super.initState();
    _getChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            supabase.auth.signOut();
            Navigator.of(context)
                .pushAndRemoveUntil(RegisterPage.route(), (route) => false);
          }, icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StartChatPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getChatRoom(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                ChatRoom chatRoom =
                    ChatRoom.fromMap(map: snapshot.data![index]);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(chatRoom.roomName.substring(0, 1)),
                  ),
                  title: Text(chatRoom.roomName),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatRoomId: chatRoom.id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}