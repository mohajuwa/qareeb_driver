// import 'package:audioplayers/audioplayers.dart';
//
// class NotificationSoundPlayer {
//   final AudioPlayer audioPlayer = AudioPlayer();
//
//   // Method to play the notification sound in a loop
//   Future<void> playNotificationSound({required String url}) async {
//     try {
//       // Set the player to loop the sound
//       await audioPlayer.setReleaseMode(ReleaseMode.loop);
//
//       // Play the sound from the URL
//       await audioPlayer.play(
//         UrlSource(url),
//       );
//     } catch (e) {
//       print("Error playing sound: $e");
//     }
//   }
//
//   // Method to stop the notification sound
//   Future<void> stopNotificationSound() async {
//     try {
//       await audioPlayer.stop();
//     } catch (e) {
//       print("Error stopping sound: $e");
//     }
//   }
// }


import 'package:audioplayers/audioplayers.dart';

class NotificationSoundPlayer {

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playNotificationSound({required String url}) async {
    stopNotificationSound();
    try {

      if (audioPlayer.state != PlayerState.playing) {

        await audioPlayer.setReleaseMode(ReleaseMode.loop);

        await audioPlayer.play(
          UrlSource(url),
        );
      } else {
        print("Sound is already playing.");
      }
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  Future<void> stopNotificationSound() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      print("Error stopping sound: $e");
    }
  }

  // Method to stop the notification sound
  // Future<void> stopNotificationSound() async {
  //   try {
  //     if (audioPlayer.state == PlayerState.playing) {
  //       await audioPlayer.stop();
  //     } else {
  //       print("Sound is not playing.");
  //     }
  //   } catch (e) {
  //     print("Error stopping sound: $e");
  //   }
  // }

}

