import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../Values/values.dart';
import '../wedigets/DarkBackground/darkRadialBackground.dart';
import '../wedigets/bottomNavigationItem.dart';
import '../wedigets/dashboard_add_icon.dart';
import 'DashboardTabScreens/dashboard/Dashboard.dart';
import 'ChatPage.dart';

class MBottomNavigattionBar extends StatefulWidget {
  MBottomNavigattionBar({Key? key}) : super(key: key);

  @override
  _MBottomNavigattionBarState createState() => _MBottomNavigattionBarState();
}
class _MBottomNavigattionBarState extends State<MBottomNavigattionBar> with AutomaticKeepAliveClientMixin {
  final ValueNotifier<int> bottomNavigatorTrigger = ValueNotifier<int>(0);


  final PageController _controller = PageController(initialPage: 0);


  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    bottomNavigatorTrigger.addListener(() {
      _controller.jumpToPage(bottomNavigatorTrigger.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: AppColors.pageBgColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          PageView(
            scrollDirection: Axis.horizontal, // 指定水平方向
            physics: const NeverScrollableScrollPhysics(), // 禁止滑动
            controller: _controller,
            children: [
              Dashboard(),
              ChatPage(),
            ],
          )
        ]),
        bottomNavigationBar: Container(
            width: double.infinity,
            height: 90,
            padding: EdgeInsets.only(top: 10, right: 30, left: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: HexColor.fromHex("#181a1f").withOpacity(0.8)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomNavigationItem(
                      itemIndex: 0,
                      notifier: bottomNavigatorTrigger,
                      icon: Icons.widgets),
                  Spacer(),
                  BottomNavigationItem(
                      itemIndex: 1,
                      notifier: bottomNavigatorTrigger,
                      icon: FeatherIcons.clipboard),
                  Spacer(),
                  DashboardAddButton(
                    iconTapped: (() {
                      // showAppBottomSheet(Container(
                      //     height: Utils.screenHeight * 0.8,
                      //     child: DashboardAddBottomSheet()));
                    }),
                  ),
                  Spacer(),
                  BottomNavigationItem(
                      itemIndex: 2,
                      notifier: bottomNavigatorTrigger,
                      icon: FeatherIcons.bell),
                  Spacer(),
                  BottomNavigationItem(
                      itemIndex: 3,
                      notifier: bottomNavigatorTrigger,
                      icon: FeatherIcons.search)
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}
