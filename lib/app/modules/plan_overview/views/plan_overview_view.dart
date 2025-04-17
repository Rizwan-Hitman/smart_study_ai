import 'package:ai_work_assistant/app/data/custom_date_day_time.dart';
import 'package:ai_work_assistant/app/data/study_plan.dart';
import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/common_methods.dart';
import 'package:ai_work_assistant/utills/size_config.dart' show SizeConfig;
import 'package:ai_work_assistant/utills/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/plan_overview_controller.dart';

class PlanOverviewView extends GetView<PlanOverviewController> {
  const PlanOverviewView({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        return controller.backButtonHandle(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.blockSizeHorizontal * 23,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.blockSizeVertical * 2,
                ),
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Study Plan",
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                    fontSize: SizeConfig.blockSizeHorizontal * 6,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.background2,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        // margin: EdgeInsets.symmetric(
                        //   vertical: SizeConfig.blockSizeHorizontal * 4,
                        // ),
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            viewportFraction: 0.9,
                            height: double.infinity,
                          ),
                          itemCount:
                              controller
                                  .completeStudyPlan
                                  .studyPlanPatches
                                  .length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                            int pageViewIndex,
                          ) {
                            StudyPlan studyPlan =
                                controller
                                    .completeStudyPlan
                                    .studyPlanPatches[index];
                            DateDayTime dateDayTime = DateDayTime.fromDateTime(
                              studyPlan.sessionDateTime,
                            );
                            return Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.blockSizeHorizontal * 8,
                                bottom: SizeConfig.blockSizeHorizontal * 7,
                              ),
                              alignment: Alignment.topLeft,
                              width: SizeConfig.screenWidth * 0.86,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColors.foregroundGradient,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(30, 0, 0, 0),
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  carouselHeader(index, dateDayTime),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            SizeConfig.blockSizeHorizontal * 8,
                                        horizontal:
                                            SizeConfig.blockSizeHorizontal * 6,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Container(
                                              // alignment: Alignment.center,
                                              child: Text(
                                                "Contents Covered",
                                                style: GoogleFonts.openSans(
                                                  // color: Colors,
                                                  fontSize:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      5,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                padding: EdgeInsets.only(
                                                  top:
                                                      SizeConfig
                                                          .blockSizeHorizontal *
                                                      6,
                                                ),
                                                // physics: NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    studyPlan
                                                        .topicsCovered
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  String topicName =
                                                      studyPlan
                                                          .topicsCovered[index];
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                      bottom:
                                                          SizeConfig
                                                              .blockSizeHorizontal *
                                                          4,
                                                      left:
                                                          SizeConfig
                                                              .blockSizeHorizontal *
                                                          3,
                                                      right:
                                                          SizeConfig
                                                              .blockSizeHorizontal *
                                                          3,
                                                    ),
                                                    child: Text(
                                                      topicName,
                                                      style: GoogleFonts.openSans(
                                                        // color: Colors,
                                                        fontSize:
                                                            SizeConfig
                                                                .blockSizeHorizontal *
                                                            3,
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            // Container(child: Text(studyPlan.))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   // height: SizeConfig.blockSizeHorizontal * 40,
                                  //   child: Container(
                                  //     // color: Colors.black,
                                  //     alignment: Alignment.topLeft,
                                  //     padding: EdgeInsets.symmetric(
                                  //       horizontal: SizeConfig.blockSizeHorizontal * 6,
                                  //     ),
                                  //     child:
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: SizeConfig.blockSizeHorizontal * 17,
                      color: AppColors.background2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(
                                left: SizeConfig.blockSizeHorizontal * 4,
                                right: SizeConfig.blockSizeHorizontal * 3,
                                top: SizeConfig.blockSizeHorizontal * 2.5,
                                bottom: SizeConfig.blockSizeHorizontal * 2.5,
                              ),
                              // decoration: BoxDecoration(
                              //   color: AppColors.backgroundColor,
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(6),
                              //   ),
                              // ),
                              // child: textIcon(
                              //   "Customize",
                              //   Icons.edit,
                              //   AppColors.textColor,
                              //   false,
                              //   SizeConfig.blockSizeHorizontal * 3.6,
                              //   SizeConfig.blockSizeHorizontal * 4.5,
                              //   SizeConfig.blockSizeHorizontal * 2,
                              // ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth * 0.15),
                          GestureDetector(
                            onTap: () async {
                              await controller.saveAllStudyPlanToDatabase();
                              // await controller.setStudyPlanNotifications();
                              await controller.goToCompleteStudyPlan();
                              // await controller.goToHome();
                            },
                            child: Container(
                              child: textIcon(
                                "Save",
                                Icons.check,
                                AppColors.backAndNextButton,
                                true,
                                SizeConfig.blockSizeHorizontal * 3.8,
                                SizeConfig.blockSizeHorizontal * 6,
                                SizeConfig.blockSizeHorizontal * 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container carouselHeader(int index, DateDayTime dateDayTime) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: AppColors.backgroundColor,
      ),
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 7),
      child: Column(
        children: [
          Container(
            // alignment: Alignment.centerLeft,
            child: Text(
              "Session ${index + 1}",
              style: GoogleFonts.openSans(
                color: AppColors.textColor,
                fontSize: SizeConfig.blockSizeHorizontal * 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: SizeConfig.blockSizeHorizontal * 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    // textAlign: TextAlign.start,
                    "${dateDayTime.month}, ${dateDayTime.day}, ${dateDayTime.year} ",
                    style: GoogleFonts.openSans(
                      color: AppColors.textColor,
                      fontSize: SizeConfig.blockSizeHorizontal * 3.2,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,

                  child: Text(
                    "${dateDayTime.weekday} / ${dateDayTime.time}",
                    style: GoogleFonts.openSans(
                      color: AppColors.textColor,
                      fontSize: SizeConfig.blockSizeHorizontal * 3,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
