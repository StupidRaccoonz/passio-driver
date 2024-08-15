import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/payment_account.dart';
import 'package:fuodz/services/validator.service.dart';
import 'package:fuodz/view_models/edit_payment_account.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditPaymentAccountPage extends StatelessWidget {
  const EditPaymentAccountPage(this.paymentAccount, {Key? key})
      : super(key: key);

  final PaymentAccount paymentAccount;

  @override
  Widget build(BuildContext context) {
    //
    return BasePage(
      title: "Edit Payment Account".tr(),
      showLeadingAction: true,
      showAppBar: true,
      body: ViewModelBuilder<EditPaymentAccountViewModel>.reactive(
        viewModelBuilder: () =>
            EditPaymentAccountViewModel(context, paymentAccount),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              //
              SingleChildScrollView(
                child: Form(
                  key: vm.formKey,
                  child: VStack(
                    [
                      Container(
                        // decoration: BoxDecoration(color:),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => vm.changeAccountTypeTab(0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    color: vm.selectedAccountTypeIndex == 0
                                        ? AppColor.primaryColor
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  'Bank account',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => vm.changeAccountTypeTab(1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    color: vm.selectedAccountTypeIndex == 1
                                        ? AppColor.primaryColor
                                        : const Color.fromARGB(
                                            255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  'MTN Mobile',
                                  style: TextStyle(
                                      color: vm.selectedAccountTypeIndex == 1
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => vm.changeAccountTypeTab(2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                    color: vm.selectedAccountTypeIndex == 2
                                        ? AppColor.primaryColor
                                        : const Color.fromARGB(
                                            255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  'Orange Money',
                                  style: TextStyle(
                                      color: vm.selectedAccountTypeIndex == 2
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      // Bank account inputs
                      Visibility(
                          visible: vm.selectedAccountTypeIndex == 0,
                          child: VStack([
                            CustomTextFormField(
                              labelText: "Bank Name".tr(),
                              textEditingController: vm.nameTEC,
                              validator: FormValidator.validateName,
                            ).py12(),
                            CustomTextFormField(
                              labelText: "Bank Account Number".tr(),
                              keyboardType: TextInputType.number,
                              textEditingController: vm.bankAccountNumberTEC,
                              // validator: (value) => FormValidator.validateCustom(value),
                            ).py12(),
                            CustomTextFormField(
                              labelText: "Name of the beneficiary".tr(),
                              keyboardType: TextInputType.multiline,
                              textEditingController: vm.nameOfTheBeneficiaryTEC,
                            ).py12(),
                            CustomTextFormField(
                              labelText: "Original Bank Account Number".tr(),
                              keyboardType: TextInputType.multiline,
                              textEditingController: vm.ifscCodeTEC,
                            ).py12(),
                          ])),
                      //
                      //  MTN mobile money inputs
                      Visibility(
                          visible: vm.selectedAccountTypeIndex == 1,
                          child: VStack([
                            CustomTextFormField(
                              labelText: "MTN Mobile Money Number".tr(),
                              keyboardType: TextInputType.number,
                              textEditingController: vm.mtnMobileNumberTEC,
                            ).py12(),
                            CustomTextFormField(
                              labelText: "Name on MTN Mobile Money".tr(),
                              keyboardType: TextInputType.multiline,
                              textEditingController: vm.mtnNameMobileMoneyTEC,
                            ).py12(),
                          ])),
                      //

                      // orange mobile number inputs
                      Visibility(
                          visible: vm.selectedAccountTypeIndex == 2,
                          child: VStack([
                            CustomTextFormField(
                              labelText: "Orange Mobile Number".tr(),
                              keyboardType: TextInputType.number,
                              textEditingController: vm.orangeMobileNumberTEC,
                            ).py12(),
                            CustomTextFormField(
                              labelText: "Name on Orange Money".tr(),
                              keyboardType: TextInputType.multiline,
                              textEditingController: vm.nameOrangeNameTEC,
                            ).py12(),
                          ])),
                      //

                      CustomTextFormField(
                        labelText: "Instructions".tr(),
                        keyboardType: TextInputType.multiline,
                        textEditingController: vm.instructionsTEC,
                      ).py12(),

                      HStack(
                        [
                          Checkbox(
                            value: vm.isActive,
                            onChanged: (value) {
                              vm.isActive = value ?? false;
                              vm.notifyListeners();
                            },
                          ),
                          "Active".tr().text.make().expand(),
                        ],
                      ).py12(),

                      CustomButton(
                        title: "Save".tr(),
                        loading: vm.isBusy,
                        onPressed: vm.processSave,
                      ).centered().py12(),
                    ],
                    crossAlignment: CrossAxisAlignment.end,
                  ),
                ),
              )
            ],
          ).p20().scrollVertical();
        },
      ),
    );
  }
}
