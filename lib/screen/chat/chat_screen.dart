import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/config.dart';
import '../../config/data_store.dart';
import '../../controller/chat_list_controller.dart';
import '../../utils/colors.dart';
import 'package:get/get.dart';
import '../../utils/font_family.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../widget/dark_light_mode.dart';

class ChatScreen extends StatefulWidget {
  final String customer;
  const ChatScreen({super.key, required this.customer});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late ScrollController _controller;
  TextEditingController messageController = TextEditingController();
  ChatListController chatListController = Get.put(ChatListController());
  late IO.Socket socket;

  String message = "";

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
  void initState() {
    getDarkMode();
    _controller = ScrollController();
    socketConnect();
    super.initState();
  }



  socketConnect() async {
    socket = IO.io(Config.socketUrl,<String,dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],

    });
    socket.connect();
    _connectSocket();
    chatListController.chatListApi(context: context, customer: widget.customer.toString());
  }


  _connectSocket() {
    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));

    socket.on("New_Chat${getData.read("UserLogin")['id']}", (status){
      print("==================== ${status}");
      chatListController.chatListApi(context: context, customer: widget.customer.toString());
    });

  }

  _sendMessage() {
    socket.emit('Send_Chat', {
      'sender_id': getData.read("UserLogin")['id'].toString(),
      'recevier_id': widget.customer.toString(),
      'status': "driver",
      'message': messageController.text.trim(),
    });
    messageController.clear();
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
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,size: 20,color: notifier.textColor,)),
        title: GetBuilder<ChatListController>(
          builder: (context) {
            return chatListController.isLoading ? Text(
              chatListController.chatListModel!.userData.name,
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 18,
                fontFamily: FontFamily.sofiaProBold,
              ),
            ) : const SizedBox();
          }
        ),
      ),
      body: GetBuilder<ChatListController>(
        builder: (context) {
          return chatListController.isLoading
              ? chatListController.chatListModel!.chatList.isNotEmpty
              ? Scrollbar(
            controller: _controller,
            trackVisibility: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              reverse: true,
              child: Stack(
                children: [
                  Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        cacheExtent: 99999999,
                        itemCount: chatListController.chatListModel!.chatList.length,
                        itemBuilder: (context, index1) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(chatListController.chatListModel!.chatList[index1].date,style:  TextStyle(
                                color: notifier.textColor,
                                fontSize: 14,
                                fontFamily: FontFamily.gilroyBold,
                              ),),
                              ListView.separated(
                                shrinkWrap: true,
                                cacheExtent: 99999999,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                                separatorBuilder: (_, index) => const SizedBox(
                                  height: 5,
                                ),
                                itemCount: chatListController.chatListModel!.chatList[index1].chat.length,
                                itemBuilder: (context, index) {
                                  return Wrap(
                                    alignment: chatListController.chatListModel!.chatList[index1].chat[index].status == 1  ? WrapAlignment.end : WrapAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: chatListController.chatListModel!.chatList[index1].chat[index].status == 1
                                              ? appColor
                                              : notifier.containerColor,
                                          borderRadius: chatListController.chatListModel!.chatList[index1].chat[index].status == 1
                                              ? const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                                              : const BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: chatListController.chatListModel!.chatList[index1].chat[index].status == 1 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                            children: [
                                              messageController.text != null
                                                  ? Text(chatListController.chatListModel!.chatList[index1].chat[index].message,
                                                style: TextStyle(
                                                  color: chatListController.chatListModel!.chatList[index1].chat[index].status == 1 ? whiteColor : notifier.textColor,
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.gilroyBold,
                                                ),)
                                                  :  Text(chatListController.chatListModel!.chatList[index1].chat[index].message,style:  TextStyle(
                                                color: whiteColor,
                                                fontSize: 16,
                                                fontFamily: FontFamily.gilroyBold,
                                              ),),
                                              const SizedBox(height: 6),
                                              Text(
                                                chatListController.chatListModel!.chatList[index1].chat[index].date,
                                                style:  TextStyle(
                                                  color: chatListController.chatListModel!.chatList[index1].chat[index].status == 1 ? Colors.white : notifier.textColor,
                                                  fontSize: 12,
                                                  fontFamily: FontFamily.gilroyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                  "No Chat Found!".tr,
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
                  "Currently you don’t have chat.".tr,
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.gilroyBold,
                      color: notifier.textColor
                  ),
                  decoration: InputDecoration(
                      fillColor: notifier.containerColor,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (messageController.text.trim().isNotEmpty) {
                            print("++++++++++ ${messageController.text.trim()}");
                            _sendMessage();
                            chatListController.chatListApi(context: context, customer: widget.customer.toString());
                            setState(() {

                            });
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: notifier.textColor,
                          size: 22,
                        ),),
                      hintStyle:  TextStyle(
                          fontSize: 14,
                          fontFamily: FontFamily.gilroyBold,
                          color: notifier.textColor
                      ),
                      hintText: "Say Something...".tr,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: notifier.borderColor),
                          borderRadius: BorderRadius.circular(65)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: notifier.borderColor),
                          borderRadius: BorderRadius.circular(65)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appColor,width: 1.8),
                          borderRadius: BorderRadius.circular(65)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: notifier.borderColor),
                          borderRadius: BorderRadius.circular(65))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
