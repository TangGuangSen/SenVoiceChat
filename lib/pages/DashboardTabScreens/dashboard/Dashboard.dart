import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../Values/values.dart';
import '../../../data/data_model.dart';
import '../../../wedigets/Buttons/primary_tab_buttons.dart';
import '../../../wedigets/Shapes/app_settings_icon.dart';
import '../../../wedigets/task_progress_card.dart';
import 'logic.dart';
import 'overview.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  ValueNotifier<bool> _totalTaskTrigger = ValueNotifier(true);
  ValueNotifier<bool> _totalDueTrigger = ValueNotifier(false);
  ValueNotifier<bool> _totalCompletedTrigger = ValueNotifier(true);
  ValueNotifier<bool> _workingOnTrigger = ValueNotifier(false);
  ValueNotifier<int> _buttonTrigger = ValueNotifier(0);

  final dynamic data = AppData.progressIndicatorList;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppSpaces.verticalSpace20,
              Text("Hello,Dereck Doyle 👋",
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              AppSpaces.verticalSpace20,

              SizedBox(
                height: 138,
                child: TaskProgressCard(
                  cardTitle: data[0]['cardTitle'],
                  rating: data[0]['rating'],
                  progressFigure: data[0]['progress'],
                  percentageGap: int.parse(data[0]['progressBar']),
                ),
              ),
              AppSpaces.verticalSpace10,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //tab indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PrimaryTabButton(buttonText: "Overview", itemIndex: 0, notifier: _buttonTrigger),
                    PrimaryTabButton(buttonText: "Productivity", itemIndex: 1, notifier: _buttonTrigger)
                  ],
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: AppSettingsIcon(
                      callback: () {

                      },
                    ))
              ]),
              AppSpaces.verticalSpace20,
              Expanded(child:  ValueListenableBuilder(
                  valueListenable: _buttonTrigger,
                  builder: (BuildContext context, _, __) {
                    return _buttonTrigger.value == 0 ? DashboardOverview() : DashboardOverview();
                  }))

            ]),
        ));
  }
}
