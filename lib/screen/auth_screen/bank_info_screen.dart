import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qareeb/controller/bank_info_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';

class BankInfoScreen extends StatefulWidget {
  const BankInfoScreen({super.key});

  @override
  State<BankInfoScreen> createState() => _BankInfoScreenState();
}

class _BankInfoScreenState extends State<BankInfoScreen> {
  BankInfoController bankInfoController = Get.put(BankInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: whiteColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_sharp, size: 20, color: blackColor),
        ),
        title: Text(
          "Bank Information".tr,
          style: TextStyle(
            color: blackColor,
            fontSize: 16,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            stepWiseLiner(value: 0.75),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      textfield(
                        controller: bankInfoController.ibanNumberController,
                        label: "IBAN Number".tr,
                      ),
                      const SizedBox(height: 20),
                      textfield(
                        controller: bankInfoController.bankNameController,
                        label: "Bank Name".tr,
                      ),
                      const SizedBox(height: 20),
                      textfield(
                        controller: bankInfoController.holderNameController,
                        label: "Account Holder Name".tr,
                      ),
                      const SizedBox(height: 20),
                      textfield(
                        controller: bankInfoController.vatIdController,
                        label: "VAT ID".tr,
                      ),
                      const SizedBox(height: 100), // Extra space for keyboard
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: GetBuilder<BankInfoController>(
            builder: (bankInfoController) {
              return bankInfoController.isLoading
                  ? button(
                      text: "SUBMIT AND NEXT".tr,
                      color: appColor,
                      onPress: () {
                        if (bankInfoController.ibanNumberController.text.isNotEmpty &&
                            bankInfoController
                                .bankNameController.text.isNotEmpty &&
                            bankInfoController
                                .holderNameController.text.isNotEmpty &&
                            bankInfoController
                                .vatIdController.text.isNotEmpty) {
                          bankInfoController.bankInfoApi(context: context);
                          setState(() {});
                        } else {
                          snackBar(
                            context: context,
                            text: "Please Enter All Details".tr,
                          );
                        }
                      },
                    )
                  : SizedBox(
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(color: appColor),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
