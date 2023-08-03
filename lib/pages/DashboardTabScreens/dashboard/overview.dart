import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:get/get.dart';

import '../../../Values/values.dart';
import '../../../data/data_model.dart';
import '../../../model/OverviewTask.dart';
import '../../../route.dart';
import '../overview_task_container.dart';
import 'logic.dart';

class DashboardOverview extends StatelessWidget {
  DashboardOverview({Key? key}) : super(key: key);
  final logic = Get.put(DashboardLogic());
  final state = Get.find<DashboardLogic>().state;

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(child: Column(
      children: [

        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.overviewTasks.value.length,
          itemBuilder: (BuildContext context, int index) {
            OverviewTask task = state.overviewTasks.value[index];
            return ListTile(
              title:  GestureDetector(
                  onTap: (){
                    Get.toNamed(CHAT_PAGE);
                  },
                  child: OverviewTaskContainer(
                cardTitle: task.name,
                numberOfItems: task.languageType,
                imageUrl: task.imageUrl,
                backgroundColor: task.backgroundColor,
              ),)
            );
          },
        ))
      ],
    ),);
  }
}
