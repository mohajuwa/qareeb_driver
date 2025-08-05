// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qareeb/utils/colors.dart';
import '../utils/font_family.dart';
import 'package:get/get.dart';

import 'dark_light_mode.dart';

Widget button({
  required String text,
  required Color color,
  void Function()? onPress,
}) {
  return SizedBox(
    height: 49,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.sofiaProBold,
          color: whiteColor,
          letterSpacing: 0.4,
        ),
      ),
    ),
  );
}

Widget button2({
  required String text,
  required Color color,
  void Function()? onPress,
}) {
  return SizedBox(
    height: 49,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.sofiaProBold,
          color: whiteColor,
          letterSpacing: 0.4,
        ),
      ),
    ),
  );
}

Widget button3({
  required Color borderColor,
  required String text,
  required Color color,
  void Function()? onPress,
  required Color textColor,
}) {
  return SizedBox(
    height: 49,
    width: double.infinity,
    child: ElevatedButton(
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: borderColor),
          ),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: FontFamily.sofiaProRegular,
          color: textColor,
        ),
      ),
    ),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({
  required context,
  required String text,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          fontFamily: FontFamily.sofiaProBold,
          fontSize: 14,
        ),
      ),
      backgroundColor: appColor,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

Future flutterToast({required String text}) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: appColor,
    textColor: whiteColor,
    fontSize: 16.0,
  );
}

late ColorNotifier notifier;
textfield({
  void Function()? onTap,
  int? maxLines,
  String? type,
  String? type2,
  labelText,
  prefixtext,
  String? label,
  String? helperText,
  suffix,
  Color? labelcolor,
  prefixcolor,
  floatingLabelColor,
  focusedBorderColor,
  TextDecoration? decoration,
  bool? readOnly,
  double? Width,
  int? max,
  TextEditingController? controller,
  TextInputType? textInputType,
  Function(String)? onChanged,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  Height,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      notifier = Provider.of<ColorNotifier>(context, listen: true);
      return Container(
        height: Height,
        width: Width,
        margin: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: notifier.background,
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          cursorColor: notifier.textColor,
          keyboardType: textInputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: max,
          onTap: onTap,
          readOnly: readOnly ?? false,
          inputFormatters: inputFormatters,
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: FontFamily.sofiaProRegular,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            suffixIcon: suffix,
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: FontFamily.sofiaRegular,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: labelText,
            helperStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: FontFamily.sofiaRegular,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            helperText: helperText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: FontFamily.sofiaRegular,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appColor),
              borderRadius: BorderRadius.circular(13),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          validator: validator,
        ),
      );
    },
  );
}

Widget stepWiseLiner({required double value}) {
  return LinearProgressIndicator(
    borderRadius: BorderRadius.circular(0),
    backgroundColor: appColor.withOpacity(0.3),
    valueColor: AlwaysStoppedAnimation(appColor),
    minHeight: 4,
    value: value,
  );
}

textfield2({
  int? maxLines,
  String? type,
  String? type2,
  labelText,
  prefixtext,
  String? label,
  String? helperText,
  suffix,
  Color? labelcolor,
  prefixcolor,
  floatingLabelColor,
  focusedBorderColor,
  TextDecoration? decoration,
  bool? readOnly,
  double? Width,
  int? max,
  TextEditingController? controller,
  TextInputType? textInputType,
  Function(String)? onChanged,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  Height,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        height: Height,
        width: Width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: whiteColor,
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          cursorColor: blackColor,
          keyboardType: textInputType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: max,
          readOnly: readOnly ?? false,
          inputFormatters: inputFormatters,
          style: TextStyle(
            color: blackColor,
            fontFamily: FontFamily.sofiaProRegular,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            suffixIcon: suffix,
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: FontFamily.sofiaRegular,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            hintText: labelText,
            helperStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: FontFamily.sofiaRegular,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            helperText: helperText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontFamily: FontFamily.sofiaRegular,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appColor),
              borderRadius: BorderRadius.circular(13),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          validator: validator,
        ),
      );
    },
  );
}

Widget homeDrawer({
  required context,
  required String image,
  required String title,
  void Function()? onTap,
}) {
  late ColorNotifier notifier;
  notifier = Provider.of<ColorNotifier>(context, listen: true);
  return ListTile(
    minLeadingWidth: 0,
    onTap: onTap,
    // dense: true,
    visualDensity: VisualDensity.compact,
    leading: SizedBox(
      height: 25,
      width: 25,
      // color: Colors.red,
      child: SvgPicture.asset(image, color: appColor, fit: BoxFit.cover),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontFamily: FontFamily.sofiaProBold,
        letterSpacing: 0.5,
        fontSize: 15,
        color: notifier.textColor,
        height: 1.4,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_outlined,
      size: 18,
      color: Colors.grey.shade500,
    ),
  );
}
