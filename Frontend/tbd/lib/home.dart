// import 'dart:async';
// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MyHome extends StatefulWidget {
//   const MyHome({Key? key}) : super(key: key);

//   @override
//   State<MyHome> createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   String? _filePath;
//   String? predicted;
//   String prediction = '';
//   Future<void> uploadAudio(File audioFile) async {
//     final url =
//         "https://urbansound-production.up.railway.app//predict"; // Change this to your Flask back-end URL
//     var request = await http.MultipartRequest('POST', Uri.parse(url));
//     request.files
//         .add(await http.MultipartFile.fromPath('audio', audioFile.path));
//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();
//     setState(() {
//       prediction = responseData;
//     });
//     print(responseData);
//   }

// //pickwavfile not used
//   Future<void> pickWavFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav'],
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;
//       setState(() {
//         _filePath = file.path;
//       });
//     }
//   }

// //Audio player 1
//   final audioPlayer1 = AudioPlayer();
// //Audio player 2
//   final audioPlayer2 = AudioPlayer();
//   bool isPlaying1 = false;
//   bool isPlaying2 = false;
//   Duration duration1 = Duration.zero;
//   Duration duration2 = Duration.zero;
//   Duration position1 = Duration.zero;
//   Duration position2 = Duration.zero;

//   String formatTime(int seconds) {
//     return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
//   }

//   @override
//   void initState() {
//     super.initState();

//     //setAudio();
//     //loadAudio();

//     audioPlayer1.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying1 = state == PlayerState.playing;
//       });
//     });

//     audioPlayer2.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying2 = state == PlayerState.playing;
//       });
//     });

//     audioPlayer1.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration1 = newDuration;
//       });
//     });

//     audioPlayer2.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration2 = newDuration;
//       });
//     });

//     audioPlayer1.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position1 = newPosition;
//       });
//     });

//     audioPlayer2.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position2 = newPosition;
//       });
//     });
//   }

//   Future setAudio() async {
//     audioPlayer1.setReleaseMode(ReleaseMode.stop);

//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav'],
//     );
//     if (result != null) {
//       final file = File(result.files.single.path!);
//       audioPlayer1.setSourceUrl(file.path);
//       setState(() {
//         _filePath = file.path;
//       });
//     }
//   }

//   Future loadAudio() async {
//     audioPlayer2.setReleaseMode(ReleaseMode.stop);

//     //Load audio from assets
//     final player = AudioCache(prefix: 'assets/');
//     final url = await player.load(prediction + '.wav');
//     audioPlayer2.setSourceUrl(url.path);
//   }

//   @override
//   void dispose() {
//     audioPlayer1.dispose();
//     audioPlayer2.dispose();

//     super.dispose();
//   }

// // widgets starting
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Predictor'),
//         centerTitle: true,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, 'login');
//             },
//             icon: const Icon(Icons.logout_outlined),
//           )
//         ],
//         backgroundColor: Color.fromARGB(255, 58, 12, 119),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             /*TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, 'login');
//               },
//               child: Text(
//                 'logout',
//                 style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontSize: 18,
//                     color:Color.fromARGB(255, 58, 12, 119)),
//               ),
//             ),*/
//             ElevatedButton(
//               onPressed: setAudio,
//               child: Text('Select .wav file'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 58, 12, 119)),
//             ),
//             SizedBox(height: 20),
//             _filePath != null
//                 ? Text('Selected file: $_filePath')
//                 : Text('No file selected'),
//             Slider(
//               min: 0,
//               max: duration1.inSeconds.toDouble(),
//               value: position1.inSeconds.toDouble(),
//               onChanged: (value) async {
//                 final position1 = Duration(seconds: value.toInt());
//                 await audioPlayer1.seek(position1);

//                 await audioPlayer1.resume();
//               },
//               activeColor: const Color.fromARGB(255, 69, 173, 168),
//               inactiveColor: Colors.black12,
//               thumbColor: Colors.black,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatTime(position1.inSeconds)),
//                   Text(formatTime((duration1 - position1).inSeconds)),
//                 ],
//               ),
//             ),
//             CircleAvatar(
//               radius: 35,
//               child: IconButton(
//                 icon: Icon(
//                   isPlaying1 ? Icons.pause : Icons.play_arrow,
//                 ),
//                 iconSize: 40,
//                 onPressed: () async {
//                   if (isPlaying1) {
//                     await audioPlayer1.pause();
//                   } else {
//                     await audioPlayer1.resume();
//                   }
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 15, //<-- SEE HERE
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await uploadAudio(File(_filePath ?? ""));
//                 loadAudio();
//               },
//               child: Text('Predict'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 58, 12, 119)),
//             ),
//             prediction != ''
//                 ? Text(
//                     'Prediction : $prediction',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 201, 4, 4),
//                     ),
//                   )
//                 : Text(''),
//             SizedBox(
//               height: 30, //<-- SEE HERE
//             ),
//             Text(
//               "Prediction Audio",
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Color.fromARGB(255, 9, 117, 78),
//                 fontSize: 30,
//               ),
//             ),
//             Slider(
//               min: 0,
//               max: duration2.inSeconds.toDouble(),
//               value: position2.inSeconds.toDouble(),
//               onChanged: (value) async {
//                 final position2 = Duration(seconds: value.toInt());
//                 await audioPlayer2.seek(position2);

//                 await audioPlayer2.resume();
//               },
//               activeColor: Color.fromARGB(255, 11, 101, 97),
//               inactiveColor: Color.fromARGB(31, 140, 7, 49),
//               thumbColor: Colors.black,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatTime(position2.inSeconds)),
//                   Text(formatTime((duration2 - position2).inSeconds)),
//                 ],
//               ),
//             ),
//             CircleAvatar(
//               radius: 35,
//               child: IconButton(
//                 icon: Icon(
//                   isPlaying2 ? Icons.pause : Icons.play_arrow,
//                 ),
//                 iconSize: 40,
//                 onPressed: () async {
//                   if (isPlaying2) {
//                     await audioPlayer2.pause();
//                   } else {
//                     await audioPlayer2.resume();
//                   }
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// /*class MyHome extends StatefulWidget {
//   const MyHome({super.key});

//   @override
//   State<MyHome> createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Stack(
//         children: [
//           TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, 'login');
//               },
//               child: Text(
//                 'logout',
//                 style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontSize: 18,
//                     color: Color.fromARGB(255, 23, 81, 242)),
//               ))
//         ],
//       ),
//     );
//   }
// }*/

// //TB DETECTION
// import 'dart:async';
// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MyHome extends StatefulWidget {
//   const MyHome({Key? key}) : super(key: key);

//   @override
//   State<MyHome> createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   String? _filePath;
//   String? predicted;
//   String prediction = '';
//   Future<void> uploadAudio(File audioFile) async {
//     final url =
//         "https://tbdetection-production.up.railway.app/predict"; // Change this to your Flask back-end URL
//     var request = await http.MultipartRequest('POST', Uri.parse(url));
//     request.files
//         .add(await http.MultipartFile.fromPath('audio', audioFile.path));
//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();
//     setState(() {
//       prediction = responseData;
//     });
//     print(responseData);
//   }

// //pickwavfile not used
//   Future<void> pickWavFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav'],
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;

//       setState(() {
//         _filePath = file.path;
//       });
//     }
//   }

// //Audio player 1
//   final audioPlayer1 = AudioPlayer();
// //Audio player 2
//   final audioPlayer2 = AudioPlayer();
//   bool isPlaying1 = false;
//   bool isPlaying2 = false;
//   Duration duration1 = Duration.zero;
//   Duration duration2 = Duration.zero;
//   Duration position1 = Duration.zero;
//   Duration position2 = Duration.zero;

//   String formatTime(int seconds) {
//     return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
//   }

//   @override
//   void initState() {
//     super.initState();

//     //setAudio();
//     //loadAudio();

//     audioPlayer1.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying1 = state == PlayerState.playing;
//       });
//     });

//     audioPlayer2.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying2 = state == PlayerState.playing;
//       });
//     });

//     audioPlayer1.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration1 = newDuration;
//       });
//     });

//     audioPlayer2.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration2 = newDuration;
//       });
//     });

//     audioPlayer1.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position1 = newPosition;
//       });
//     });

//     audioPlayer2.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position2 = newPosition;
//       });
//     });
//   }

//   Future setAudio() async {
//     audioPlayer1.setReleaseMode(ReleaseMode.stop);

//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav'],
//     );
//     if (result != null) {
//       final file = File(result.files.single.path!);
//       audioPlayer1.setSourceUrl(file.path);
//       setState(() {
//         _filePath = file.path;
//       });
//     }
//   }

// // NOT USED here
//   Future loadAudio() async {
//     audioPlayer2.setReleaseMode(ReleaseMode.stop);

//     //Load audio from assets
//     final player = AudioCache(prefix: 'assets/');
//     final url = await player.load(prediction + '.wav');
//     audioPlayer2.setSourceUrl(url.path);
//   }

//   @override
//   void dispose() {
//     audioPlayer1.dispose();
//     audioPlayer2.dispose();

//     super.dispose();
//   }

// // widgets starting
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Predictor'),
//         centerTitle: true,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               Navigator.pushNamed(context, 'login');
//             },
//             icon: const Icon(Icons.logout_outlined),
//           )
//         ],
//         backgroundColor: Color.fromARGB(255, 58, 12, 119),
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         )),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: setAudio,
//               child: Text('Select .wav file'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 58, 12, 119)),
//             ),
//             SizedBox(height: 20),
//             _filePath != null
//                 ? Text('Selected file: $_filePath')
//                 : Text('No file selected'),
//             Slider(
//               min: 0,
//               max: duration1.inSeconds.toDouble(),
//               value: position1.inSeconds.toDouble(),
//               onChanged: (value) async {
//                 final position1 = Duration(seconds: value.toInt());
//                 await audioPlayer1.seek(position1);

//                 await audioPlayer1.resume();
//               },
//               activeColor: const Color.fromARGB(255, 69, 173, 168),
//               inactiveColor: Colors.black12,
//               thumbColor: Colors.black,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatTime(position1.inSeconds)),
//                   Text(formatTime((duration1 - position1).inSeconds)),
//                 ],
//               ),
//             ),
//             CircleAvatar(
//               radius: 35,
//               child: IconButton(
//                 icon: Icon(
//                   isPlaying1 ? Icons.pause : Icons.play_arrow,
//                 ),
//                 iconSize: 50,
//                 onPressed: () async {
//                   if (isPlaying1) {
//                     await audioPlayer1.pause();
//                   } else {
//                     await audioPlayer1.resume();
//                   }
//                 },
//               ),
//             ),
//             SizedBox(
//               width: 50, //<-- SEE HERE
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await uploadAudio(File(_filePath ?? ""));
//                 //loadAudio();
//               },
//               child: Text('Predict'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 58, 12, 119)),
//             ),
//             prediction != ''
//                 ? Text(
//                     'Prediction : $prediction',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 201, 4, 4),
//                     ),
//                   )
//                 : Text(''),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //TB DETECTION
// import 'dart:async';
// import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MyHome extends StatefulWidget {
//   const MyHome({Key? key}) : super(key: key);

//   @override
//   State<MyHome> createState() => _MyHomeState();
// }

// class _MyHomeState extends State<MyHome> {
//   String? _filePath;
//   String predicted = '';
//   //String prediction = '';
//   String groundtruth = '';
//   List<String> prediction = [];
//   Future<void> uploadAudio(File audioFile) async {
//     final url =
//         "http://13.233.48.201/predict"; // Change this to your Flask back-end URL
//     var request = await http.MultipartRequest('POST', Uri.parse(url));
//     request.files
//         .add(await http.MultipartFile.fromPath('audio', audioFile.path));
//     var response = await request.send();
//     var responseData = await response.stream.bytesToString();
//     setState(() {
//       // prediction = responseData;
//       prediction = responseData.split(',');
//       if (prediction.length >= 2) {
//         predicted = prediction[0];
//         groundtruth = prediction[1];
//       }
//     });
//     print(responseData);
//   }

// //pickwavfile not used
//   Future<void> pickWavFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav'],
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;

//       setState(() {
//         _filePath = file.path;
//       });
//     }
//   }

// //Audio player 1
//   final audioPlayer1 = AudioPlayer();
// //Audio player 2
//   final audioPlayer2 = AudioPlayer();
//   bool isPlaying1 = false;
//   bool isPlaying2 = false;
//   Duration duration1 = Duration.zero;
//   Duration duration2 = Duration.zero;
//   Duration position1 = Duration.zero;
//   Duration position2 = Duration.zero;

//   String formatTime(int seconds) {
//     return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
//   }

//   @override
//   void initState() {
//     super.initState();

//     //setAudio();
//     //loadAudio();

//     audioPlayer1.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying1 = state == PlayerState.playing;
//       });
//     });

//     audioPlayer2.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying2 = state == PlayerState.playing;
//       });
//     });

//     audioPlayer1.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration1 = newDuration;
//       });
//     });

//     audioPlayer2.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration2 = newDuration;
//       });
//     });

//     audioPlayer1.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position1 = newPosition;
//       });
//     });

//     audioPlayer2.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position2 = newPosition;
//       });
//     });
//   }

//   Future setAudio() async {
//     audioPlayer1.setReleaseMode(ReleaseMode.stop);

//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav'],
//     );
//     if (result != null) {
//       final file = File(result.files.single.path!);
//       audioPlayer1.setSourceUrl(file.path);
//       setState(() {
//         _filePath = file.path;
//       });
//     }
//   }

// // NOT USED here
//   // Future loadAudio() async {
//   //   audioPlayer2.setReleaseMode(ReleaseMode.stop);

//   //   //Load audio from assets
//   //   final player = AudioCache(prefix: 'assets/');
//   //   final url = await player.load(prediction + '.wav');
//   //   audioPlayer2.setSourceUrl(url.path);
//   // }

//   @override
//   void dispose() {
//     audioPlayer1.dispose();
//     audioPlayer2.dispose();

//     super.dispose();
//   }

// // widgets starting
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Predictor'),
//         centerTitle: true,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.logout_outlined),
//           )
//         ],
//         backgroundColor: Color.fromARGB(255, 58, 12, 119),
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         )),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: setAudio,
//               child: Text('Select .wav file'),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 58, 12, 119)),
//             ),
//             SizedBox(height: 20),
//             _filePath != null
//                 ? Text('Selected file: $_filePath')
//                 : Text('No file selected'),
//             Slider(
//               min: 0,
//               max: duration1.inSeconds.toDouble(),
//               value: position1.inSeconds.toDouble(),
//               onChanged: (value) async {
//                 final position1 = Duration(seconds: value.toInt());
//                 await audioPlayer1.seek(position1);

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Color.fromARGB(255, 94, 20, 192),
      // ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Audio Classification'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 58, 12, 119),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(280, 80),
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  primary: Color.fromARGB(255, 58, 12, 119),
                  onPrimary: Colors.white,
                  side: BorderSide(
                      width: 5, color: Color.fromARGB(255, 58, 12, 119)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'tb-dection');
                },
                child: Text('TB-DETECTION'),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(280, 80),
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  primary: Color.fromARGB(255, 252, 249, 252),
                  onPrimary: Color.fromARGB(255, 58, 12, 119),
                  side: BorderSide(
                      width: 5, color: Color.fromARGB(255, 58, 12, 119)),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'urbansound');
                },
                child: Text('URBANSOUND'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
