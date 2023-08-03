import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/components/markdown.dart';
import 'package:flutter_chatgpt/controller/conversation.dart';
import 'package:flutter_chatgpt/controller/message.dart';
import 'package:flutter_chatgpt/controller/prompt.dart';
import 'package:flutter_chatgpt/repository/conversation.dart';
import 'package:flutter_chatgpt/xfvoice/xfvoice/voice_to_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../Values/values.dart';
import '../../configs/translations.dart';

var uuid = const Uuid();

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // 定义一个 GlobalKey
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: GetX<MessageController>(
                builder: (controller) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToNewMessage();
                  });
                  if (controller.messageList.isNotEmpty) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: controller.messageList.length,
                      itemBuilder: (context, index) {
                        return _buildMessageCard(controller.messageList[index]);
                      },
                    );
                  } else {
                    return GetX<PromptController>(builder: ((controller) {
                      if (controller.prompts.isEmpty) {
                        return ListView(
                            controller: _scrollController,
                            children: const [
                              Center(
                                child: Center(child: Text("正在加载prompts...")),
                              )
                            ]);
                      } else if (controller.prompts.isNotEmpty) {
                        return Text("empty");
                      } else {
                        return ListView(
                            controller: _scrollController,
                            children: const [
                              Center(
                                child:
                                    Center(child: Text("加载prompts列表失败，请检查网络")),
                              )
                            ]);
                      }
                    }));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
              onTap: () {
                _recordVoice();
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  alignment: Alignment.center,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccentColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryAccentColor,
                      width: 1.4,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icon/audio.svg',
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                            Colors.white70, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        MyTranslations.TR_NAME_CLICK_SPEAK.tr,
                        style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  )))
        ],
      ),
    );
  }

  Conversation _newConversation(String name, String description) {
    var conversation = Conversation(
      name: name,
      description: description,
      uuid: uuid.v4(),
    );
    return conversation;
  }

  Future<void> _recordVoice() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      Get.defaultDialog(
          title: MyTranslations.TR_NAME_PERMISSION_TITLE.tr,
          middleText: MyTranslations.TR_NAME_PERMISSION_VOICE_CONTENT.tr,
          backgroundColor: AppColors.primaryBackgroundColor,
          radius: 8,
          barrierDismissible: false,
          titleStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.normal),
          middleTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          textConfirm: MyTranslations.TR_NAME_BUTTON_OK.tr,
          buttonColor: AppColors.primaryBackgroundColor,
          confirmTextColor: AppColors.primaryAccentColor,
          onConfirm: () {
            Navigator.pop(context);
            AppSettings.openAppSettings();
          });
      return;
    }
    Get.bottomSheet(
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Container(
              color: AppColors.primaryBackgroundColor, // 将容器的背景颜色设置为白色
              padding: const EdgeInsets.all(16),
              child: Wrap(
                children: [
                  VoiceText(
                    onSendText: (value) {
                      _sendMessage(value);
                    },
                  )
                ],
              )),
        ),
        isDismissible: false,
        enableDrag: false);
  }

  void _sendMessage(String message) {
    final MessageController messageController = Get.find();
    final ConversationController conversationController = Get.find();
    if (message.isNotEmpty) {
      var conversationUuid =
          conversationController.currentConversationUuid.value;
      if (conversationUuid.isEmpty) {
        // new conversation
        //message 的前10个字符，如果message不够10个字符，则全部
        var conversation = _newConversation(
            message.substring(0, message.length > 20 ? 20 : message.length),
            message);
        conversationUuid = conversation.uuid;
        conversationController.setCurrentConversationUuid(conversationUuid);
        conversationController.addConversation(conversation);
      }
      final newMessage = Message(
        conversationId: conversationUuid,
        role: Role.user,
        text: message,
      );
      messageController.addMessage(newMessage);
      // _formKey.currentState!.reset();
    }
  }

  Widget _buildMessageCard(Message message) {
    if (message.role == Role.user) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FaIcon(FontAwesomeIcons.person),
              SizedBox(
                width: 5,
              ),
              Text("User"),
              SizedBox(
                width: 10,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(
                        message.text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              const FaIcon(FontAwesomeIcons.robot),
              const SizedBox(
                width: 5,
              ),
              Text(message.role == Role.system ? "System" : "assistant"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: Markdown(text: message.text),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }



  void _scrollToNewMessage() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 800), curve: Curves.ease);
    }
  }

}


