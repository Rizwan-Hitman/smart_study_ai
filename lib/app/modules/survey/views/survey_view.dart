import 'package:ai_work_assistant/app/data/study_plan_data.dart';
import 'package:ai_work_assistant/services/database_service.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:ai_work_assistant/app/modules/survey/controllers/survey_controller.dart';
import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:ai_work_assistant/utills/star_feedback_widget.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:glass/glass.dart';

class SurveyScreen extends GetView<SurveyController> {
  @override
  Widget build(BuildContext context) {
    controller.context = context;

    List<String> categories = [
      "Education",
      "Programming",
      "Mathematics",
      "Science",
      "Technology",
      "Engineering",
      "Medical",
      "Business",
      // "Finance",
      "Psychology",
      "History",
      "Literature",
      "Art & Design",
      "Music",
      // "Self-Improvement",
      // "Marketing",
      "Health & Fitness",
      "Cybersecurity",
      "Data Science",
      "Machine Learning",
      "Blockchain",
      // "Political Science",
      "Geography",
      "Biotechnology",
      "Sociology",
      "Creative Writing",
      "UX/UI Design",
      "Game Development",
    ];

    // categories.
    categories.shuffle();
    categories.sort();
    categories.add("Other");
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async {
        return controller.backButtonHandle(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,

        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical * 1),
        //   child: AppBar(
        //     systemOverlayStyle: SystemUiOverlayStyle.light,
        //     backgroundColor: AppColors.backgroundColor,
        //   ),
        // ),
        body: Obx(
          () =>
              controller.finalizingSurvey.value
                  ? loadingWidget(context)
                  : SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // LinearProgressIndicator(
                        //   value: (controller.currentStep.value + 1) / 6,
                        // ),
                        Container(
                          // margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: SizeConfig.blockSizeHorizontal * 3,
                          //   vertical: SizeConfig.blockSizeHorizontal * 8,
                          // ),
                          child: Expanded(
                            child: _getStepWidget(
                              controller,
                              context,
                              categories,
                            ),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeHorizontal * 25,
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 12,
                          ),
                          color: AppColors.bottomSurveyBarColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              !controller.isNewUser.value ||
                                      controller.currentStep.value > 0
                                  ? InkWell(
                                    onTap: controller.prevStep,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.backAndNextButton,
                                      child: SizedBox(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 30,
                                        height:
                                            SizeConfig.blockSizeHorizontal * 10,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                    SizeConfig
                                                        .blockSizeHorizontal *
                                                    4,
                                              ),
                                              Icon(
                                                controller.currentStep.value > 0
                                                    ? Icons
                                                        .keyboard_arrow_left_rounded
                                                    : Icons.home,
                                                size:
                                                    controller
                                                                .currentStep
                                                                .value >
                                                            0
                                                        ? SizeConfig
                                                                .blockSizeHorizontal *
                                                            8
                                                        : SizeConfig
                                                                .blockSizeHorizontal *
                                                            6,
                                                color:
                                                    AppColors
                                                        .backAndNextIconColor,
                                              ),
                                              SizedBox(
                                                width:
                                                    SizeConfig
                                                        .blockSizeHorizontal *
                                                    2,
                                              ),
                                              Text(
                                                controller.currentStep.value > 0
                                                    ? "Back"
                                                    : "Home",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.mulish(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(),
                              Container(
                                child: InkWell(
                                  onTap: () {
                                    controller.nextStep(context);
                                  },
                                  child: Material(
                                    color: AppColors.backAndNextButton,
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 30,
                                      height:
                                          SizeConfig.blockSizeHorizontal * 10,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width:
                                                  SizeConfig
                                                      .blockSizeHorizontal *
                                                  8,
                                            ),
                                            Text(
                                              controller.currentStep.value == 4
                                                  ? "Finish"
                                                  : "Next",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.mulish(
                                                fontWeight: FontWeight.w700,

                                                color: AppColors.textColor,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig
                                                      .blockSizeHorizontal *
                                                  2,
                                            ),
                                            Icon(
                                              controller.currentStep.value == 4
                                                  ? Icons.check
                                                  : Icons
                                                      .keyboard_arrow_right_rounded,
                                              size:
                                                  controller
                                                              .currentStep
                                                              .value ==
                                                          4
                                                      ? SizeConfig
                                                              .blockSizeHorizontal *
                                                          6
                                                      : SizeConfig
                                                              .blockSizeHorizontal *
                                                          8,
                                              color:
                                                  AppColors
                                                      .backAndNextIconColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: controller.nextStep,
                              //   child: Text(
                              //     controller.currentStep.value == 4 ? "Finish" : "Next",
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _getStepWidget(
    SurveyController controller,
    BuildContext context,
    List<String> categories,
  ) {
    switch (controller.currentStep.value) {
      case 0:
        return _studyCategoryStep(controller, categories);
      case 1:
        return _preferredDaysStep(controller);
      case 2:
        return _targetDurationStep(controller, context);
      case 3:
        return _dailyStudyDurationStep(controller, context);
      case 4:
        return _attachFilesStep(controller);
      default:
        return Container();
    }
  }

  Widget _studyCategoryStep(
    SurveyController controller,
    List<String> categories,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        progressWithTextWidget(
          "Study category selection",
          "(Please select only one from the following options.)",
        ),
        Obx(
          () => ChipsChoice.single(
            wrapped: true,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3,
            ),
            alignment: WrapAlignment.center,
            spacing: SizeConfig.blockSizeHorizontal * 2,
            runSpacing: SizeConfig.blockSizeHorizontal * 3,
            choiceCheckmark: false,

            value: controller.studyCategory.value,
            onChanged: (value) => controller.studyCategory.value = value,
            choiceItems: C2Choice.listFrom<String, String>(
              source: categories,
              value: (index, item) => item,
              label: (index, item) => item,
            ),
            // wrapped: true, // Ensures chips wrap instead of horizontal scroll
            choiceStyle: C2ChipStyle.filled(
              // shadowColor: AppColors.foreground,
              height: SizeConfig.blockSizeHorizontal * 9,
              color: AppColors.chipsChoiceUnSelected,
              foregroundColor: AppColors.background2,
              elevation: 4,
              foregroundStyle: GoogleFonts.publicSans(
                fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                // fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
              selectedStyle: C2ChipStyle(
                backgroundColor:
                    AppColors.chipsChoiceSelected, // Selected chip color
                foregroundColor: AppColors.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _preferredDaysStep(SurveyController controller) {
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return Column(
      children: [
        progressWithTextWidget(
          "Preferred study days",
          "(Please mention the days allocated for working on the task.)",
        ),
        ChipsChoice.multiple(
          wrapped: true,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 5,
            vertical: SizeConfig.blockSizeHorizontal * 5,
          ),
          alignment: WrapAlignment.center,
          spacing: SizeConfig.blockSizeHorizontal * 4,
          runSpacing: SizeConfig.blockSizeHorizontal * 5,
          choiceCheckmark: true,

          value: controller.preferredDays,
          onChanged: (selected) {
            print("$selected");

            controller.preferredDays.assignAll(selected);
          },
          choiceItems: C2Choice.listFrom<String, String>(
            source: days,
            value: (index, item) => item,
            label: (index, item) => item,
          ),
          choiceStyle: C2ChipStyle.filled(
            height: SizeConfig.blockSizeHorizontal * 9,
            color: AppColors.chipsChoiceUnSelected,
            foregroundColor: AppColors.background2,
            elevation: 10,
            foregroundStyle: GoogleFonts.publicSans(
              fontSize: SizeConfig.blockSizeHorizontal * 4.5,
              // fontWeight: FontWeight.w500,
              letterSpacing: 4,
            ),
            selectedStyle: C2ChipStyle(
              backgroundColor: AppColors.chipsChoiceSelected,
              foregroundColor: AppColors.foreground,
            ),
          ),
        ),

        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        Container(
          child: Text(
            "Days selected: ${controller.preferredDays.length}",
            style: GoogleFonts.publicSans(
              letterSpacing: 1,
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              color: AppColors.textColor,
              // letterSpacing: 2,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 10),
              child: Text(
                "You will be notified on the selected days.",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: SizeConfig.blockSizeHorizontal * 3.2,
                  color: AppColors.textColor,
                  letterSpacing: 1.1,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _targetDurationStep(
    SurveyController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        progressWithTextWidget(
          "Target completion date",
          "(Please specify the date by which the task should be completed.)",
        ),

        // Display total selected days

        // Table Calendar
        Obx(
          () => Container(
            margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
            child: Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.calenderBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.calenderBackgroundColor,
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(4, 12),
                  ),
                ],
              ),

              child: TableCalendar(
                rangeStartDay: controller.selectedStartDate.value,
                rangeEndDay: controller.selectedEndDate.value,
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 20)), // 1-year range
                focusedDay: controller.selectedEndDate.value,
                rowHeight: SizeConfig.blockSizeHorizontal * 15,
                daysOfWeekHeight: SizeConfig.blockSizeHorizontal * 10,
                selectedDayPredicate:
                    (day) => isSameDay(controller.selectedEndDate.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectedEndDate.value = selectedDay;
                  controller.targetDuration.value = controller.totalDays;
                },
                onDayLongPressed: (selectedDay, focusedDay) {
                  controller.selectedStartDate.value = selectedDay;
                  controller.selectedEndDate.value = focusedDay;
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  headerPadding: EdgeInsets.all(
                    SizeConfig.blockSizeHorizontal * 4,
                  ),
                  formatButtonTextStyle: TextStyle(color: AppColors.textColor),
                  formatButtonDecoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.weekdaysLabelColor),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  titleTextStyle: TextStyle(
                    color: AppColors.weekdaysLabelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: AppColors.weekdaysLabelColor),
                  weekendStyle: TextStyle(color: AppColors.weekendLabelColor),
                ),
                headerVisible: true,
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                  // rangeHighlightColor: AppColors.textColor,
                  rangeEndTextStyle: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  rangeStartTextStyle: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  rangeStartDecoration: BoxDecoration(
                    color: AppColors.foreground,
                    shape: BoxShape.circle,
                  ),
                  withinRangeDecoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  withinRangeTextStyle: TextStyle(color: AppColors.textColor),
                  rangeHighlightColor: AppColors.backgroundColor,
                  selectedDecoration: BoxDecoration(
                    color: AppColors.foreground,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                    color: AppColors.chipsChoiceSelected,
                    fontWeight: FontWeight.w700,
                  ),
                  defaultTextStyle: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  outsideTextStyle: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                  disabledTextStyle: TextStyle(color: AppColors.foreground),

                  // withinRangeTextStyle: TextStyle(color: AppColors.textColor),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
        Obx(
          () => Text(
            "Study Days: ${controller.totalStudyDays}",
            style: GoogleFonts.publicSans(
              letterSpacing: 1,
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              // fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
        Obx(
          () => Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 8),
            child: Text(
              "Total Days: ${controller.totalDays}",
              style: GoogleFonts.publicSans(
                letterSpacing: 1,
                fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                // fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              // color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeHorizontal * 8,
              ),
              child: Text(
                "Study Days are calculated based on your preferred days.",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: SizeConfig.blockSizeHorizontal * 2.7,
                  color: AppColors.textColor,
                  letterSpacing: 1.1,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dailyStudyDurationStep(
    SurveyController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        progressWithTextWidget(
          "Daily study duration",
          "(Please specify the time in minutes that can be spent on the task daily.)",
        ),

        Container(
          // color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 4,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customClockPart(
                    "${CommonMethods.hoursFormat(controller.fromTime.value.hour).toString().padLeft(2, "0")}:${controller.fromTime.value.minute.toString().padLeft(2, "0")}",
                    "${controller.fromTime.value.period.toString().endsWith("am") ? "AM" : "PM"}",
                    "Start",
                  ),
                  Text(
                    " ",
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 60,
                      color: AppColors.foreground,
                    ),
                  ),
                  customClockPart(
                    "${CommonMethods.hoursFormat(controller.toTime.value.hour).toString().padLeft(2, "0")}:${controller.toTime.value.minute.toString().padLeft(2, "0")}",
                    "${controller.toTime.value.period.toString().endsWith("am") ? "AM" : "PM"}",
                    "End",
                  ),
                ],
              ),

              Visibility(
                // visible:
                //     controller.dailyStudyDuration.value == 0 ? false : true,
                child: Container(
                  child: Text(
                    "Study Duration: ${CommonMethods.formattedDuration(controller.dailyStudyDuration.value)}",
                    style: GoogleFonts.publicSans(
                      letterSpacing: 1,
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      color: AppColors.textColor,
                      // letterSpacing: 2,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.blockSizeHorizontal * 20),
              // SizedBox(
              //   width: SizeConfig.blockSizeHorizontal * 50,
              //   child: InkWell(
              //     onTap: () {
              //       showDialog(
              //         context: context,
              //         builder:
              //             (context) => FromToTimePicker(
              //               onTab: (from, to) {
              //                 final messenger = ScaffoldMessenger.of(context);

              //                 // Remove any existing snackbars before showing a new one
              //                 messenger.removeCurrentSnackBar();

              //                 if (from.isAfter(to)) {
              //                   messenger.showSnackBar(
              //                     SnackBar(
              //                       duration: Duration(seconds: 1),
              //                       content: Text(
              //                         "Start time cannot be in future.",
              //                       ),
              //                     ),
              //                   );
              //                 } else if (from == to) {
              //                   messenger.showSnackBar(
              //                     SnackBar(
              //                       duration: Duration(seconds: 1),
              //                       content: Text(
              //                         "Start time cannot be same as End time.",
              //                       ),
              //                     ),
              //                   );
              //                 } else {
              //                   controller.updateAvailability(from, to);
              //                   Navigator.pop(context);
              //                 }
              //               },
              //               dialogBackgroundColor: AppColors.backgroundColor,
              //               fromHeadlineColor: AppColors.textColor,
              //               toHeadlineColor: AppColors.textColor,
              //               upIconColor: AppColors.textColor,
              //               downIconColor: AppColors.textColor,
              //               timeBoxColor: AppColors.chipsChoiceUnSelected,
              //               timeHintColor: AppColors.background2,
              //               timeTextColor: AppColors.textColor,
              //               dividerColor: Color(0xFF121212),
              //               doneTextColor: AppColors.weekendLabelColor,
              //               dismissTextColor: AppColors.chipsChoiceUnSelected,
              //               defaultDayNightColor:
              //                   AppColors.chipsChoiceUnSelected,
              //               defaultDayNightTextColor: AppColors.textColor,
              //               colonColor: Colors.white,
              //               showHeaderBullet: true,
              //               doneText: "Confirm",
              //               dismissText: "Cancel",
              //               fromHeadline: "Start time",
              //               toHeadline: "End time",
              //             ),
              //       );
              //     },
              //     borderRadius: BorderRadius.circular(
              //       15,
              //     ), // Smooth ripple effect
              //     child: Container(
              //       decoration: BoxDecoration(
              //         boxShadow: [
              //           BoxShadow(
              //             color: AppColors.chipsChoiceUnSelected,
              //             blurRadius: 8,
              //             offset: Offset(0, 6),
              //           ),
              //         ],
              //       ),
              //       child: Material(
              //         color:
              //             AppColors.chipsChoiceUnSelected, // Background color
              //         borderRadius: BorderRadius.circular(15),
              //         child: Padding(
              //           padding: EdgeInsets.all(
              //             SizeConfig.blockSizeHorizontal * 5,
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: [
              //               Text(
              //                 "Manage Time",
              //                 style: GoogleFonts.tektur(
              //                   color: Colors.white,
              //                   fontSize: SizeConfig.blockSizeHorizontal * 4,
              //                 ),
              //               ),
              //               Icon(
              //                 Icons.access_time_filled_sharp,
              //                 color: Colors.white,
              //                 size: SizeConfig.blockSizeHorizontal * 6.5,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget customClockPart(String time, String period, String startEnd) {
    return GestureDetector(
      onTap: () {
        Navigator.of(controller.context).push(
          showPicker(
            iosStylePicker: true,
            backgroundColor: AppColors.clockBackgroundColor,
            okStyle: GoogleFonts.aBeeZee(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            cancelStyle: GoogleFonts.aBeeZee(
              color: AppColors.clockForegroundColor,
            ),
            hmsStyle: TextStyle(color: AppColors.textColor),
            okText: "OK",
            accentColor: AppColors.textColor,
            unselectedColor: AppColors.clockForegroundColor,
            blurredBackground: true,
            amLabel: "AM",
            pmLabel: "PM",
            value:
                startEnd == "Start"
                    ? Time(
                      hour: controller.fromTime.value.hour,
                      minute: controller.fromTime.value.minute,
                    )
                    : Time(
                      hour: controller.toTime.value.hour,
                      minute: controller.toTime.value.minute,
                    ),
            onChange: (value) {
              startEnd == "Start"
                  ? controller.updateFromTime(value)
                  : controller.updateToTime(value);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.clockBackgroundColor,
              blurRadius: 15,
              offset: Offset(4, 15),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: AppColors.clockBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            color: AppColors.clockBackgroundColor,
          ),
          margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 0.5),
          child: Container(
            decoration: BoxDecoration(
              // color: AppColors.clockBackgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            width: SizeConfig.screenWidth * 0.32,
            height: SizeConfig.blockSizeVertical * 26,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.blockSizeHorizontal * 11,
                  // width: double.infinity,
                  child: Center(
                    child: Text(
                      startEnd,
                      style: GoogleFonts.openSans(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        color: AppColors.textColor,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: SizeConfig.blockSizeHorizontal * 40,
                  width: SizeConfig.blockSizeHorizontal * 28,
                  decoration: BoxDecoration(
                    color: AppColors.clockForegroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textForCustomClock(time, 2),
                      textForCustomClock(period, 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textForCustomClock(String text, int padding) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * padding),
      child: Text(
        text,
        // style: GoogleFonts.dosis(
        style: GoogleFonts.tektur(
          shadows: [
            Shadow(
              color: const Color.fromARGB(39, 192, 192, 192),
              blurRadius: 10,
              offset: Offset(3, 6),
            ),
          ],
          fontSize: SizeConfig.blockSizeHorizontal * 5.5,
          color: AppColors.textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _attachFilesStep(SurveyController controller) {
    return Obx(
      () => Column(
        children: [
          progressWithTextWidget(
            "Study material attachment (PDFs)",
            "(Please attach a PDF file containing study material, if available.)",
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal * 20),
          GestureDetector(
            onTap: () {
              controller.pickFile();
            },
            child: DottedBorder(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 10,
                vertical: SizeConfig.blockSizeHorizontal * 20,
              ),
              strokeWidth: 3,
              dashPattern: [15, 14],
              color: AppColors.background2,
              child: Container(
                child: Icon(
                  Icons.upload_file_outlined,
                  size: SizeConfig.blockSizeHorizontal * 50,
                  color: AppColors.background2,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 10),
                child: Text(
                  controller.attachedFilesName.isEmpty
                      ? "Upload a file"
                      : "${controller.attachedFilesName[0]!}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: SizeConfig.blockSizeHorizontal * 4,
                    color: AppColors.textColor,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column progressWithTextWidget(String question, String questionDesc) {
    return Column(
      children: [
        Container(
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(color: AppColors.textColor, width: 2),
          //   ),
          // ),
          width: double.infinity,
          // color: AppColors.background2,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 4,
            vertical: SizeConfig.blockSizeHorizontal * 3.5,
          ),
          child: Text(
            textAlign: TextAlign.start,
            question.toUpperCase(),
            style: GoogleFonts.openSans(
              fontSize: SizeConfig.blockSizeHorizontal * 4.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
        LinearProgressIndicator(
          value: (controller.currentStep.value + 1) / 5,
          color: AppColors.chipsChoiceSelected,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeHorizontal * 4,
            horizontal: SizeConfig.blockSizeHorizontal * 3.5,
          ),
          child: Text(
            textAlign: TextAlign.center,
            questionDesc,
            style: GoogleFonts.openSans(
              fontSize: SizeConfig.blockSizeHorizontal * 3.2,
              // fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Obx(
      () => Container(
        child: AnimateGradient(
          duration: Duration(seconds: 4),
          primaryBegin: Alignment.topLeft, // 🔻 Start from Bottom Left
          primaryEnd: Alignment.center, // 🔺 Move towards Top Right
          secondaryBegin: Alignment.center, // 🔺 Start from Top Right
          secondaryEnd: Alignment.bottomRight, // 🔻 Move towards Bottom Left
          primaryColors: const [
            Color(0xFF0A043C), // 🔵 Midnight Blue (Bottom) - Deep, intense blue
            Color(
              0xFF372D78,
            ), // 💜 Royal Indigo (Midway) - Slightly lighter, rich purple-blue
            Color(
              0xFF6657B1,
            ), // 🌌 Soft Lavender Blue (Top) - Noticeably lighter
          ],

          secondaryColors: const [
            Color(
              0xFF141E61,
            ), // 🔵 Dark Ocean Blue (Bottom) - Deep but different from primary
            Color(0xFF3D348B), // 🟣 Dark Purple Blue (Midway) - Adds variation
            Color(0xFF9D76C1), // 🌸 Muted Lilac Purple (Top) - Softer contrast
          ],

          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: SizeConfig.screenWidth * 0.9,
              height: SizeConfig.screenHeight * 0.88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !controller.isShowStudyContent.value
                        ? finalizeSurveyHeader("Study Survey Overview")
                        : finalizeSurveyHeader("Study Content OverView"),
                    Container(
                      // color: Colors.white,
                      child: SizedBox(
                        height: SizeConfig.blockSizeHorizontal * 135,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child:
                                !controller.isShowStudyContent.value
                                    ? Column(
                                      children: [
                                        studyContent(
                                          "Selected Category ",
                                          controller.studyCategory.value,
                                        ),
                                        studyContent(
                                          "Study Days ",
                                          "${controller.totalStudyDays}",
                                        ),
                                        studyContent(
                                          "Start Date ",
                                          "${CommonMethods.toDateString(controller.selectedStartDate.value)}",
                                        ),
                                        studyContent(
                                          "End Date ",
                                          "${CommonMethods.toDateString(controller.selectedEndDate.value)}",
                                        ),
                                        studyContent(
                                          "Daily study Duration ",
                                          "${CommonMethods.formattedDuration(controller.dailyStudyDuration.value)}",
                                        ),
                                        studyContent(
                                          "Study days ",
                                          "${controller.preferredDays.join(', ')}",
                                        ),
                                        studyContent(
                                          "Daily study time ",
                                          "${CommonMethods.hoursFormat(controller.fromTime.value.hour).toString().padLeft(2, "0")}:${controller.fromTime.value.minute.toString().padLeft(2, "0")} "
                                              "${controller.fromTime.value.period.toString().endsWith("am") ? "AM" : "PM"}",
                                        ),
                                        studyContent(
                                          "Provided Files ",
                                          controller.attachedFilesName.join(
                                            ', ',
                                          ),
                                        ),
                                      ],
                                    )
                                    : Scrollbar(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            studyContentHeading(
                                              "Important Topics",
                                            ),
                                            studyContentBuilder(
                                              controller
                                                  .studyPlanData
                                                  .importantTopics,
                                            ),
                                            studyContentHeading("Topics"),
                                            studyContentBuilder(
                                              controller.studyPlanData.topics,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          !controller.isGeneratingStudyTopics.value &&
                                  !controller.isShowStudyContent.value
                              ? Container(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.finalizingSurvey.value =
                                            false;
                                      },
                                      child: Container(
                                        child: Text(
                                          "Modify",
                                          style: GoogleFonts.nunitoSans(
                                            color: AppColors.background2,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.generatePlan();
                                      },
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 4,
                                        width:
                                            SizeConfig.blockSizeHorizontal * 32,
                                        // padding: EdgeInsets.symmetric(
                                        //   horizontal:
                                        //       SizeConfig.blockSizeHorizontal *
                                        //       5,
                                        //   vertical:
                                        //       SizeConfig.blockSizeHorizontal *
                                        //       3,
                                        // ),
                                        decoration: BoxDecoration(
                                          color: AppColors.clockForegroundColor,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Generate Plan",
                                            style: GoogleFonts.nunitoSans(
                                              color: AppColors.background2,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : !controller.isShowStudyContent.value
                              ? Container(
                                alignment: Alignment.topCenter,
                                child: LoadingAnimationWidget.inkDrop(
                                  color: AppColors.textColor,
                                  size: 80,
                                ),
                              )
                              : Container(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    StarFeedbackWidget(
                                      size: SizeConfig.blockSizeHorizontal * 4,
                                      mainContext: context,
                                      isShowText: true,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await controller
                                            .goToStudyPlanOverview();
                                        // controller.setVariablesToDefault();
                                      },
                                      child: Container(
                                        child: Text(
                                          "View Plan",
                                          style: GoogleFonts.nunitoSans(
                                            color: AppColors.background2,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // testing purpose only
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     controller.finalizingSurvey.value =
                                    //         false;
                                    //     controller.isShowStudyContent.value =
                                    //         false;
                                    //   },
                                    //   child: Container(
                                    //     child: Text(
                                    //       "Modify",
                                    //       style: GoogleFonts.nunitoSans(
                                    //         color: AppColors.background2,
                                    //         fontWeight: FontWeight.w800,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ).asGlass(
              blurX: 100,
              blurY: 100,
              frosted: true,
              tintColor: AppColors.textColor,
              clipBorderRadius: BorderRadius.circular(30),
              tileMode: TileMode.mirror,
            ),
          ),
        ),
      ),
    );
  }

  ListView studyContentBuilder(List<String> studyPlanData) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 6),
      shrinkWrap: true, // Allows ListView to be sized based on children
      physics:
          NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
      itemCount: studyPlanData.length,
      itemBuilder: (BuildContext context, int index) {
        String topic = studyPlanData[index];
        return Container(
          margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 2.5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    topic,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                      color: AppColors.textColor,
                      fontSize: SizeConfig.blockSizeHorizontal * 3,
                      // fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container studyContentHeading(String heading) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 3),
      alignment: Alignment.topLeft,
      child: Text(
        textAlign: TextAlign.start,
        heading,
        style: GoogleFonts.openSans(
          color: AppColors.textColor,
          fontSize: SizeConfig.blockSizeHorizontal * 4.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Container finalizeSurveyHeader(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 8),
      alignment: Alignment.center,
      child: Text(
        textAlign: TextAlign.center,
        title.toUpperCase(),
        style: GoogleFonts.openSans(
          color: AppColors.textColor,
          fontSize: SizeConfig.blockSizeHorizontal * 6,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget studyContent(String key, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 7),

      child: Row(
        children: [
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 30,
            child: Container(
              padding: EdgeInsets.only(
                right: SizeConfig.blockSizeHorizontal * 5,
              ),
              child: Text(
                key,
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  color: AppColors.textColor,
                  fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 8,
            // height: SizeConfig.blockSizeHorizontal * 5,
            // color: Colors.white,
          ),
          Expanded(
            child: Container(
              // alignment: Alignment.centerRight,
              child: Text(
                textAlign: TextAlign.right,
                "$value",
                style: GoogleFonts.publicSans(
                  color: AppColors.textColor,
                  fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
