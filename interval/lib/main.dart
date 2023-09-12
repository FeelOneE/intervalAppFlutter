import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';


void main(){
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  var min = 0;
  var sec = 10;
  bool runState = false;
  void startRun(){
    setState(() {
      if(runState){
        runState = false;
      }else{
        runState = true;
      }
    });

    const duration = Duration(seconds: 1);
    Timer? timer;
    timer = Timer.periodic(duration, (Timer t) {
        setState(() {
          if (!runState) {
            timer?.cancel();
          }else if(min > 0 || sec > 0) {
            if (sec == 0) {
              sec = 60;
              min = min - 1;
            }
            sec = sec - 1;
          }else{
            timer?.cancel();
          }
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          background: Color(0xFFE9EBEC),
          seedColor: Colors.purple,
          //brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
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
          //backgroundColor: Color(0xFFE9EBEC),
        ),
        body: Column(
          children: [
            Container(
                height: 550,
                child: Column(
                  children: [
                    Container(
                      height: 350,
                      //color: Colors.redAccent,
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Center(
                          child: Column(
                            children: [
                              Text("${runState}", style: TextStyle(fontSize: 30),),
                              Text("${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 105
                              ),),
                              IconButton(
                                  onPressed: startRun,
                                  icon: Icon(Icons.play_circle),
                                  iconSize: 80,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      color: Colors.orange,
                    )
                  ],
                )
            ),
            Expanded(
                child: Container(
                  color: Colors.blueAccent
              )
            )
          ],
        ),
      ),
    );
  }
}
