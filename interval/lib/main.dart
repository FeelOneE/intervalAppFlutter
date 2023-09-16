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

  // 초기 타이머 세팅
  var initMilliSec = 2131*1000;
  var runMilliSec = 0;

  // 출력할 분, 초 변수
  var min = 0;
  var sec = 0;

  var timeSetList = [];
  var timeSet_1 = {'state': 'ready', 'time': 500*1000};
  var timeSet_2 = {'state': 'run', 'time': 5*1000};
  var timeSet_3 = {'state': 'rest', 'time': 2*1000};

  var playIcon = Icons.play_circle;
  var stopwatch = Stopwatch();

  // 밀리초 분,초 변환
  void convertMilltoMinAndSec(){
    var cvtSec = 0.0;
    if (runMilliSec == 0){
      cvtSec = initMilliSec / 1000;
    }else{
      cvtSec = (runMilliSec / 1000).ceilToDouble();
    }
    setState(() {
      min = cvtSec ~/ 60;
      sec = (cvtSec % 60).toInt();
    });
  }

  String convertMillTime(var millsec){
    var cvtSec = (millsec / 1000).ceilToDouble();
    var min = cvtSec ~/ 60;
    var sec = (cvtSec % 60).toInt();

    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }
  // 타이머 시작
  var duration = const Duration(seconds: 1);
  Timer? runTimer;
  // 타이머 실행 상태
  String runState = "init";

  void runStopwatch(){
    runState = "run";
    if(stopwatch.isRunning){ // 타이머 실행중 -> 일시정지
      stopwatch.stop();
      playIcon = Icons.play_circle;
    }else{ // 타이머 일시정지 중 -> 다시 실행
      stopwatch.start();
      playIcon = Icons.pause_circle;
    }
    setState(() {
      runTimer= Timer.periodic(duration, (Timer t) {
        runMilliSec = initMilliSec - stopwatch.elapsedMilliseconds;
        convertMilltoMinAndSec();
        // 시간 만료
        if(runMilliSec <= 0){
          runTimer!.cancel();
          stopwatch = Stopwatch();
          runState = "finish";
        }
      });
    });
  }

  // 리셋 버튼
  void resetTimer(){
    setState(() {
      if (runTimer != null) {
        runTimer!.cancel();
      }
      playIcon = Icons.play_circle;
      stopwatch = Stopwatch();
      runMilliSec = 0;
      convertMilltoMinAndSec();
      runState = "init";
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    convertMilltoMinAndSec();// 시작시 초기 시간 세팅
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
          title: Text(
            'Interval Traing',
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
                              //Text("${runState}", style: TextStyle(fontSize: 30),),
                              Text("${min.toString().padLeft(2, '0')}:"
                                  "${sec.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 105
                              ),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (runState == "finish") ?
                                  IconButton(
                                  onPressed: resetTimer,
                                    icon: Icon(Icons.stop_circle),
                                    iconSize: 80,
                                  )
                                  :IconButton(
                                          onPressed: runStopwatch,
                                          icon: Icon(playIcon),
                                          iconSize: 80,
                                  ),
                                  IconButton(
                                    onPressed: resetTimer,
                                    icon: Icon(Icons.replay),
                                    iconSize: 80,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //height: 200,
                        //color: Colors.orange,
                        child: Column(
                          children: [
                            Text(convertMillTime(timeSet_1['time']), style: TextStyle(fontSize: 30),),
                            Text(convertMillTime(timeSet_2['time']), style: TextStyle(fontSize: 30),),
                            Text(convertMillTime(timeSet_3['time']), style: TextStyle(fontSize: 30),),
                          ],
                        ),
                      ),
                    ),
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
