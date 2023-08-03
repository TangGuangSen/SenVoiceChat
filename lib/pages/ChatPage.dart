import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/components/conversation.dart';
import 'package:get/get.dart';

import '../Values/values.dart';
import 'chat/chat.dart';


class ChatPage extends GetResponsiveView {


  @override
  Widget? phone() {
    return Scaffold(
        backgroundColor: AppColors.pageBgColor,
        appBar: AppBar(
        title: Column(crossAxisAlignment:CrossAxisAlignment.center,mainAxisAlignment:MainAxisAlignment.center,children: [Text('appTitle'.tr)],),
          backgroundColor: AppColors.primaryBackgroundColor,
      ),
      drawer: const ConversationWindow(),
      body: const ChatWindow(),
    );
  }

  @override
  Widget? desktop() {
    return Scaffold(
      body: Row(
        children: const [
          ConversationWindow(),
          Expanded(child: ChatWindow()),
        ],
      ),
    );
  }

  @override
  Widget? builder() {
    return super.builder();
  }



  // @override
  // Widget builder() {
  //   bool useTabs = screen.isPhone || screen.isTablet;
  //   return Scaffold(
  //     appBar: useTabs
  //         ? AppBar(
  //             title: Text('appTitle'.tr),
  //           )
  //         : null,
  //     drawer: useTabs ? const ConversationWindow() : null,
  //     body: Stack(
  //       children: [
  //         useTabs
  //             ? Row(
  //                 children: const [
  //                   ChatWindow(),
  //                 ],
  //               )
  //             : Row(
  //                 children: const [ConversationWindow(), ChatWindow()],
  //               ),
  //       ],
  //     ),
  //   );
  // }
}
