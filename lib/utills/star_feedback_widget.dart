import 'package:ai_work_assistant/utills/colors.dart';
import 'package:ai_work_assistant/utills/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StarFeedbackWidget extends StatefulWidget {
  final double size;
  final BuildContext mainContext;
  final bool isShowText;

  const StarFeedbackWidget({
    Key? key,
    required this.size,
    required this.mainContext,
    this.isShowText = false,
  }) : super(key: key);

  @override
  State<StarFeedbackWidget> createState() => _StarFeedbackWidgetState();
}

class _StarFeedbackWidgetState extends State<StarFeedbackWidget> {
  bool isStarred = false; // Track if feedback is given
  String? selectedFeedback; // Selected feedback option
  String? feedbackType = "Positive"; // Default feedback type
  TextEditingController customFeedbackController = TextEditingController();

  final Map<String, List<String>> feedbackOptions = {
    "Positive": [
      "Great content",
      "Easy to understand",
      "Visually appealing",
      "Informative",
      "Well structured",
      "Other",
    ],
    "Negative": [
      "Difficult to understand",
      "Too complex",
      "Not visually appealing",
      "Lacks information",
      "Not well structured",
      "Other",
    ],
  };

  void showFeedbackDialog(BuildContext mainContext) {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Provide Feedback"),
            content: SizedBox(
              width: SizeConfig.screenWidth * 0.8,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Positive/Negative Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Radio<String>(
                            value: "Positive",
                            groupValue: feedbackType,
                            onChanged: (value) {
                              setState(() {
                                feedbackType = value;
                                selectedFeedback = null;
                              });
                            },
                          ),
                          Text("Positive"),
                          SizedBox(width: 20),
                          Radio<String>(
                            value: "Negative",
                            groupValue: feedbackType,
                            onChanged: (value) {
                              setState(() {
                                feedbackType = value;
                                selectedFeedback = null;
                              });
                            },
                          ),
                          Text("Negative"),
                        ],
                      ),

                      // Feedback Options
                      ...feedbackOptions[feedbackType]!.map((option) {
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: selectedFeedback,
                          onChanged: (value) {
                            setState(() {
                              selectedFeedback = value;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  String finalFeedback =
                      selectedFeedback == "Other"
                          ? customFeedbackController.text
                          : selectedFeedback ?? "";
                  setState(() {
                    isStarred = true;
                  });
                  FirebaseFirestore.instance
                      .collection('reported_messages')
                      .doc()
                      .set({
                        'reason': finalFeedback,
                        'reportedAt': DateTime.now(),
                      });

                  // Show "Thank You" message in the AlertDialog
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevents user from closing it manually
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Thank You!"),
                        content: Text("Your feedback has been submitted."),
                      );
                    },
                  );

                  // Close the dialog after 1 second
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pop(); // Close Thank You dialog
                    Navigator.of(
                      context,
                    ).pop(); // Close original feedback dialog
                  });
                },
                child: Text("Submit"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error showing feedback dialog: $e");
      Navigator.of(context).pop(); // Close original feedback dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    final buildContext = widget.mainContext;
    return GestureDetector(
      onTap: () {
        showFeedbackDialog(buildContext);
      },
      child: Row(
        children: [
          widget.isShowText
              ? Text(
                "Feedback",
                style: GoogleFonts.nunitoSans(
                  color: AppColors.background2,
                  fontWeight: FontWeight.w800,
                ),
              )
              : Container(),
          Container(
            // width: SizeConfig.blockSizeHorizontal * size,
            // height: SizeConfig.blockSizeHorizontal * size,
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Icon(
                Icons.star,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal * 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
