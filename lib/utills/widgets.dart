import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Row textIcon(
  String text,
  IconData icon,
  Color textAndIconColor,
  bool isTextBold,
  double fontSize,
  double iconSize,
  double iconSpace,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: GoogleFonts.openSans(
          color: textAndIconColor,
          fontWeight: isTextBold ? FontWeight.bold : FontWeight.w400,
          fontSize: fontSize,
        ),
      ),
      SizedBox(width: iconSpace),
      Icon(icon, color: textAndIconColor, size: iconSize),
    ],
  );
}

Widget noConnectionWidget() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: AppColors.backgroundDarkGradient,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    // color: AppColors.backgroundColor,
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 5.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

          Icon(
            Icons.wifi_off,
            size: SizeConfig.blockSizeHorizontal * 35,
            color: Color.fromARGB(255, 255, 82, 70),
          ),

          // const SizedBox(height: 24),
          SizedBox(height: SizeConfig.blockSizeHorizontal * 6),

          Text(
            "Please check your connection and try again.",
            style: TextStyle(fontSize: 16, color: AppColors.textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
