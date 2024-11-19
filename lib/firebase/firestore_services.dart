import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/enums.dart';
import '../models/comments.dart';
import '../models/scenario.dart';
import '../models/status_change_log.dart';
import '../models/test_cases.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerUser(String email,String password,String name,String designation) async{
    /// Register user with Firebase Authentication
    UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    /// Save additional user data (designation) to Firebase Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'email': email.trim(),
      'name': name,
      'designation': designation,
    });
  }
  Future<UserModel> createUser(String email, String password) async {
    // Sign in with email and password using FirebaseAuth
    final UserCredential credential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Check if the user is valid
    User? currentUser = credential.user;

    if (currentUser != null) {
      // Fetch the user document from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      // Retrieve fields with default fallback values
      String designation = userDoc['designation'] ?? 'Unknown';
      String name = userDoc['name'] ?? 'Unknown';

      // Create UserModel
      return UserModel.fromFirebaseUser(currentUser, designation, name);
    } else {
      throw Exception("Failed to authenticate user.");
    }
  }

  Future<List<Map<String, String>>> fetchDesignations() async {
    try {
      QuerySnapshot snapshot = await _db.collection('role').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc['id'] as String,
          'name': doc['name'] as String,
        };
      }).toList();
    } catch (e) {
      print("Error fetching roles: $e");
      return [];
    }
  }

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
      String testCaseId, Scenario scenario, TestCase updatedTestCase) async {
    final testCaseRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(scenario.projectID)
        .collection('scenarios')
        .doc(scenario.id)
        .collection('testCases')
        .doc(testCaseId);

    await testCaseRef.update({
      'name': updatedTestCase.name,
      'description': updatedTestCase.description,
      'comments': updatedTestCase.comments,
      'status': updatedTestCase.status,
      //'assignedUsers': updatedTestCase.assignedUsers,
    });
  }

  /// Get user names from the users collection
  Future<List<String>> getAssignedUsers() async {
    try {
      final snapshot = await _db.collection('users').get();
      // Combine the name and email for display
      return snapshot.docs
          .map((doc) => "${doc['name']} (${doc['email']})")
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  /// Method to add status change to Firestore
  Future<void> addStatusChange(Map<String, dynamic> statusChangeData) async {
    try {
      // Create a new document in the "status_updates" collection
      await _db.collection('status_updates').add(statusChangeData);
    } catch (e) {
      rethrow; // You can handle the error here
    }
  }

  Future<List<StatusChange>> fetchStatusChangeHistory(String testCaseId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('status_updates')
        .where('testCaseId', isEqualTo: testCaseId)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => StatusChange.fromFirestore(doc))
        .toList();
  }

  ///Add Comments to the test Cases
  Future<void> addComment(String testCaseId, Map<String, dynamic> commentData) {
    return _db.collection('comments').add(commentData);
  }

  ///Get Comments
  Future<List<Comments>> fetchComments(String testCaseId) async {
    final snapshot = await _db
        .collection('comments')
        .where('id', isEqualTo: testCaseId)
        .orderBy('createdAt', descending: true)
        .get();
    final list =
        snapshot.docs.map((doc) => Comments.fromFirestore(doc)).toList();
    return list;
  }

  Future<UserRole> fetchUserRole(String userId) async {
    final roleQuerySnapshot = await FirebaseFirestore.instance
        .collection('role')
        .where('id', isEqualTo: userId)
        .get();

    if (roleQuerySnapshot.docs.isEmpty) {
      // Handle the case where no documents are found
      print('No role found for userId: $userId');
      // You can either throw an error, return a default value, or handle the case
      return UserRole.admin; // Returning a default role (you can change this)
    }

    final roleDoc = roleQuerySnapshot.docs.first;
    final roleName = roleDoc.data()['name'];
    print(roleName);
    return UserRoleExtension.fromString(roleName);
  }
}
