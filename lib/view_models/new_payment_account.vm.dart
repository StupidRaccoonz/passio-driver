import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/requests/payment_account.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewPaymentAccountViewModel extends MyBaseViewModel {
  //
  NewPaymentAccountViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  PaymentAccountRequest paymentAccountRequest = PaymentAccountRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController bankAccountNumberTEC = TextEditingController();
  TextEditingController nameOfTheBeneficiaryTEC = TextEditingController();
  TextEditingController ifscCodeTEC = TextEditingController();
  TextEditingController mtnMobileNumberTEC = TextEditingController();
  TextEditingController mtnNameMobileMoneyTEC = TextEditingController();
  TextEditingController orangeMobileNumberTEC = TextEditingController();
  TextEditingController nameOrangeNameTEC = TextEditingController();
  TextEditingController instructionsTEC = TextEditingController();
  bool isActive = true;

  int selectedAccountTypeIndex = 0;

  void changeAccountTypeTab(index) {
    if (selectedAccountTypeIndex == index) {
      return;
    }
    selectedAccountTypeIndex = index;
    notifyListeners();
  }

  //
  processSave() async {
    if (formKey.currentState!.validate()) {
      //
      setBusy(true);
      //
      final apiResponse = await paymentAccountRequest.newPaymentAccount(
        {
          "name": nameTEC.text,
          "number": bankAccountNumberTEC.text,
          "beneficiary_name": nameOfTheBeneficiaryTEC.text,
          "IFSC_code_or_bank_code": ifscCodeTEC.text,
          "mtn_money_number": mtnMobileNumberTEC.text,
          "mtn_name": mtnNameMobileMoneyTEC.text,
          "orange_money_number": orangeMobileNumberTEC.text,
          "oragne_name": nameOrangeNameTEC.text,
          "instructions": instructionsTEC.text,
          "is_active": isActive ? "1" : "0",
        },
      );

      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "New Payment Account".tr(),
        text:
            apiResponse.allGood ? "Successful".tr() : "${apiResponse.message}",
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                //cool
                final newPaymentAccount = PaymentAccount.fromJson(
                  apiResponse.body["data"],
                );
                //
                viewContext.pop();
                viewContext.pop(newPaymentAccount);
              }
            : null,
      );
      setBusy(false);
    }
  }
}
