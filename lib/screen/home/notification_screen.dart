// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable, unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qareeb/config/config.dart';
import '../../controller/common_notification_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/dark_light_mode.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  CommonNotificationController commonNotificationController = Get.put(
    CommonNotificationController(),
  );

  @override
  void initState() {
    getDarkMode();
    commonNotificationController.commonNotificationApi(context: context);
    super.initState();
  }

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
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.containerColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
        ),
        title: Text(
          "Notification".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.sofiaProBold,
            color: notifier.textColor,
          ),
        ),
      ),
      body: GetBuilder<CommonNotificationController>(
        builder: (commonNotificationController) {
          return Column(
            children: [
              Expanded(
                child: commonNotificationController.isLoading
                    ? commonNotificationController
                            .commonNotificationModel!.ndata.isNotEmpty
                        ? ListView.builder(
                            itemCount: commonNotificationController
                                .commonNotificationModel!.ndata.length,
                            itemBuilder: (context, index) {
                              // String time = "${DateFormat.jm().format(DateTime.parse("2023-03-20T${notificationController.notificationModel?.notification[index].date.toString().split(" ").last}"))}";
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  isThreeLine: true,
                                  leading: Container(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(65),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/image/ezgif.com-crop.gif",
                                        placeholderCacheWidth: 60,
                                        placeholderCacheHeight: 60,
                                        image:
                                            "${Config.imageUrl}${commonNotificationController.commonNotificationModel!.ndata[index].image}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: notifier.containerColor,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: Get.width / 1.8,
                                        child: Text(
                                          commonNotificationController
                                              .commonNotificationModel!
                                              .ndata[index]
                                              .title,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: FontFamily.gilroyBold,
                                            color: notifier.textColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "#${commonNotificationController.commonNotificationModel!.ndata[index].id}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: FontFamily.gilroyBold,
                                          color: notifier.textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 3),
                                      Text(
                                        "${commonNotificationController.commonNotificationModel!.ndata[index].date}",
                                        style: TextStyle(
                                          color: greyText,
                                          fontFamily: FontFamily.gilroyMedium,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "${commonNotificationController.commonNotificationModel!.ndata[index].description}",
                                        style: TextStyle(
                                          color: greyText,
                                          fontFamily: FontFamily.gilroyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: notifier.containerColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "We'll let you know when we\nget news for you"
                                      .tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: greyText,
                                    fontFamily: FontFamily.gilroyBold,
                                  ),
                                ),
                              ],
                            ),
                          )
                    : Center(child: CircularProgressIndicator(color: appColor)),
              ),
            ],
          );
        },
      ),
    );
  }
}
