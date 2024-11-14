import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comments.dart';
import '../models/scenario.dart';
import '../models/test_cases.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch all projects
  Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      final snapshot = await _db.collection('projects').get();
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'] ?? 'Unnamed Project',
                'created_at': doc['created_at'],
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Create a new project
  Future<void> createNewProject(String projectName) async {
    try {
      final newProject = {
        'name': projectName,
        'created_at': FieldValue.serverTimestamp(),
      };
      final docRef = await _db.collection('projects').add(newProject);

      // Update the document with its own ID as projectID
      await docRef.update({'projectID': docRef.id});
    } catch (e) {
      return;
    }
  }

  /// Add a new scenario to a specific project in Firestore
  Future<String> addScenario(Scenario scenario) async {
    // Check if the project exists and retrieve its ID
    final projectQuery = await _db
        .collection('projects')
        .where('name', isEqualTo: scenario.project)
        .limit(1)
        .get();

    String projectId;

    if (projectQuery.docs.isEmpty) {
      // Project does not exist, so create a new project document
      final projectDocRef = await _db.collection('projects').add({
        'name': scenario.project,
        'created_at': FieldValue.serverTimestamp(),
      });
      projectId = projectDocRef.id;
    } else {
      // Project already exists, get its ID
      projectId = projectQuery.docs.first.id;
    }

    // Add scenario to the `scenarios` sub collection only if it doesn't exist
    final scenarioRef = _db
        .collection('projects')
        .doc(projectId)
        .collection('scenarios')
        .doc(scenario.id);

    final existingScenario = await scenarioRef.get();

    if (!existingScenario.exists) {
      // Scenario does not exist, so add it
      await scenarioRef
          .set(scenario.toMap()); // Use set() to specify the document ID
      return scenario.id; // Return the predefined scenario ID
    } else {

      return scenario.id; // Return existing scenario ID if it already exists
    }
  }

  /// Fetch scenarios by project ID
  Future<List<Scenario>> getScenariosByProject(String projectId) async {
    final snapshot = await _db
        .collection('projects')
        .doc(projectId)
        .collection('scenarios')
        .where('projectID', isEqualTo: projectId)
        .get();

    return snapshot.docs.map((doc) {
      return Scenario.fromMap(doc.data());
    }).toList();
  }

  /// Get all scenarios under a specific project
  Future<List<Scenario>> getScenarios(String projectId) async {
    final snapshot = await _db
        .collection('projects')
        .doc(projectId)
        .collection('scenarios')
        .get();

    return snapshot.docs
        .map((doc) => Scenario.fromMap(doc.data()..['id'] = doc.id))
        .toList();
  }

  /// Delete a scenario under a specific project
  Future<void> deleteScenario(String projectId, String scenarioId) async {
    await _db
        .collection('projects')
        .doc(projectId)
        .collection('scenarios')
        .doc(scenarioId)
        .delete();
  }

  /// Get projects created by a specific user
  Future<List<Scenario>> getProjectsByUser(String userEmail) async {
    try {
      final querySnapshot = await _db
          .collection('projects')
          .where('createdBy', isEqualTo: userEmail)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Scenario(
          id: doc.id,
          name: data['name'],
          description: data['description'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          project: data['project'],
          projectID: data['projectID'],
          createdBy: data['createdBy'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a test case to a scenario within a specific project
  Future<String> addTestCase(
      String projectId, String scenarioId, TestCase testCase) async {
    // Reference to the test case document with the provided testCase.id
    final testCaseRef = _db
        .collection('projects')
        .doc(projectId)
        .collection('scenarios')
        .doc(scenarioId)
        .collection('testCases')
        .doc(testCase.id); // Use the predefined ID from the testCase model

    // Check if the test case already exists
    final existingTestCase = await testCaseRef.get();

    if (!existingTestCase.exists) {
      // Test case does not exist, so add it with the predefined ID
      await testCaseRef
          .set(testCase.toMap()); // Use set() to specify the document ID
      return testCase.id!; // Return the predefined test case ID
    } else {
      return testCase.id!; // Return the existing test case ID
    }
  }

  /// Get test cases under a specific scenario within a project
  Future<List<TestCase>> getTestCasesByScenario(
      String projectId, String scenarioId) async {
    final querySnapshot = await _db
        .collection('projects')
        .doc(projectId)
        .collection('scenarios')
        .doc(scenarioId)
        .collection('testCases')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return TestCase(
          id: doc.id,
          name: data['name'] ?? '',
          scenarioId: scenarioId,
          bugId: data['bugId'] ?? '',
          description: data['description'] ?? '',
          comments: data['comments'] ?? '',
          attachment: data['attachment'] ?? '',
          status: data['status'] ?? 'pending',
          assignedBy: data['assignedBy'] ?? '',
          assignedUsers: data['assignedUsers'] ?? '');
    }).toList();
  }

  /// Update a test case under a specific scenario within a project
  Future<void> updateTestCase(
      String testCaseId, Scenario scenario,TestCase updatedTestCase) async {
    final testCaseRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(scenario.projectID)
        .collection('scenarios')
        .doc(scenario.id)
        .collection('testCases')
        .doc(testCaseId);

    await testCaseRef.update({
      'name': updatedTestCase.name,
      'bugId': updatedTestCase.bugId,
      'description': updatedTestCase.description,
      'comments': updatedTestCase.comments,
      'status': updatedTestCase.status,
      //'assignedUsers': updatedTestCase.assignedUsers,
    });
  }

  /// Get user names from the users collection
  Future<List<String>> getUserNames() async {
    try {
      QuerySnapshot snapshot = await _db.collection('users').get();
      return snapshot.docs.map((doc) => doc['email'] as String).toList();
    } catch (e) {
      throw Exception("Failed to fetch user names: $e");
    }
  }

  ///Add Comments to the test Cases
  Future<void> addComment(String testCaseId, String commentText, String userId,
      String userName) async {
    if (commentText.isNotEmpty) {
      try {
        final commentRef = FirebaseFirestore.instance
            .collection('projects')
            .doc('projectId') // Replace with actual projectId
            .collection('scenarios')
            .doc('scenarioId') // Replace with actual scenarioId
            .collection('testCases')
            .doc(testCaseId)
            .collection('comments')
            .doc(); // Auto-generate commentId

        Comment newComment = Comment(
          id: commentRef.id,
          commentText: commentText,
          userId: userId,
          userName: userName,
          createdAt: Timestamp.now(),
        );

        await commentRef.set(newComment.toJson());
      } catch (e) {
       return;
      }
    }
  }

  ///Get Comments
  Future<List<Comment>> getComments(String testCaseId) async {
    try {
      final commentsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc('projectId') // Replace with actual projectId
          .collection('scenarios')
          .doc('scenarioId') // Replace with actual scenarioId
          .collection('testCases')
          .doc(testCaseId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      return commentsSnapshot.docs.map((doc) {
        return Comment.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
