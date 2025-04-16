import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/study_content_controller.dart';

class StudyContentView extends GetView<StudyContentController> {
  const StudyContentView({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Session ${controller.sessionNumber}",
          style: GoogleFonts.openSans(
            color: AppColors.textColor,
            fontSize: SizeConfig.blockSizeHorizontal * 5,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
        itemCount: controller.studyContentList.length,
        itemBuilder: (context, index) {
          print("$index");
          return Container(
            padding: EdgeInsets.only(
              bottom: SizeConfig.blockSizeHorizontal * 5,
            ),
            child: MarkdownBody(
              data: controller.studyContentList[index].topicContent,
              styleSheet: MarkdownStyleSheet(
                h1: GoogleFonts.openSans(
                  fontSize: SizeConfig.blockSizeHorizontal * 5.8,
                  fontWeight: FontWeight.bold,
                ),
                h2: GoogleFonts.openSans(
                  fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                  fontWeight: FontWeight.bold,
                ),
                h3: GoogleFonts.openSans(
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  fontWeight: FontWeight.bold,
                ),
                p: GoogleFonts.publicSans(
                  fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                ),
                blockquote: GoogleFonts.publicSans(
                  color: Colors.grey,
                  fontSize: SizeConfig.blockSizeHorizontal * 4.3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
