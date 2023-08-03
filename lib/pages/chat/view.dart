import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  final logic = Get.put(ChatLogic());
  final state = Get.find<ChatLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
