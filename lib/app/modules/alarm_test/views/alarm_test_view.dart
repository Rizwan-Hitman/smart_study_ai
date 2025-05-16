import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/alarm_test_controller.dart';

class AlarmTestView extends GetView<AlarmTestController> {
  const AlarmTestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm Scheduler")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Text(
              controller.selectedDateTime.value != null
                  ? "Selected: ${controller.selectedDateTime.value}"
                  : "No date/time selected",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.pickDateTime(context),
            child: Text("Pick Date & Time"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.scheduleNotification,
            child: Text("Schedule Alarm"),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Obx(() {
              if (controller.alarms.isEmpty) {
                return Center(child: Text("No alarms scheduled."));
              }
              return ListView.builder(
                itemCount: controller.alarms.length,
                itemBuilder: (context, index) {
                  DateTime alarmTime = DateTime.parse(
                    controller.alarms[index]['time'],
                  );
                  int? alarmId = controller.alarms[index]['alarmId'] as int;
                  return ListTile(
                    title: Text("Alarm at: $alarmTime $alarmId "),
                    leading: Icon(Icons.alarm),
                  );
                },
              );
            }),
          ),
          Obx(
            () => Text(
              '${controller.isListening.value ? "Listening..." : "Not Listening"}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Obx(
            () => Text(
              '${controller.lastWords.value}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          Obx(
            () => FloatingActionButton(
              onPressed:
                  controller.speechToText.value.isNotListening
                      ? controller.startListening
                      : controller.stopListening,
              child: Icon(
                controller.speechToText.value.isNotListening
                    ? Icons.mic_off
                    : Icons.mic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
