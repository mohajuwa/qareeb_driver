import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/data_store.dart';
import '../../controller/review_detail_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';


class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {

  @override
  void initState() {
    getDarkMode();
    reviewDetailController.isLoading = false;
    log("-------GET--------- ${getData.read("UserLogin")}");
    reviewDetailController.reviewDetailApi(context: context);
    super.initState();
  }

  ReviewDetailController reviewDetailController = Get.put(ReviewDetailController());

  late ColorNotifier notifier;

  getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    if (previousState == null) {
      notifier.setIsDark = false;
    } else {
      notifier.setIsDark = previousState;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: notifier.background,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: notifier.containerColor,
        title: Text(
          "My Review".tr,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 16,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      body: GetBuilder<ReviewDetailController>(
        builder: (context) {
          return reviewDetailController.isLoading
          ? reviewDetailController.reviewDetailModel!.reviewData.isNotEmpty
              ? Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(10),
                  color: notifier.containerColor,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.separated(
                          itemCount: reviewDetailController.reviewDetailModel!.reviewData.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: notifier.borderColor),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ride ID:- ${reviewDetailController.reviewDetailModel!.reviewData[index].requestId}",
                                          style: TextStyle(
                                            fontFamily: FontFamily.sofiaProBold,
                                            color: notifier.textColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          reviewDetailController.reviewDetailModel!.reviewData[index].date,
                                          style: TextStyle(
                                            fontFamily: FontFamily.sofiaProBold,
                                            color: notifier.textColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 55,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: appColor,
                                          ),
                                          child: Text(
                                            reviewDetailController.reviewDetailModel!.reviewData[index].cusName[0].toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: FontFamily.sofiaProBold,
                                              color: whiteColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                reviewDetailController.reviewDetailModel!.reviewData[index].cusName,
                                                style: TextStyle(
                                                  color: notifier.textColor,
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              reviewDetailController.reviewDetailModel!.reviewData[index].review == ""
                                                  ? const SizedBox()
                                                  : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    reviewDetailController.reviewDetailModel!.reviewData[index].review,
                                                    style: TextStyle(
                                                      color: greyText,
                                                      fontSize: 15,
                                                      fontFamily: FontFamily.gilroyMedium,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 4,
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          // height: 40,
                                          // width: 70,
                                          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: appColor,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/image/rating_filled.svg",
                                                color: appColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "${reviewDetailController.reviewDetailModel!.reviewData[index].totStar}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: FontFamily.gilroyBold,
                                                      color: appColor,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                    reviewDetailController.reviewDetailModel!.reviewData[index].defTitle.isNotEmpty
                                        ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 15),
                                        GridView.builder(
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 35,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 8,
                                          ),
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: reviewDetailController.reviewDetailModel!.reviewData[index].defTitle.length,
                                          itemBuilder: (context, index1) {
                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:  appColor,
                                                  borderRadius: BorderRadius.circular(35),
                                              ),
                                              child: Text(
                                                reviewDetailController.reviewDetailModel!.reviewData[index].defTitle[index1],
                                                style: TextStyle(
                                                    fontFamily: FontFamily.sofiaProBold,
                                                    fontSize: 13,
                                                    color: whiteColor,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                        : const SizedBox(),
                                    const SizedBox(height: 8),

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/image/emptyOrder.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "No Review Found!".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.sofiaProBold,
                    color: notifier.textColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Currently you don’t have review.".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.sofiaProRegular,
                    fontSize: 15,
                    color: greyText,
                  ),
                ),
              ],
            ),
          )
              : Center(
              child: CircularProgressIndicator(color: appColor));
        }
      ),
    );
  }

}




