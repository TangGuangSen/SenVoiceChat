import 'package:get/get.dart';

import '../../../Values/values.dart';
import '../../../model/OverviewTask.dart';

class DashboardState {
  DashboardState() {
    ///Initialize variables
  }

  RxList<OverviewTask> overviewTasks = [
    OverviewTask(
      name: "Total Task",
      languageType: "16",
      imageUrl: "assets/orange_pencil.png",
      backgroundColor: HexColor.fromHex("EFA17D"),
    ),
    OverviewTask(
      name: "Completed",
      languageType: "32",
      imageUrl: "assets/green_pencil.png",
      backgroundColor: HexColor.fromHex("7FBC69"),
    ),
    OverviewTask(
      name: "Completed",
      languageType: "32",
      imageUrl: "assets/green_pencil.png",
      backgroundColor: HexColor.fromHex("7FBC69"),
    ),
    OverviewTask(
      name: "Completed",
      languageType: "32",
      imageUrl: "assets/green_pencil.png",
      backgroundColor: HexColor.fromHex("7FBC69"),
    ),
    OverviewTask(
      name: "Completed",
      languageType: "32",
      imageUrl: "assets/green_pencil.png",
      backgroundColor: HexColor.fromHex("7FBC69"),
    ),
    OverviewTask(
      name: "Completed",
      languageType: "32",
      imageUrl: "assets/green_pencil.png",
      backgroundColor: HexColor.fromHex("7FBC69"),
    ),
    OverviewTask(
      name: "Completed",
      languageType: "32",
      imageUrl: "assets/green_pencil.png",
      backgroundColor: HexColor.fromHex("7FBC69"),
    ),
    OverviewTask(
      name: "Total Projects",
      languageType: "8",
      imageUrl: "assets/cone.png",
      backgroundColor: HexColor.fromHex("EDA7FA"),
    ),
  ].obs;
}
