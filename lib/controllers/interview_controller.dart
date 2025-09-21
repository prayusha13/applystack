import 'package:get/get.dart';
import '../models/interview_model.dart';
import '../services/firestore_service.dart';

class InterviewController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  // The master list of all interviews
  final _allInterviews = <InterviewModel>[].obs;

  // Separate lists for the UI tabs
  var upcomingInterviews = <InterviewModel>[].obs;
  var pastInterviews = <InterviewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Bind the master list to the stream from Firestore
    _allInterviews.bindStream(_firestoreService.getAllInterviewsStream());

    // This 'ever' worker will automatically separate the lists whenever
    // the master list changes (e.g., a new interview is added).
    ever(_allInterviews, _separateInterviews);
  }

  void _separateInterviews(List<InterviewModel> interviews) {
    final now = DateTime.now();
    upcomingInterviews.value = interviews.where((i) => i.interviewDate.isAfter(now)).toList();
    pastInterviews.value = interviews.where((i) => i.interviewDate.isBefore(now)).toList();
  }
}