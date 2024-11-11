import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment.dart';
import '../models/comment.dart';
import '../models/scenario.dart';
import '../models/test_cases.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Add a new scenario with Firestore
  Future<String> addScenario(Scenario scenario) async {
    final docRef = await _db.collection('scenarios').add(scenario.toMap());
    return docRef.id; // Firestore auto-generates an ID
  }

  /// Get all scenarios
  Future<List<Scenario>> getScenarios() async {
    final snapshot = await _db.collection('scenarios').get();
    return snapshot.docs
        .map((doc) => Scenario.fromMap(doc.data()..['id'] = doc.id))
        .toList();
  }

  /// Delete a scenario
  Future<void> deleteScenario(String scenarioId) async {
    await _db.collection('scenarios').doc(scenarioId).delete();
  }

  ///Get Projects By there Email
  Future<List<Scenario>> getProjectsByUser(String userEmail) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('scenarios') // Assuming projects are stored here
          .where('createdBy',
              isEqualTo:userEmail)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Scenario(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          project: data['project'],
          createdBy: data['createdBy'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  /// Add a test case to a scenario, using Firestore auto-generated ID
  Future<String> addTestCase(String scenarioId, TestCase testCase) async {
    final docRef = await _db
        .collection('scenarios')
        .doc(scenarioId)
        .collection('testCases')
        .add(testCase.toMap());
    return docRef.id; // Firestore auto-generates an ID
  }

  ///Get Test Cases By Scenario
  Future<List<TestCase>> getTestCasesByScenario(String scenarioId) async {
    final querySnapshot = await _db
        .collection('test_cases')
        .where('scenario', isEqualTo: scenarioId)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return TestCase(
        id: doc.id,
        name: data['name'],
        scenarioId: data['scenario'],
        bugId: data['bugId'],
        status: data['status'],
        tags: List<String>.from(data['tags']),
        description: data['description'],
        comments: data['comments'],
        attachment: data['attachment'],
      );
    }).toList();
  }

  /// Add a comment to a test case
  Future<void> addComment(
      String scenarioId, String testCaseId, Comment comment) async {
    await _db
        .collection('scenarios')
        .doc(scenarioId)
        .collection('testCases')
        .doc(testCaseId)
        .collection('comments')
        .add(comment.toMap());
  }

  /// Add an assignment to a test case
  Future<void> addAssignment(
      String scenarioId, String testCaseId, Assignment assignment) async {
    await _db
        .collection('scenarios')
        .doc(scenarioId)
        .collection('testCases')
        .doc(testCaseId)
        .collection('assignments')
        .add(assignment.toMap());
  }
}
