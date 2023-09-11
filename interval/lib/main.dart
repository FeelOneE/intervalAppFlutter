import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main(){
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // TRY THIS: Change to "Brightness.light"
          //           and see that all colors change
          //           to better contrast a light background.
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // TRY THIS: Change one of the GoogleFonts
          //           to "lato", "poppins", or "lora".
          //           The title uses "titleLarge"
          //           and the middle text uses "bodyMedium".
          titleLarge: GoogleFonts.pacifico(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.jost(),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Interval Traing',
          style: TextStyle(
              color: Colors.black
          ),),
          backgroundColor: Color(0xFFE9EBEC),
        ),
        body: Column(
          children: [
            Container(
                child:
                Container(
                  height: 400,
                  color: Colors.blue,
                ),
            ),
            Expanded(
              child:
              Container(
                height: 100,
                color: Colors.red,
              )
            )
          ],
        ),
      ),
    );
  }
}
