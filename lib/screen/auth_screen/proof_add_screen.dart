import 'dart:io';

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
  const ProofAddScreen({super.key, required this.name, required this.imageSide, required this.fieldName, required this.inputFieldRequire, required this.docID});

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

  AddDocumentController addDocumentController = Get.put(AddDocumentController());

  @override
  void initState() {
    print("++++++++++++ ${widget.imageSide.toString()}");
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
      bottomNavigationBar: GetBuilder<AddDocumentController>(
        builder: (addDocumentController) {
          return
            addDocumentController.isLoading
                ? Container(
              margin: const EdgeInsets.all(10),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: button(text: "SUBMIT".tr, color: appColor,onPress: (){
                widget.imageSide == "1"
                    ? addDocumentController.addDocumentApi(context: context, docId: widget.docID.toString(), fname: fieldController.text, frontImage: xFileImageFront!.path , backImage: "")
                     : widget.imageSide == "2"
                ? addDocumentController.addDocumentApi(context: context, docId: widget.docID.toString(), fname: fieldController.text, frontImage: "", backImage: xFileImageBack!.path)
                : addDocumentController.addDocumentApi(context: context, docId: widget.docID.toString(), fname: fieldController.text, frontImage: xFileImageFront!.path, backImage: xFileImageBack!.path);
              }))
                : Container(
              margin: const EdgeInsets.all(15),
              height: 40,
                child: Center(child: CircularProgressIndicator(color: appColor)));
        }
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
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
            widget.imageSide == "1"
                ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: galleryFileFront  == null ? greyText : appColor,
                    radius: const Radius.circular(15),
                    // borderPadding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        getImageFront(ImageSource.gallery,context);
                        setState(() {

                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: galleryFileFront  == null
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
                                "Upload Front",
                                style: TextStyle(
                                  color: greyText,
                                  fontSize: 12,
                                  fontFamily: FontFamily.sofiaProBold,
                                ),
                              ),
                            ],
                          )
                              : Container(
                            height: 200,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                    image: FileImage(galleryFileFront!),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),

                      ),
                    ),
                  ),
                )
                : const SizedBox(),
            widget.imageSide == "2"
                ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: galleryFileBack  == null ? greyText : appColor,
                    radius: const Radius.circular(15),
                    // borderPadding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        getImageBack(ImageSource.gallery,context);
                        setState(() {


                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: galleryFileBack  == null
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
                            height: 200,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                    image: FileImage(galleryFileBack!),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),

                      ),
                    ),
                  ),
                )
                : const SizedBox(),
            widget.imageSide == "3"
                ? Row(
              children: [
                 Expanded(
                   child: Container(
                     height: 200,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(15)
                     ),
                     child: DottedBorder(
                       borderType: BorderType.RRect,
                       color: galleryFileFront  == null ? greyText : appColor,
                       radius: const Radius.circular(15),
                       // borderPadding: EdgeInsets.symmetric(horizontal: 20),
                       child: InkWell(
                         onTap: () {
                           getImageFront(ImageSource.gallery,context);
                           setState(() {


                           });
                         },
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(15),
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15),
                             ),
                             child: galleryFileFront  == null
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
                               height: 200,
                               width: Get.width,
                               decoration: BoxDecoration(
                                   color: Colors.transparent,
                                   borderRadius: BorderRadius.circular(13),
                                   image: DecorationImage(
                                       image: FileImage(galleryFileFront!),
                                       fit: BoxFit.cover
                                   )
                               ),
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: galleryFileBack  == null ? greyText : appColor,
                      radius: const Radius.circular(15),
                      // borderPadding: EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          getImageBack(ImageSource.gallery,context);
                          setState(() {


                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: galleryFileBack  == null
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
                              height: 200,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(13),
                                  image: DecorationImage(
                                      image: FileImage(galleryFileBack!),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
                : const SizedBox(),
           widget.inputFieldRequire == "1"
               ? Column(
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
           )
               : const SizedBox(),
          ],
        ),
      ),
    );
  }
  Future getImageFront(ImageSource img,context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      galleryFileFront = File(pickedFile!.path);
      xFileImageFront = xFilePick;
      setState(() {

      });
    }
    else {
      snackBar(context: context, text: "Nothing is Selected".tr);
    }
    setState(() { });
  }

  Future getImageBack(ImageSource img,context) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xFilePick = pickedFile;
    if (xFilePick != null) {
      galleryFileBack = File(pickedFile!.path);
      xFileImageBack = xFilePick;
      setState(() {

      });
    }
    else {
      snackBar(context: context, text: "Nothing is Selected".tr);
    }
    setState(() { });
  }

}
