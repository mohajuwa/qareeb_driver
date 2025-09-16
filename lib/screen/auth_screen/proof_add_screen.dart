import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/add_document_controller.dart';
import '../../utils/colors.dart';
import '../../utils/font_family.dart';
import '../../widget/common.dart';

class ProofAddScreen extends StatefulWidget {
  final String name;
  final String imageSide;
  final String fieldName;
  final String inputFieldRequire;
  final String docID;
  const ProofAddScreen(
      {super.key,
      required this.name,
      required this.imageSide,
      required this.fieldName,
      required this.inputFieldRequire,
      required this.docID});

  @override
  State<ProofAddScreen> createState() => _ProofAddScreenState();
}

class _ProofAddScreenState extends State<ProofAddScreen> {
  get picker => ImagePicker();

  File? galleryFileFront;
  XFile? xFileImageFront;

  File? galleryFileBack;
  XFile? xFileImageBack;

  TextEditingController fieldController = TextEditingController();

  AddDocumentController addDocumentController =
      Get.put(AddDocumentController());

  @override
  void initState() {
    if (kDebugMode) {
      print("++++++++++++ ${widget.imageSide.toString()}");
    }
    super.initState();
  }

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
            child: Icon(
              Icons.arrow_back_sharp,
              size: 20,
              color: blackColor,
            )),
        title: Text(
          widget.name,
          style: TextStyle(
            color: blackColor,
            fontSize: 16,
            fontFamily: FontFamily.sofiaProBold,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child:
            GetBuilder<AddDocumentController>(builder: (addDocumentController) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: addDocumentController.isLoading
                ? button(
                    text: "SUBMIT".tr,
                    color: appColor,
                    onPress: () {
                      widget.imageSide == "1"
                          ? addDocumentController.addDocumentApi(
                              context: context,
                              docId: widget.docID.toString(),
                              fname: fieldController.text,
                              frontImage: xFileImageFront!.path,
                              backImage: "")
                          : widget.imageSide == "2"
                              ? addDocumentController.addDocumentApi(
                                  context: context,
                                  docId: widget.docID.toString(),
                                  fname: fieldController.text,
                                  frontImage: "",
                                  backImage: xFileImageBack!.path)
                              : addDocumentController.addDocumentApi(
                                  context: context,
                                  docId: widget.docID.toString(),
                                  fname: fieldController.text,
                                  frontImage: xFileImageFront!.path,
                                  backImage: xFileImageBack!.path);
                    })
                : SizedBox(
                    height: 40,
                    child: Center(
                        child: CircularProgressIndicator(color: appColor))),
          );
        }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Text(
                  "Verification identity".tr,
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 16,
                    fontFamily: FontFamily.sofiaProBold,
                  ),
                ),
                const SizedBox(height: 15),
                if (widget.imageSide == "1")
                  _buildSingleImageUpload(isBack: false),
                if (widget.imageSide == "2")
                  _buildSingleImageUpload(isBack: true),
                if (widget.imageSide == "3") _buildDoubleImageUpload(),
                if (widget.inputFieldRequire == "1")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        widget.fieldName,
                        style: TextStyle(
                          color: blackColor,
                          fontSize: 16,
                          fontFamily: FontFamily.sofiaProBold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      textfield2(
                        controller: fieldController,
                        labelText: widget.fieldName,
                      ),
                    ],
                  ),
                const SizedBox(height: 20), // Extra bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleImageUpload({required bool isBack}) {
    final file = isBack ? galleryFileBack : galleryFileFront;
    final uploadText = isBack ? "Upload Back".tr : "Upload Front".tr;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: file == null ? greyText : appColor,
        radius: const Radius.circular(15),
        child: InkWell(
          onTap: () {
            if (isBack) {
              getImageBack(ImageSource.gallery, context);
            } else {
              getImageFront(ImageSource.gallery, context);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: file == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/uplodeimage.png",
                          height: 40,
                          width: 42,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          uploadText,
                          style: TextStyle(
                            color: greyText,
                            fontSize: 12,
                            fontFamily: FontFamily.sofiaProBold,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                              image: FileImage(file), fit: BoxFit.cover)),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleImageUpload() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: DottedBorder(
              borderType: BorderType.RRect,
              color: galleryFileFront == null ? greyText : appColor,
              radius: const Radius.circular(15),
              child: InkWell(
                onTap: () {
                  getImageFront(ImageSource.gallery, context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: galleryFileFront == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/uplodeimage.png",
                                height: 40,
                                width: 42,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Upload Front".tr,
                                style: TextStyle(
                                  color: greyText,
                                  fontSize: 12,
                                  fontFamily: FontFamily.sofiaProBold,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                    image: FileImage(galleryFileFront!),
                                    fit: BoxFit.cover)),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: DottedBorder(
              borderType: BorderType.RRect,
              color: galleryFileBack == null ? greyText : appColor,
              radius: const Radius.circular(15),
              child: InkWell(
                onTap: () {
                  getImageBack(ImageSource.gallery, context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: galleryFileBack == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/uplodeimage.png",
                                height: 40,
                                width: 42,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Upload Back".tr,
                                style: TextStyle(
                                  color: greyText,
                                  fontSize: 12,
                                  fontFamily: FontFamily.sofiaProBold,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                    image: FileImage(galleryFileBack!),
                                    fit: BoxFit.cover)),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future getImageFront(ImageSource img, context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      setState(() {
        galleryFileFront = File(pickedFile!.path);
        xFileImageFront = xFilePick;
      });
    } else {
      snackBar(context: context, text: "Nothing is Selected".tr);
    }
  }

  Future getImageBack(ImageSource img, context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      setState(() {
        galleryFileBack = File(pickedFile!.path);
        xFileImageBack = xFilePick;
      });
    } else {
      snackBar(context: context, text: "Nothing is Selected".tr);
    }
  }
}
