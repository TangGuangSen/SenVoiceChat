import 'package:flutter_chatgpt/pages/MBottomNavigattionBar.dart';
import 'package:flutter_chatgpt/pages/ChatPage.dart';
import 'package:flutter_chatgpt/pages/second.dart';
import 'package:flutter_chatgpt/pages/setting.dart';
import 'package:flutter_chatgpt/pages/splash_screen.dart';
import 'package:get/get.dart';

const HOME_PAGE = "/";
const CONSTANTS_PAGE = "/second";
const CHAT_PAGE = "/chat";
const SPLASH_PAGE = "/splash_page";

final routes = [
  GetPage(name: HOME_PAGE, page: () => MBottomNavigattionBar()),
  GetPage(name: SPLASH_PAGE, page: () => SplashScreen()),
  GetPage(name: '/second', page: () => const SecondPage()),
  GetPage(name: '/setting', page: () =>  SettingPage()),
  GetPage(name: CHAT_PAGE, page: () =>  ChatPage()),
];
