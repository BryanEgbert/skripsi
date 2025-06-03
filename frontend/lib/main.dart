import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/pet_daycare_home_page.dart';
import 'package:frontend/pages/vet_main_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/database_provider.dart';
import 'package:frontend/provider/theme_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/services/firebase_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();
  await FirebaseService().initNotifications();
  await FirebaseService().initRemoteConfig();

  runApp(
    ProviderScope(
      child: PetDaycareApp(),
    ),
  );
}

class PetDaycareApp extends ConsumerStatefulWidget {
  const PetDaycareApp({super.key});

  @override
  ConsumerState<PetDaycareApp> createState() => _PetDaycareAppState();
}

class _PetDaycareAppState extends ConsumerState<PetDaycareApp> {
  @override
  void initState() {
    super.initState();
    log("init Home");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("update token");
      ref.read(userStateProvider.notifier).updateDeviceToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeStateProvider);
    final tokenProvider = ref.watch(getTokenProvider);
    Widget home = Container(color: Colors.white);

    tokenProvider.when(
      data: (user) {
        log("[MAIN PAGE] setting home page");
        if (user.roleId == 1) {
          home = HomeWidget();
        } else if (user.roleId == 2) {
          home = PetDaycareHomePage();
        } else if (user.roleId == 3) {
          home = VetMainPage();
        } else {
          home = WelcomeWidget();
        }
      },
      loading: () {
        // home = Container(color: Colors.white);
      },
      error: (_, __) {
        home = WelcomeWidget();
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pet Daycare Search App",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          // primary: Colors.orange[900],
          // secondary: Color.fromARGB(255, 252, 232, 169),
          // tertiary: Color.fromARGB(255, 253, 247, 242),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
          color: Colors.orange,
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Constants.primaryTextColor,
            foregroundColor: Color.fromARGB(255, 253, 247, 242),
            minimumSize: Size(50, 50),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.orange,
            foregroundColor: Color.fromARGB(255, 253, 247, 242),
            minimumSize: Size(50, 50),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
          color: Colors.orange,
        )),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.orange,
          onSurface: Colors.white70,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.orange,
            foregroundColor: Color.fromARGB(255, 253, 247, 242),
            minimumSize: Size(50, 50),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.orange,
            foregroundColor: Color.fromARGB(255, 253, 247, 242),
            minimumSize: Size(50, 50),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      themeMode: (themeMode.value == false) ? ThemeMode.light : ThemeMode.dark,
      home: home,
    );
  }
}
