import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interval/entity/IntervalType.dart';
import 'package:interval/entity/TimerInfo.dart';
import 'dart:async';

import 'package:interval/entity/TimerInfoDetail.dart';


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
  int initMilliSec = 0;
  int runMilliSec = 0;

  // 출력할 분, 초 변수
  int min = 0;
  int sec = 0;

  IconData playIcon = Icons.play_circle;
  Stopwatch stopwatch = Stopwatch();

  // 밀리초 분,초 변환 setMainTimerInfo
  void setMainTimerInfo(TimerInfo timerInfo){
    var cvtSec = 0.0;
    if (runMilliSec == 0){
      cvtSec = timerInfo.totalTime / 1000;
    }else{
      cvtSec = (runMilliSec / 1000).ceilToDouble();
    }
    setState(() {
      min = cvtSec ~/ 60;
      sec = (cvtSec % 60).toInt();
    });
  }

  // 밀리초 {min:sec} 형태로 출력 convertMillToMinAndSec
  String convertMillToMinAndSec(var millsec){
    var cvtSec = (millsec / 1000).ceilToDouble();
    var min = cvtSec ~/ 60;
    var sec = (cvtSec % 60).toInt();

    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }
  
  // 타이머 시작
  Duration duration = const Duration(seconds: 1);
  Timer? runTimer;
  String runState = "init"; // 타이머 실행 상태

  void runStopwatch(TimerInfo timerInfo){
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
        runMilliSec = timerInfo.totalTime - stopwatch.elapsedMilliseconds;
        setMainTimerInfo(timerInfo);
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
  void resetTimer(TimerInfo timerInfo){
    setState(() {
      if (runTimer != null) {
        runTimer!.cancel();
      }
      playIcon = Icons.play_circle;
      stopwatch = Stopwatch();
      runMilliSec = 0;
      setMainTimerInfo(timerInfo);
      runState = "init";
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

    List<TimerInfoDetail> timerInfoDetailList = [];
    TimerInfoDetail info1 = TimerInfoDetail(
        costTime: 5*1000,
        type: IntervalType.prepare
    );
    TimerInfoDetail info2 = TimerInfoDetail(
        costTime: 3*1000,
        type: IntervalType.run
    );
    TimerInfoDetail info3 = TimerInfoDetail(
        costTime: 6*1000,
        type: IntervalType.rest
    );
    timerInfoDetailList.add(info1);
    timerInfoDetailList.add(info2);
    timerInfoDetailList.add(info3);
    TimerInfo timerInfo = TimerInfo(
        isDefault: true,
        timerList: timerInfoDetailList,
        totalTime: 0 // 총 시간 초기화
    );
    timerInfo.calcTotalTime(); // 총 시간 계산

    setMainTimerInfo(timerInfo);// 시작시 초기 시간 세팅

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
                              Text("${runState}", style: TextStyle(fontSize: 30),),
                              Text("${min.toString().padLeft(2, '0')}:"
                                  "${sec.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                fontSize: 105
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (runState == "finish") ?
                                  IconButton( // 종료 아이콘
                                    onPressed: () {
                                      resetTimer(timerInfo);
                                    },
                                    icon: Icon(Icons.stop_circle),
                                    iconSize: 80,
                                    )
                                  :IconButton( // 시작 아이콘
                                    onPressed: () {
                                      runStopwatch(timerInfo);
                                    },
                                    icon: Icon(playIcon),
                                    iconSize: 80,
                                    ),
                                  IconButton( // 리셋 버튼
                                    onPressed: () {
                                      resetTimer(timerInfo);
                                    },
                                    icon: Icon(Icons.replay),
                                    iconSize: 80,
                                    )
                                  ]),
                                ]),
                              ),
                            ),
                          ),
                    Expanded(
                    child: Container(
                    //height: 200,
                    //color: Colors.orange,
                    child: Column(
                    children: [
                    for (TimerInfoDetail info in timerInfo.timerList) ...[
                      Text(convertMillToMinAndSec(info.costTime)
                            ,style: TextStyle(fontSize: 30)
                          ),
                        ],
                      ]),
                    ),
                  ),
                ])
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
