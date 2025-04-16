import 'package:ai_work_assistant/app/data/complet_study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan.dart';
import 'package:ai_work_assistant/app/data/study_plan_content.dart';
import 'package:ai_work_assistant/app/data/user_survey.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;
  static final databaseName = "smart_study_database.db";
  static final alarmsTable = 'alarms';
  static final studyPlanTable = 'studyPlan';
  static final completeStudyPlanTable = 'completeStudyPlan';
  static final userSurveyTable = 'userSurveyTable';
  static final studyContentTable = 'studyContentTable';

  DatabaseHelper._instance();
  factory DatabaseHelper() {
    return instance;
  }
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);

    debugPrint('📂 Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      // onUpgrade: _upgradeDB,
      onOpen: (db) => debugPrint('✅ Database opened'),
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON;");
        debugPrint('✅ Foreign keys enabled');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE $alarmsTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          time TEXT NOT NULL,
          alarmId INTEGER
        )
      ''');

      await db.execute("""
          CREATE TABLE $userSurveyTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            targetDuration INTEGER,
            dailyStudyDuration INTEGER,
            preferredDays TEXT,
            preferredDates TEXT,
            dailyAvailabilityTime TEXT,
            attachedFiles TEXT,
            studyPlanId TEXT UNIQUE
            );
        """);

      // Create completeStudyPlanTable
      await db.execute("""
          CREATE TABLE $completeStudyPlanTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studyPlanTitle TEXT,
            attachedFiles TEXT,
            studySession TEXT,
            estimatedStudyDuration INTEGER,
            topicNames TEXT,
            studyPlanId TEXT UNIQUE,
            FOREIGN KEY(studyPlanId) REFERENCES $userSurveyTable(studyPlanId) ON DELETE CASCADE
          );
        """);

      // Create studyPlanTable
      await db.execute("""
          CREATE TABLE $studyPlanTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sessionDateTime TEXT,
            sessionDuration TEXT,
            topicsCovered TEXT,
            studyPlanId TEXT,
            FOREIGN KEY(studyPlanId) REFERENCES $completeStudyPlanTable(studyPlanId) ON DELETE CASCADE
          );
        """);
      await db.execute("""
          CREATE TABLE IF NOT EXISTS $studyContentTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            topicTitle TEXT,
            topicContent TEXT,
            topicIndex INTEGER,
            studyPlanId TEXT,
            FOREIGN KEY(studyPlanId) REFERENCES $completeStudyPlanTable(studyPlanId) ON DELETE CASCADE
          );
        """);

      await db.execute("PRAGMA foreign_keys = ON;");
      print("✅ Database table '$completeStudyPlanTable' created successfully.");

      print("✅ Database table '$alarmsTable' created successfully.");
    } catch (e, stacktrace) {
      print("❌ Error creating database table '$alarmsTable': $e");
      print("🪵 Stacktrace: $stacktrace");
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print("running update db $oldVersion $newVersion");
    if (oldVersion < newVersion) {
      try {
        // Create userSurveyTable
        await db.execute("""
          ALTER TABLE studyPlanContentTable RENAME TO $studyContentTable;
        """);

        print(
          "✅ Database upgraded successfully from version $oldVersion to $newVersion",
        );
      } catch (e, stacktrace) {
        print("❌ Error during database upgrade: $e");
        print("🪵 Stacktrace: $stacktrace");
      }
    }
  }

  Future<int> insertAlarm(DateTime time, int alarmId) async {
    final db = await instance.database;
    return await db.insert(alarmsTable, {
      'time': time.toIso8601String(),
      'alarmId': alarmId,
    });
  }

  Future<List<Map<String, dynamic>>> getAlarms() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> alarms = await db.query(alarmsTable);
    return alarms;
  }

  Future<void> insertCompleteStudyPlan(
    CompleteStudyPlan completeStudyPlan,
  ) async {
    final db = await instance.database;

    await db.insert(completeStudyPlanTable, completeStudyPlan.toMapDatabase());
    print("Added into database");
  }

  Future<void> insertStudyContent(StudyContent studyContent) async {
    final db = await instance.database;

    await db.insert(studyContentTable, studyContent.toMapDatabase());
    print("Added into database");
  }

  Future<int> insertStudyPlan(StudyPlan studyPlan) async {
    final db = await instance.database;

    print("Added into database");
    return await db.insert(studyPlanTable, studyPlan.toMapDatabase());
  }

  Future<void> insertUserSurvey(UserSurvey UserSurvey) async {
    final db = await instance.database;

    await db.insert(userSurveyTable, UserSurvey.toMapDatabase());
    print("Added into database");
  }

  Future<List<int>> insertAllStudyPlan(
    CompleteStudyPlan completeStudyPlan,
  ) async {
    // final db = await instance.database;
    List<int> studyPlanIdList = [];
    int studyPlanId = 0;

    await insertCompleteStudyPlan(completeStudyPlan);
    for (int i = 0; i < completeStudyPlan.studyPlanPatches.length; i++) {
      StudyPlan studyPatch = completeStudyPlan.studyPlanPatches[i];
      studyPlanId = await insertStudyPlan(studyPatch);
      studyPlanIdList.add(studyPlanId);
      print("Added into database");
    }

    return studyPlanIdList;
  }

  Future<List<CompleteStudyPlan>> fetchCompleteStudyPlans() async {
    final db = await instance.database;

    // Fetch the list of complete study plans
    final List<Map<String, dynamic>> maps = await db.query(
      completeStudyPlanTable,
    );

    // Create a list to hold the CompleteStudyPlan objects
    List<CompleteStudyPlan> listCompleteStudyPlan = [];

    for (var completeStudyPlanMap in maps) {
      final studyPlanId = completeStudyPlanMap["studyPlanId"];

      List<StudyPlan> studyPlans = await fetchStudyPlans(studyPlanId);

      // Construct CompleteStudyPlan object and add it to the list
      CompleteStudyPlan completeStudyPlan = CompleteStudyPlan.fromMapDatabase(
        completeStudyPlanMap,
        studyPlans,
      );

      listCompleteStudyPlan.add(completeStudyPlan);
    }

    return listCompleteStudyPlan.reversed.toList();
  }

  Future<List<StudyContent>> fetchAllStudyContentList(
    String studyPlanId,
  ) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      studyContentTable,
      where: 'studyPlanId = ?',
      whereArgs: [studyPlanId],
    );

    return maps.map((studyContent) {
      return StudyContent.fromMapDatabase(studyContent);
    }).toList();
  }

  Future<StudyContent?> fetchSingleStudyContent(
    String studyPlanId,
    int topicIndex,
  ) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      studyContentTable,
      where: 'studyPlanId = ? AND topicIndex = ?',
      whereArgs: [studyPlanId, topicIndex],
    );

    print("Study Plan Content: $maps");

    if (maps.isEmpty) {
      return null; // No content found for the given studyPlanId and topicIndex
    }

    return StudyContent.fromMap(maps.first);
  }

  Future<List<StudyContent>> fetchStudyContentList(
    String studyPlanId,
    int topicIndex,
  ) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      studyContentTable,
      where: 'studyPlanId = ? AND topicIndex = ?',
      whereArgs: [studyPlanId, topicIndex],
    );

    print("Study Plan Content: $maps");

    return maps.map((map) => StudyContent.fromMap(map)).toList();
  }

  Future<List<StudyPlan>> fetchStudyPlans(String studyPlanId) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      studyPlanTable,
      where: 'studyPlanId = ?',
      whereArgs: [studyPlanId],
    );

    return maps.map((studyPlan) {
      return StudyPlan.fromMapDatabase(studyPlan);
    }).toList();
  }

  Future<List<UserSurvey>?> fetchUserSurvey() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(userSurveyTable);

    return maps.map((userSurvey) {
      return UserSurvey.fromMapDatabase(userSurvey);
    }).toList();
  }

  Future<void> deletePlans(List<String> ids) async {
    final db = await instance.database;
    for (String id in ids) {
      await db.delete(
        userSurveyTable,
        where: 'studyPlanId = ?',
        whereArgs: [id],
      );
    }
    print("Deleted a plan from database");
  }
}
