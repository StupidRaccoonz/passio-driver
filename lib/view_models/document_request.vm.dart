import 'dart:io';

import 'package:fuodz/models/user.dart';
import 'package:fuodz/requests/auth.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DocumentRequestViewModel extends MyBaseViewModel {
  //
  AuthRequest _authRequest = AuthRequest();
  User? currentUser;
  List<File> selectedDocuments = [];
  XFile? driverSelfie;
  //
  void initialise() {
    currentUser = AuthServices.currentUser;
    fetchMyProfile();
  }

  fetchMyProfile() async {
    setBusy(true);
    try {
      currentUser = await _authRequest.getMyDetails();
    } catch (error) {
      print(error);
    }
    setBusy(false);
  }

  //
  void onDocumentsSelected(List<File> documents) {
    selectedDocuments = documents;
    notifyListeners();
  }

  void onSelfieCaptured(XFile? selfie) {
    driverSelfie = selfie;
    notifyListeners();
  }

  submitDocuments() async {
    //if no document is selected
    if (selectedDocuments.isEmpty) {
      toastError("Please select a document".tr());
      return;
    }

    if (driverSelfie == null) {
      toastError("Please upload live selfie".tr());
      return;
    }

    setBusyForObject(selectedDocuments, true);

    try {
      //
      final apiResponse = await _authRequest.submitDocumentsRequest(
        docs: selectedDocuments,
        driverImage: driverSelfie!,
      );

      if (apiResponse.allGood) {
        await AlertService.success(
          title: "Document Request".tr(),
          text: "${apiResponse.message}",
        );
        //
        fetchMyProfile();
        //
      } else {
        toastError("${apiResponse.message}");
      }
    } catch (error) {
      toastError("$error");
    }

    setBusyForObject(selectedDocuments, false);
  }
}
