import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/application_model.dart';
import '../models/interview_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = FirestoreService();

  // Observables for the UI
  var userName = 'User'.obs;
  var stats = <String, int>{}.obs;
  var upcomingInterviews = <InterviewModel>[].obs;


  var recentApplications = <ApplicationModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Bind the stats to its stream
    stats.bindStream(_firestoreService.getApplicationStatsStream());

    // Bind the interviews to its stream
    upcomingInterviews.bindStream(_firestoreService.getUpcomingInterviewsStream());


    // Connect the recentApplications list to its data stream from Firestore
    recentApplications.bindStream(_firestoreService.getUserApplicationsStream());

    // Fetch user's name once
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    String? userId = _authService.currentUser.value?.uid;
    if (userId != null) {
      UserModel? user = await _firestoreService.getUser(userId);
      if (user != null) {
        userName.value = user.name.split(' ').first;
      }
    }
  }
}