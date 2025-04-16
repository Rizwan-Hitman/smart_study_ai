import 'dart:math';

import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/custom_date_day_time.dart';
import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        return controller.backButtonHandle(context);
      },

      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.background2,
          body: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: Obx(
              () => Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal * 5,
                        left: SizeConfig.blockSizeHorizontal * 4,
                        bottom: SizeConfig.blockSizeHorizontal * 3,
                        top: SizeConfig.blockSizeHorizontal * 15,
                      ),
                      width: double.infinity,
                      color: AppColors.background2,
                      height: SizeConfig.screenHeight * 0.12,
                      child: Row(
                        children: [
                          Text(
                            "AI Work Assistant",
                            style: GoogleFonts.openSans(
                              fontSize: SizeConfig.blockSizeHorizontal * 6,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          controller.isItemSelect.value
                              ? Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await controller.deleteSelectedItems();
                                  },
                                  child: Container(
                                    width: SizeConfig.blockSizeHorizontal * 15,
                                    height: SizeConfig.blockSizeHorizontal * 15,
                                    decoration: BoxDecoration(
                                      // color: AppColors.backAndNextButton,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      color: AppColors.foreground,
                                      Icons.delete,
                                      size: SizeConfig.blockSizeHorizontal * 7,
                                    ),
                                  ),
                                ),
                              )
                              : Container(),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        // margin: EdgeInsets.only(
                        //   top: SizeConfig.screenHeight * 0.02,
                        // ),
                        decoration: BoxDecoration(
                          color: AppColors.background2,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // height: SizeConfig.screenHeight * 0.75,
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeHorizontal * 3,
                            // top: SizeConfig.blockSizeHorizontal * 2,
                          ),
                          child:
                              controller.completeStudyPlanList.isEmpty
                                  ? Container(
                                    // alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            top:
                                                SizeConfig.blockSizeHorizontal *
                                                50,
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.list_alt_sharp,
                                            size:
                                                SizeConfig.blockSizeHorizontal *
                                                40,
                                            color: const Color.fromARGB(
                                              255,
                                              191,
                                              191,
                                              191,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            "No Study Plan Found",
                                            style: GoogleFonts.openSans(
                                              fontSize:
                                                  SizeConfig
                                                      .blockSizeHorizontal *
                                                  4,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromARGB(
                                                255,
                                                191,
                                                191,
                                                191,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : Obx(
                                    () => Scrollbar(
                                      interactive: true,
                                      thickness:
                                          SizeConfig.blockSizeHorizontal * 1,
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount:
                                            controller
                                                .completeStudyPlanList
                                                .length,
                                        itemBuilder: (
                                          BuildContext context,
                                          int index,
                                        ) {
                                          CompleteStudyPlan completeStudyPlan =
                                              controller
                                                  .completeStudyPlanList[index];
                                          DateDayTime firstDate =
                                              DateDayTime.fromDateTime(
                                                completeStudyPlan
                                                    .studySessions
                                                    .first,
                                              );
                                          int randomNumber = controller
                                              .getStudyPlanColorIndex(
                                                completeStudyPlan.studyPlanId,
                                              );
                                          DateDayTime lastDate =
                                              DateDayTime.fromDateTime(
                                                completeStudyPlan
                                                    .studySessions
                                                    .last,
                                              );

                                          return Obx(
                                            () => GestureDetector(
                                              onTap: () {
                                                controller.itemSelectionHandler(
                                                      index,
                                                      false,
                                                      completeStudyPlan
                                                          .studyPlanId,
                                                    )
                                                    ? true
                                                    : controller
                                                        .goToStudyPlanListView(
                                                          completeStudyPlan,
                                                        );
                                              },
                                              onLongPress: () {
                                                controller.itemSelectionHandler(
                                                  index,
                                                  true,
                                                  completeStudyPlan.studyPlanId,
                                                );
                                              },
                                              child: Container(
                                                color:
                                                    controller
                                                            .selectedItemsIndexes
                                                            .contains(index)
                                                        ? AppColors
                                                            .highlightedDateColor[randomNumber]
                                                        : Colors.transparent,
                                                padding: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      4,
                                                  top:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      4,
                                                  left:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      5,
                                                  right:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      5,
                                                ),
                                                margin: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      1,
                                                ),
                                                child: Container(
                                                  // height: SizeConfig.screenHeight * 0.18,
                                                  padding: EdgeInsets.all(
                                                    SizeConfig
                                                            .blockSizeHorizontal *
                                                        4,
                                                  ),

                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          AppColors
                                                              .highlightedDateTextColor[randomNumber],
                                                      width: 0.6,
                                                    ),
                                                    color:
                                                        AppColors.background2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            AppColors
                                                                .shadowColor,
                                                        blurRadius: 8,
                                                        spreadRadius: 3,
                                                        offset: Offset(4, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      cardHeading(
                                                        "${completeStudyPlan.studyPlanTitle}",
                                                      ),
                                                      cardContentPart(
                                                        "${firstDate.day}-${firstDate.month}-${firstDate.year}  - ${lastDate.day}-${lastDate.month}-${lastDate.year}",
                                                        true,
                                                        backgroundColor:
                                                            AppColors
                                                                .highlightedDateColor[randomNumber],
                                                        textColor:
                                                            AppColors
                                                                .highlightedDateTextColor[randomNumber],
                                                      ),
                                                      cardContentPart(
                                                        "Topics  ${completeStudyPlan.topicNames.length}",
                                                        false,
                                                        // const Color.fromARGB(40, 3, 244, 200),
                                                        // const Color.fromARGB(255, 0, 122, 100),
                                                      ),
                                                      cardContentPart(
                                                        "Sessions  ${completeStudyPlan.studySessions.length}",
                                                        false,
                                                        // const Color.fromARGB(40, 25, 5, 242),
                                                        // const Color.fromARGB(255, 77, 64, 221),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: SizeConfig.screenHeight * 0.11,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: SizeConfig.screenWidth,
                              height: SizeConfig.screenHeight * 0.08,
                              decoration: BoxDecoration(
                                color: AppColors.chipsChoiceUnSelected,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                controller.goToSurveyView();
                              },
                              child: Container(
                                width: SizeConfig.blockSizeHorizontal * 14,
                                height: SizeConfig.blockSizeHorizontal * 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 25, 50, 192),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.background2,
                                      blurRadius: 0,
                                      spreadRadius: 10,
                                      offset: Offset(0, -2),
                                    ),
                                    BoxShadow(
                                      color: const Color.fromARGB(30, 0, 0, 0),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    size: SizeConfig.blockSizeHorizontal * 10,
                                    color: AppColors.background2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align cardContentPart(
    String text,
    bool isBold, {
    Color backgroundColor = AppColors.background2,
    Color textColor = Colors.black,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IntrinsicWidth(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 1),
          padding:
              isBold
                  ? EdgeInsets.only(
                    right: SizeConfig.blockSizeHorizontal * 2,
                    left: SizeConfig.blockSizeHorizontal * 2,
                    top: SizeConfig.blockSizeHorizontal * 1,
                    bottom: SizeConfig.blockSizeHorizontal * 0.5,
                  )
                  : EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 2),
          decoration: BoxDecoration(
            // border: Border.all(
            //   width: 0.2,
            //   color: Colors.tealAccent,
            // ),
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeHorizontal * 1,
                ),
                child: Text(
                  text,
                  softWrap: true,
                  style: GoogleFonts.robotoFlex(
                    color: textColor,
                    fontSize: SizeConfig.blockSizeHorizontal * 2.6,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container cardHeading(String text) {
    return Container(
      // height: SizeConfig.blockSizeHorizontal * 13,
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 2.5),
      child: Container(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            textAlign: TextAlign.start,
            softWrap: true,
            style: GoogleFonts.openSans(
              fontSize: SizeConfig.blockSizeHorizontal * 4.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
