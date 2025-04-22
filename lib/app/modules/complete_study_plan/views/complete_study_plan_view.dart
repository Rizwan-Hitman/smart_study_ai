import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/custom_date_day_time.dart';
import 'package:ai_work_assistant/app/data/study_plan.dart';
import 'package:ai_work_assistant/app/routes/app_pages.dart';
import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:ai_work_assistant/utills/widgets.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/complete_study_plan_controller.dart';

class CompleteStudyPlanView extends GetView<CompleteStudyPlanController> {
  const CompleteStudyPlanView({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        return await controller.backButtonHandler();
      },
      child: Scaffold(
        body: Scrollbar(
          interactive: true,
          thickness: SizeConfig.blockSizeHorizontal * 1.2,
          child: DraggableHome(
            leading: Container(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () async {
                  if (await controller.backButtonHandler()) {
                    Get.back();
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.download, color: AppColors.textColor),
              // ),
            ],
            appBarColor: AppColors.backgroundColor,
            backgroundColor: AppColors.background2,
            headerWidget: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.backgroundColor,
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.blockSizeHorizontal * 5,
                                  right: SizeConfig.blockSizeHorizontal * 5,
                                ),
                                margin: EdgeInsets.only(
                                  top: SizeConfig.blockSizeHorizontal * 10,
                                ),
                                child: Text(
                                  "${controller.completeStudyPlan.studyPlanTitle}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.publicSans(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: SizeConfig.blockSizeHorizontal * 10,
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Total Sessions ${controller.completeStudyPlan.studyPlanPatches.length}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.publicSans(
                                      color: AppColors.textColor,
                                      // fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.5,
                                    ),
                                  ),
                                  Text(
                                    "Each Session ${CommonMethods.formattedDuration(controller.completeStudyPlan.estimatedStudyDuration.inMinutes)}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.publicSans(
                                      color: AppColors.textColor,
                                      // fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.5,
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
              ],
            ),
            title: Text(
              "${controller.completeStudyPlan.studyPlanTitle}",
              style: GoogleFonts.publicSans(color: AppColors.textColor),
            ),
            body: [
              Container(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.blockSizeHorizontal * 4,
                  ),
                  itemCount:
                      controller.completeStudyPlan.studyPlanPatches.length,
                  itemBuilder: (BuildContext context, int index) {
                    StudyPlan studyPlan =
                        controller.completeStudyPlan.studyPlanPatches[index];
                    DateDayTime dateDayTime = DateDayTime.fromDateTime(
                      studyPlan.sessionDateTime,
                    );

                    return GestureDetector(
                      onTap: () {
                        // controller.goToStudyPlanListView(completeStudyPlan);
                      },
                      child: Container(
                        // height: SizeConfig.screenHeight * 0.18,
                        margin: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeHorizontal * 6,
                          left: SizeConfig.blockSizeHorizontal * 5,
                          right: SizeConfig.blockSizeHorizontal * 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.2),
                          color: Color.fromARGB(255, 254, 253, 255),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(18, 0, 0, 0),
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(8, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Text("${studyPlan.topicsCovered[3]}"),
                            Container(
                              padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                color: AppColors.studyPatchColor,
                              ),

                              child: Column(
                                children: [
                                  cardHeading("Session ${index + 1}"),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.blockSizeHorizontal * 7,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        cardSubHeading(
                                          "${dateDayTime.day} - ${dateDayTime.month} - ${dateDayTime.year}",
                                        ),
                                        cardSubHeading(
                                          "${dateDayTime.weekday}",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 4,
                                right: SizeConfig.blockSizeHorizontal * 4,
                                top: SizeConfig.blockSizeHorizontal * 4,
                                // bottom: SizeConfig.blockSizeHorizontal * 2,
                              ),
                              itemCount: studyPlan.topicsCovered.length,
                              itemBuilder: (
                                BuildContext context,
                                int innerIndex,
                              ) {
                                String topic =
                                    studyPlan.topicsCovered[innerIndex];
                                return cardContentPart(topic, true);
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 4,
                                vertical: SizeConfig.blockSizeHorizontal * 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Container(
                                  //   padding: EdgeInsets.all(
                                  //     SizeConfig.blockSizeHorizontal * 2,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //     color: AppColors.clockBackgroundColor,
                                  //     borderRadius: BorderRadius.circular(5),
                                  //   ),
                                  //   child: textIcon(
                                  //     "Customize",
                                  //     Icons.edit,
                                  //     AppColors.textColor,
                                  //     true,
                                  //     SizeConfig.blockSizeHorizontal * 2.8,
                                  //     SizeConfig.blockSizeHorizontal * 4,
                                  //     SizeConfig.blockSizeHorizontal * 1,
                                  //   ),
                                  // ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!await controller.isStudyContentExist(
                                        studyPlan.studyPlanId,
                                        index + 1,
                                      )) {
                                        controller
                                            .generateContentAndSaveToDatabase(
                                              studyPlan.topicsCovered,
                                              index + 1,
                                              studyPlan.studyPlanId,
                                            );
                                      }
                                    },
                                    child: Container(
                                      height: SizeConfig.blockSizeVertical * 4,

                                      // width: SizeConfig.blockSizeHorizontal * 30,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: Offset(-1, 2),
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                        color: AppColors.studyPatchColor,
                                        border: Border.all(
                                          color: AppColors.backgroundColor,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.blockSizeHorizontal * 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal * 2,

                                        //   vertical:
                                        //       SizeConfig.blockSizeHorizontal * 1.5,
                                        // ),
                                        // decoration: BoxDecoration(
                                        //   color: AppColors.clockBackgroundColor,
                                        //   borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: textIcon(
                                        "Prepare",
                                        Icons.arrow_forward_ios_rounded,
                                        AppColors.textColor,
                                        true,
                                        SizeConfig.blockSizeHorizontal * 2.8,
                                        SizeConfig.blockSizeHorizontal * 4,
                                        SizeConfig.blockSizeHorizontal * 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
          // margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 1),
          padding:
              isBold
                  ? EdgeInsets.only(
                    right: SizeConfig.blockSizeHorizontal * 2,
                    left: SizeConfig.blockSizeHorizontal * 2,
                    top: SizeConfig.blockSizeHorizontal * 1,
                    bottom: SizeConfig.blockSizeHorizontal * 1.5,
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: SizeConfig.blockSizeHorizontal * 1,
                  height: SizeConfig.blockSizeHorizontal * 1,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: SizeConfig.blockSizeHorizontal * 1,
                    left: SizeConfig.blockSizeHorizontal * 2,
                  ),
                  child: Text(
                    text,
                    softWrap: true,
                    style: GoogleFonts.robotoFlex(
                      color: textColor,
                      fontSize: SizeConfig.blockSizeHorizontal * 2.5,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                    ),
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
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 4),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.start,
            softWrap: true,
            style: GoogleFonts.openSans(
              fontSize: SizeConfig.blockSizeHorizontal * 5.2,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
      ),
    );
  }

  Container cardSubHeading(String text) {
    return Container(
      // height: SizeConfig.blockSizeHorizontal * 13,
      margin: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 2),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.start,
            softWrap: true,
            style: GoogleFonts.openSans(
              fontSize: SizeConfig.blockSizeHorizontal * 3,
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
