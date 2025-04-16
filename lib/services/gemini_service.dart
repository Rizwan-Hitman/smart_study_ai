import 'dart:typed_data';

import 'package:ai_work_assistant/app/data/study_plan_data.dart';
import 'package:ai_work_assistant/utills/remoteconfig_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

class GeminiService {
  GeminiService({
    this.studyCategory, // Optional
    this.targetDuration, // Optional
    this.dailyStudyDuration, // Optional
    this.preferredDates, // Optional
    this.dailyAvailabilityTime, // Optional
    this.studyPlanData, // Optional
  });

  String? studyCategory; // Nullable
  Duration? targetDuration;
  Duration? dailyStudyDuration;
  List<String>? preferredDates;
  TimeOfDay? dailyAvailabilityTime;
  StudyPlanData? studyPlanData;

  int hoursFormat(int hours) {
    if (hours > 12) {
      return hours - 12;
    } else {
      return hours;
    }
  }

  String promptForStudyPlan() {
    String dates = preferredDates!.join(', ');
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(
      Duration(days: targetDuration!.inDays),
    );
    print("selected dates $dates");
    String startDateString =
        "${startDate.year}-${startDate.month}-${startDate.day}";
    String endDateString = "${endDate.year}-${endDate.month}-${endDate.day}";
    String studyStartTime =
        "${hoursFormat(dailyAvailabilityTime!.hour).toString().padLeft(2, "0")}:${dailyAvailabilityTime!.minute.toString().padLeft(2, "0")} ${dailyAvailabilityTime!.period.toString().endsWith("am") ? "AM" : "PM"}";
    String importantTopics = studyPlanData!.importantTopics.join(', ');
    String topics = studyPlanData!.topics.join(', ');

    return """
Generate a **structured and fully distributed** study plan that ensures all topics are covered efficiently within the available study period. Follow these requirements carefully:  

### **User Information:**  
- **Study Category:** ${studyCategory}  
- **Daily Study Duration:** ${dailyStudyDuration!.inMinutes} minutes  
- **Preferred Study Dates:** ${dates}  
- **Total Sessions:** ${preferredDates!.length}
- **Study Start Time:** ${studyStartTime}  
- **Study Content Patches:** ${studyPlanData!.studyPatches}

""";
  }

  String promptForStudyPlanData() {
    return """

You are given a JSON or text file that may contain headings, metadata, and lecture content. Your task is to **extract only the actual lecture content** and organize it into a structured study plan.

### **Instructions:**

- Parse the input and **extract only the content portion of the lecture**.
  - Ignore titles, headings, and structural labels.
  - Only focus on **clear content** — subtopics, bullet points, explanations, or elaborated points.
  - **Do not include headings or section titles**, even if content is missing.

- Identify and highlight **important content topics** that are essential for understanding the subject.
- Ensure that **all important content topics are included in the study patches**.
- Important topics **must not be duplicated** in the general topics list or study patches.
- Only provide the title of the plan without any additional wording (Avoid using "Study Plan" or anything else in the title).

- **Distribute the extracted content topics into study patches** based on the user's study plan:
  - **Total Sessions:** ${preferredDates!.length}
  - **Each Session Duration:** ${dailyStudyDuration!.inMinutes} minutes

- Ensure an **even and balanced distribution** of content across sessions.
- If the total number of topics is too high, **skip only non-important content**, not critical ones.

### **Output Format:**
The final output **must strictly follow** the schema below:

```json
{
  "response": {
  "studyPlanTitle" : "Title",
    "importantTopics": [ "Topic 1", "Topic 2", ... ],
    "studyPatches": [
      ["Topic A", "Topic B"],
      ["Topic C", "Topic D"]
    ],
    "topics": [ "All extracted topics (no duplicates)", ... ]
  }
}
""";
  }

  String systemInstructions() {
    String dates = preferredDates!.join(', ');
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(
      Duration(days: targetDuration!.inDays),
    );
    String startDateString =
        "${startDate.year}-${startDate.month}-${startDate.day}";
    String endDateString = "${endDate.year}-${endDate.month}-${endDate.day}";
    String studyStartTime =
        "${hoursFormat(dailyAvailabilityTime!.hour).toString().padLeft(2, "0")}:${dailyAvailabilityTime!.minute.toString().padLeft(2, "0")} ${dailyAvailabilityTime!.period.toString().endsWith("am") ? "AM" : "PM"}";

    return """### **Study Plan Guidelines**  

#### **Strict Session Scheduling Rules**  
✅ **Only one session per day** unless explicitly required.  
✅ **Sessions must occur strictly on the preferred study dates**: ${dates}.  
✅ **Sessions must start at the designated study time**: ${studyStartTime}.  
✅ **No sessions outside the preferred study days.**  
✅ **Length of total study Sessions is ${preferredDates!.length}**  

#### **Time-Constrained Topic Allocation**  
- Each session must include only the number of topics that **fit within the allocated time**.  
- If a session is **30 minutes**, allocate **2 topics max**.  
- If a session is **60 minutes**, allocate **3-4 topics**, depending on complexity.  
- Do **not** exceed the available session time.  

#### **Even Distribution & Logical Flow**  
- **Topics should be covered within the total study duration and study sessions, but some topics may be skipped if they don't fit within the given timeframe. 
- Topics must progress **logically from basic to advanced**.  
- Group related topics together for **smooth learning transitions**.  
- **No redundant repetition** unless explicitly required.  

💡 **Strictly follow these constraints. Ensure the schedule is fully structured, balanced, and does not include duplicate or excessive sessions on the same day.** 🚀  """;
  }

  static final studyPlanDataSchema = Schema.object(
    properties: {
      'response': Schema.object(
        properties: {
          'studyPlanTitle': Schema.string(
            description: "Name of the plan.",
            nullable: false,
          ),
          'topics': Schema.array(
            description: 'List of all extracted topics.',
            items: Schema.string(nullable: false),
          ),
          'importantTopics': Schema.array(
            description: 'List of prioritized topics.',
            items: Schema.string(nullable: false),
          ),
          'studyPatches': Schema.array(
            description:
                'Topics grouped into structured study sessions, ensuring all important topics are covered within the study duration.',
            items: Schema.array(items: Schema.string(nullable: false)),
          ),
        },
        requiredProperties: [
          'topics',
          'importantTopics',
          'studyPatches',
          'studyPlanTitle',
        ],
      ),
    },
    requiredProperties: ['response'],
  );

  static final completeStudyPlanSchema = Schema.object(
    properties: {
      'response': Schema.object(
        properties: {
          'studySessions': Schema.array(
            description:
                'List of exact session times in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ).',
            items: Schema.string(nullable: false),
          ),
          'studyPlanPatches': Schema.array(
            description: 'Each study session with specific details.',
            items: Schema.object(
              properties: {
                'sessionDateTime': Schema.string(
                  description:
                      'The exact date and time of the study session in ISO 8601 format.',
                  nullable: false,
                ),
                'patchDuration': Schema.integer(
                  description:
                      'Duration of this specific study session in minutes.',
                  nullable: false,
                ),
                'topicsCovered': Schema.array(
                  description: 'Topics planned for this session.',
                  items: Schema.string(nullable: false),
                ),
              },
              requiredProperties: [
                'sessionDateTime',
                'patchDuration',
                'topicsCovered',
              ],
            ),
          ),
        },
        requiredProperties: ['studySessions', 'studyPlanPatches'],
      ),
    },

    requiredProperties: ['response'],
  );

  Future<String?> callGeminiApi(
    Uint8List fileBytes,
    Schema responseSchema,
    String prompt, {
    String systemInstructions = "",
  }) async {
    const int maxRetries = 3; // Maximum retry attempts
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final model = GenerativeModel(
          model: RCVariables.geminiModel,
          apiKey: RCVariables.apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: responseSchema,
          ),
        );
        var mimeType = extensionFromMime(
          await lookupMimeType('', headerBytes: fileBytes)!,
        );
        print(mimeType);

        final response = await model.generateContent([
          Content.text(prompt),
          Content.data("application/${mimeType!}", fileBytes),
        ]);

        if (response.text != null) {
          return response.text;
        } else {
          throw Exception("API response is null.");
        }
      } catch (e) {
        attempt++;
        print("Error in callGeminiApi: $e (Attempt $attempt of $maxRetries)");

        if (attempt >= maxRetries) {
          return null;
        }

        // Exponential backoff before retrying
        await Future.delayed(Duration(seconds: 2 * attempt));
      }
    }

    return null;
  }
}



//Somewhat Good prompt

 