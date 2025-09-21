import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/application_model.dart';
import '../services/firestore_service.dart';

class ApplicationController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  // The master list of all applications from Firestore (private)
  final _allApplications = <ApplicationModel>[].obs;

  // The filtered list that the UI will actually display
  var filteredApplications = <ApplicationModel>[].obs;

  // State for the filter chips
  var selectedStatus = 'All'.obs;

  // State for the search bar
  var searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Bind the stream from Firestore to our local list
    _allApplications.bindStream(_firestoreService.getUserApplicationsStream());

    // This 'ever' worker automatically runs our filter logic whenever the
    // master list, the selected filter, or the search query changes.
    ever(_allApplications, (_) => _filterAndSearch());
    ever(selectedStatus, (_) => _filterAndSearch());
    ever(searchQuery, (_) => _filterAndSearch());

    // Listen to the search text field and update our reactive variable
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  void _filterAndSearch() {
    List<ApplicationModel> results = _allApplications;

    // 1. Apply the status filter
    if (selectedStatus.value != 'All') {
      results = results.where((app) => app.status == selectedStatus.value.toLowerCase().replaceAll(' ', '_')).toList();
    }

    // 2. Apply the search query on top of the filtered results
    if (searchQuery.value.isNotEmpty) {
      String lowerCaseQuery = searchQuery.value.toLowerCase();
      results = results.where((app) {
        return app.companyName.toLowerCase().contains(lowerCaseQuery) ||
            app.jobTitle.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    }

    filteredApplications.value = results;
  }

  // Called by the UI when a filter chip is tapped
  void changeStatusFilter(String status) {
    selectedStatus.value = status;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}