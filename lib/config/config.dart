import 'data_store.dart';

class Config {
  static const mapKey = "AIzaSyB99Z7-KwgRCtvTae9brf7vDeRJBOqnPX8";
  static String oneSignal = "${getData.read("OneSignal")}";

  static const imageUrl = "https://qareeb.modwir.com/";

  static const socketUrl = imageUrl;
  static const baseUrl = "${imageUrl}driver/";
  static const chatUrl = "${imageUrl}chat/";

  static const login = "login";
  static const mobileCheck = "mobile_check";
  static const otpGet = "otp_detail";
  static const msgOtp = "msg91";
  static const twilioOtp = "twilio";
  static const infoDetail = "signup_detail";
  static const personalInfo = "signup";
  static const driverInfo = "add_driver_vehicle";
  static const bankInfo = "add_driver_bankaccount";
  static const checkDriverLocation = "driver_document";
  static const addDocument = "add_documentdata";
  static const updateLocation = "update_latlon";
  static const checkVehicleRequest = "check_vehicle_request";
  static const requestDetail = "cus_ride_detail";
  static const acceptRequest = "accept_vehicle_ride";
  static const timeSend = "veh_req_time_set";
  static const cancelRequest = "veh_req_cancel";
  static const documentStatus = "customer_check";
  static const iAmHere = "vehicle_dri_here";
  static const otpRide = "vehicle_otp_check";
  static const rideStart = "vehicle_ride_start";
  static const rideEnd = "vehicle_ride_end";
  static const priceDetail = "vehicle_price_detail";
  static const rateReview = "add_review";
  static const walletDetail = "wallet_data";
  static const myEarning = "my_earning";
  static const rideHistory = "ride_history";
  static const rideHistoryDetail = "ride_history_detail";
  static const review = "rating_data";
  static const profile = "Profile_data";
  static const editProfile = "edit_profile";
  static const chatList = "chat_list";
  static const cancelReason = "vehicle_cancel_reason";
  static const backgroundUpdate = "background_update";
  static const payout = "Wallet_withdraw";
  static const payoutDetails = "wallet_payout_data";
  static const notification = "send_default_notification";
  static const totalCash = "cash_adjust_data";
  static const addCash = "add_cash";
  static const cashDetails = "cash_data";
  static const commonNotification = "notification";
  static const deleteAccount = "account_deactive";
}
