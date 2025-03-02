import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/database_provider.dart';
import 'package:frontend/services/database_service.dart';
import 'package:frontend/widgets/home.dart';
import 'package:frontend/widgets/welcome.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    ProviderScope(
      child: PetDaycareApp(),
    ),
  );
}

class PetDaycareApp extends StatelessWidget {
  const PetDaycareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pet Daycare Search App",
        theme: ThemeData(
            primarySwatch: Colors.orange,
            // primaryColor: Colors.orange,
            // buttonTheme: ButtonThemeData(
            //   buttonColor: Colors.orangeAccent,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            // ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
              primary: Color.fromARGB(255, 255, 168, 88),
              secondary: Color.fromARGB(255, 252, 232, 169),
              tertiary: Color.fromARGB(255, 253, 247, 242),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Color.fromARGB(255, 255, 168, 88),
                foregroundColor: Color.fromARGB(255, 253, 247, 242),
                minimumSize: Size(50, 50),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Color.fromARGB(255, 255, 168, 88),
                foregroundColor: Color.fromARGB(255, 253, 247, 242),
                minimumSize: Size(50, 50),
              ),
            )),
        // home: WelcomeWidget(),
        home: Consumer(
          builder: (context, ref, child) {
            var provider = ref.watch(getTokenProvider);

            if (provider.hasError && !provider.isLoading) {
              return WelcomeWidget();
            } else if (provider.hasValue && !provider.isLoading) {
              return HomeWidget();
            } else {
              return Container(
                color: Colors.white,
              );
            }
          },
        ));
  }
}
