import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/requests/payment_account.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EditPaymentAccountViewModel extends MyBaseViewModel {
  //
  EditPaymentAccountViewModel(BuildContext context, this.paymentAccount) {
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
  PaymentAccount paymentAccount;

  int selectedAccountTypeIndex = 0;

  void changeAccountTypeTab(index) {
    if (selectedAccountTypeIndex == index) {
      return;
    }
    selectedAccountTypeIndex = index;
    notifyListeners();
  }

  //
  void initialise() {
    nameTEC.text = paymentAccount.name;
    bankAccountNumberTEC.text = paymentAccount.number;
    nameOfTheBeneficiaryTEC.text = paymentAccount.nameOfBeneficiary;
    ifscCodeTEC.text = paymentAccount.ifscCode;
    mtnMobileNumberTEC.text = paymentAccount.mtnMobileNumber;
    mtnNameMobileMoneyTEC.text = paymentAccount.mtnName;
    orangeMobileNumberTEC.text = paymentAccount.orangeMoneyNumber;
    nameOrangeNameTEC.text = paymentAccount.orangeMoneyName;
    instructionsTEC.text = paymentAccount.instructions;
    isActive = paymentAccount.isActive;

    if (paymentAccount.name != '') {
      changeAccountTypeTab(0);
    } else if (paymentAccount.mtnName != '') {
      changeAccountTypeTab(1);
    } else {
      changeAccountTypeTab(2);
    }
    notifyListeners();
  }

  //
  processSave() async {
    if (formKey.currentState!.validate()) {
      //
      setBusy(true);
      //
      final apiResponse = await paymentAccountRequest.updatePaymentAccount(
        paymentAccount.id,
        {
          "name": nameTEC.text,
          "number": bankAccountNumberTEC.text,
          "beneficiary_name": nameOfTheBeneficiaryTEC.text,
          "IFSC_code_or_bank_code": ifscCodeTEC.text,
          "mtn _money_number": mtnMobileNumberTEC.text,
          "mtn_name": mtnNameMobileMoneyTEC.text,
          "orange_money_number": orangeMobileNumberTEC.text,
          "oragne_name": nameOrangeNameTEC.text,
          "instructions": instructionsTEC.text,
          "is_active": isActive ? "1" : "0",
        },
      );

      //
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Edit Payment Account".tr(),
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
