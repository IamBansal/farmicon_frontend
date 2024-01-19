import 'dart:io';
import 'package:farmicon/services/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'constants/enums/connectivity_status.dart';
import 'core/locator.dart';
import 'core/router.dart';
import 'services/api.dart';
import 'services/connectivity.dart';
import 'services/notification.dart';
import 'ui/app_theme.dart';
import 'ui/views/startup.dart';
import 'viewmodels/language.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await setupLocator();
  await Firebase.initializeApp();
  ApiService.init();
  NotificationService.init();

  //Set orientation.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //Setup Sentry.
  // if (ENV.SENTRY_DSN == '') {
  //   runApp(Phoenix(child: const Farmicon()));
  // } else {
  //   await SentryFlutter.init(
  //         (options) {
  //       options.dsn = ENV.SENTRY_DSN;
  //       options.tracesSampleRate = 1;
  //     },
  //     appRunner: () => runApp(Phoenix(child: const Farmicon())),
  //   );
  // }
  runApp(Phoenix(child: const Farmicon()));
}

class Farmicon extends StatelessWidget {
  const Farmicon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set notification bar color.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppTheme.white,
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider()..initialize(),
          ),
          StreamProvider<ConnectivityStatus>(
            create: (_) =>
            ConnectivityService().connectionStatusController?.stream,
            initialData: ConnectivityStatus.online,
          ),
        ],
        child: Consumer<LanguageProvider>(
          builder: (context, model, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: const StartUpView(),
              locale: model.locale,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale!.languageCode &&
                      locale.countryCode == deviceLocale.countryCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalization.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('hi', 'IN'),
              ],
              navigatorObservers: <NavigatorObserver>[
                SentryNavigatorObserver(),
              ],
              onGenerateRoute: AppRouter.generateRoute,
              title: 'Security App',
              theme: AppTheme.theme,
            );
          },
        ),
      ),
    );
  }
}






// import 'dart:convert';
// import 'dart:io' as io;
// import 'package:farmicon_frontend/ui/app_theme.dart';
// import 'package:farmicon_frontend/ui/views/startup.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'package:flutter_face_api/face_api.dart' as Regula;
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'app_localizations.dart';
// import 'constants/app_assets.dart';
//
// void main() async {
//   await Firebase.initializeApp();
//   runApp(const MaterialApp(home: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     Get.put(LocaleCont());
//     return GetBuilder<LocaleCont>(
//       builder: (cont) => GetMaterialApp(
//         locale: cont.locale,
//         debugShowCheckedModeBanner: false,
//         localeResolutionCallback: (deviceLocale, supportedLocales) {
//           for (var locale in supportedLocales) {
//             if (locale.languageCode == deviceLocale!.languageCode &&
//                 locale.countryCode == deviceLocale.countryCode) {
//               return deviceLocale;
//             }
//           }
//           return supportedLocales.first;
//         },
//         localizationsDelegates: const [
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//           AppLocalization.delegate,
//         ],
//         supportedLocales: const [
//           Locale('en', 'US'),
//           Locale('hi', 'IN'),
//         ],
//         home: const StartUpView(),
//         title: 'Security App',
//         theme: AppTheme.theme,
//       ),
//     );
//
//   }
// }
//
//
// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }
// //
// // class _MyAppState extends State<MyApp> {
// //   var image1 = Regula.MatchFacesImage();
// //   var image2 = Regula.MatchFacesImage();
// //   var img1 = Image.asset('assets/images/portrait.png');
// //   var img2 = Image.asset('assets/images/portrait.png');
// //   String _similarity = "nil";
// //   String _liveness = "nil";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initPlatformState();
// //     const EventChannel('flutter_face_api/event/video_encoder_completion')
// //         eceiveBroadcastStream()
// //         .listen((event) {
// //       var response = jsonDecode(event);
// //       String transactionId = response["transactionId"];
// //       bool success = response["success"];
// //       if (kDebugMode) {
// //         print("video_encoder_completion:");
// //         print("    success: $success");
// //         print("    transactionId: $transactionId");
// //       }
// //     });
// //   }
// //
// //   Future<void> initPlatformState() async {
// //     Regula.FaceSDK.init().then((json) {
// //       var response = jsonDecode(json);
// //       if (!response["success"]) {
// //         if (kDebugMode) {
// //           print("Init failed: $json");
// //         }
// //       }
// //     });
// //   }
// //
// //   showAlertDialog(BuildContext context, bool first) => showDialog(
// //       context: context,
// //       builder: (BuildContext context) =>
// //           AlertDialog(title: const Text("Select option"), actions: [
// //             // ignore: deprecated_member_use
// //             TextButton(
// //                 child: const Text("Use gallery"),
// //                 onPressed: () {
// //                   Navigator.of(context, rootNavigator: true).pop();
// //                   ImagePicker()
// //                       .pickImage(source: ImageSource.gallery)
// //                       .then((value) => {
// //                     setImage(
// //                         first,
// //                         io.File(value!.path)eadAsBytesSync(),
// //                         Regula.ImageType.PRINTED)
// //                   });
// //                 }),
// //             // ignore: deprecated_member_use
// //             TextButton(
// //                 child: const Text("Use camera"),
// //                 onPressed: () {
// //                   Regula.FaceSDK.presentFaceCaptureActivity().then((result) =>
// //                       setImage(
// //                           first,
// //                           base64Decode(Regula.FaceCaptureResponse.fromJson(
// //                               json.decode(result))!
// //                               .image!
// //                               .bitmap!
// //                               eplaceAll("\n", "")),
// //                           Regula.ImageType.LIVE));
// //                   Navigator.pop(context);
// //                 })
// //           ]));
// //
// //   setImage(bool first, Uint8List? imageFile, int type) {
// //     if (imageFile == null) return;
// //     setState(() => _similarity = "nil");
// //     if (first) {
// //       image1.bitmap = base64Encode(imageFile);
// //       image1.imageType = type;
// //       setState(() {
// //         img1 = Image.memory(imageFile);
// //         _liveness = "nil";
// //       });
// //     } else {
// //       image2.bitmap = base64Encode(imageFile);
// //       image2.imageType = type;
// //       setState(() => img2 = Image.memory(imageFile));
// //     }
// //   }
// //
// //   clearResults() {
// //     setState(() {
// //       img1 = Image.asset('assets/images/portrait.png');
// //       img2 = Image.asset('assets/images/portrait.png');
// //       _similarity = "nil";
// //       _liveness = "nil";
// //     });
// //     image1 = Regula.MatchFacesImage();
// //     image2 = Regula.MatchFacesImage();
// //   }
// //
// //   matchFaces() {
// //     if (image1.bitmap == null ||
// //         image1.bitmap == "" ||
// //         image2.bitmap == null ||
// //         image2.bitmap == "") return;
// //     setState(() => _similarity = "Processing...");
// //     var request = Regula.MatchFacesRequest();
// //     request.images = [image1, image2];
// //     Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
// //       var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
// //       Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
// //           jsonEncode(response!esults), 0.75)
// //           .then((str) {
// //         var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
// //             json.decode(str));
// //         if (kDebugMode) {
// //           print(split?.matchedFaces.length.toString());
// //         }
// //         setState(() => _similarity = split!.matchedFaces.isNotEmpty
// //             ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}%")
// //             : "error");
// //       });
// //     });
// //   }
// //
// //   // matchFaces() {
// //   //   if (image1.bitmap == null ||
// //   //       image1.bitmap == "" ||
// //   //       image2.bitmap == null ||
// //   //       image2.bitmap == "") {
// //   //     return;
// //   //   }
// //   //
// //   //   setState(() => _similarity = "Processing...");
// //   //
// //   //   var request = Regula.MatchFacesRequest();
// //   //   request.images = [image1, image2];
// //   //
// //   //   Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
// //   //     var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
// //   //
// //   //     if (response != null && responseesults.isNotEmpty) {
// //   //       List<dynamic> allFaces = responseesults;
// //   //
// //   //       print('in');
// //   //
// //   //       // Compare all possible face pairs
// //   //       List<double> similarities = [];
// //   //       for (int i = 0; i < allFaces.length - 1; i++) {
// //   //         for (int j = i + 1; j < allFaces.length; j++) {
// //   //           var pairRequest = Regula.MatchFacesRequest();
// //   //           pairRequest.images = [allFaces[i], allFaces[j]];
// //   //
// //   //           Regula.FaceSDK.matchFaces(jsonEncode(pairRequest)).then((pairValue) {
// //   //             var pairResponse = Regula.MatchFacesResponse.fromJson(json.decode(pairValue));
// //   //             if (pairResponse != null && pairResponseesults.isNotEmpty) {
// //   //               // Assuming a single result for simplicity
// //   //               double similarity = pairResponseesults[0]?.similarity ?? 0.0;
// //   //               similarities.add(similarity);
// //   //             }
// //   //
// //   //             // Calculate the average similarity for all pairs
// //   //             if (similarities.isNotEmpty) {
// //   //               double averageSimilarity = similaritieseduce((a, b) => a + b) / similarities.length;
// //   //               setState(() {
// //   //                 _similarity = "${(averageSimilarity * 100).toStringAsFixed(2)}%";
// //   //               });
// //   //             } else {
// //   //               setState(() => _similarity = "error");
// //   //             }
// //   //           });
// //   //         }
// //   //       }
// //   //     } else {
// //   //       setState(() => _similarity = "error");
// //   //     }
// //   //   });
// //   // }
// //
// //
// //   liveness() => Regula.FaceSDK.startLiveness().then((value) {
// //     var result = Regula.LivenessResponse.fromJson(json.decode(value));
// //     setImage(true, base64Decode(result!.bitmap!eplaceAll("\n", "")),
// //         Regula.ImageType.LIVE);
// //     setState(() => _liveness =
// //     result.liveness == Regula.LivenessStatus.PASSED
// //         ? "passed"
// //         : "unknown");
// //   });
// //
// //   Widget createButton(String text, VoidCallback onPress) => SizedBox(
// //     // ignore: deprecated_member_use
// //     width: 250,
// //     // ignore: deprecated_member_use
// //     child: TextButton(
// //         style: ButtonStyle(
// //           foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
// //           backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
// //         ),
// //         onPressed: onPress,
// //         child: Text(text)),
// //   );
// //
// //   Widget createImage(image, VoidCallback onPress) => Material(
// //       child: InkWell(
// //         onTap: onPress,
// //         child: ClipRRect(
// //           borderRadius: BorderRadius.circular(20.0),
// //           child: Image(height: 150, width: 150, image: image),
// //         ),
// //       ));
// //
// //   @override
// //   Widget build(BuildContext context) => Scaffold(
// //     body: Container(
// //         margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
// //         width: double.infinity,
// //         child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[
// //               createImage(img1.image, () => showAlertDialog(context, true)),
// //               createImage(
// //                   img2.image, () => showAlertDialog(context, false)),
// //               Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 15)),
// //               createButton("Match", () => matchFaces()),
// //               createButton("Liveness", () => liveness()),
// //               createButton("Clear", () => clearResults()),
// //               Container(
// //                   margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Text("Similarity: $_similarity",
// //                           style: const TextStyle(fontSize: 18)),
// //                       Container(
// //                           margin: const EdgeInsets.fromLTRB(20, 0, 0, 0)),
// //                       Text("Liveness: $_liveness",
// //                           style: const TextStyle(fontSize: 18))
// //                     ],
// //                   ))
// //             ])),
// //   );
// // }