import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interval/entity/IntervalType.dart';
import 'package:interval/entity/TimerInfo.dart';
import 'dart:async';
import 'package:get/get.dart';

import 'package:interval/entity/TimerInfoDetail.dart';
import 'package:interval/widget/IntervalDetailCard.dart';


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

  // 글로벌 리스트 인덱스
  int Listidx = 0;

  // 인터벌 정보 카드 리스트 변수
  List<IntervalDetailCard> intervalDetailCardList = [];

  IconData playIcon = Icons.play_circle;
  Stopwatch stopwatch = Stopwatch();

  // 밀리초 분,초 변환 setMainTimerInfo
  void setMainTimerInfo(TimerInfo timerInfo, int? idx){
    var cvtSec = 0.0;
    if (runMilliSec == 0){
      int costTime = 0;
      if(idx != null){
        costTime = timerInfo.timerList[idx].costTime;
      }else{
        costTime = timerInfo.totalTime;
      }
      cvtSec = costTime / 1000;
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
        runMilliSec = timerInfo.timerList[Listidx].costTime - stopwatch.elapsedMilliseconds;
        setMainTimerInfo(timerInfo, Listidx);

        // 다음 운동 시작
        if(runMilliSec <= 0){
          stopwatch = Stopwatch();
          stopwatch.start();
          getIntervalDetailCard(timerInfo);
          Listidx ++;
        }
        // 모든 운동 종료
        if(runMilliSec <= 0 && Listidx == timerInfo.timerList.length){
          runTimer!.cancel();
          stopwatch = Stopwatch();
          runState = "finish";
          Listidx = 0;
        }
      });
    });
  }

  // 카드 정보 출력
  List<Widget> getIntervalDetailCard(TimerInfo timerInfo){
    intervalDetailCardList = [];
    for (var index = 0; index < timerInfo.timerList.length; index++){
      Color backgroundColor = Colors.white;
      if(index == Listidx){
        backgroundColor = Colors.redAccent;
      }
      IntervalDetailCard card = IntervalDetailCard(
          info: timerInfo.timerList[index],
          convertMillToMinAndSec: convertMillToMinAndSec,
          backgroundColor: backgroundColor,
      );
      intervalDetailCardList.add(card);
    }
    return intervalDetailCardList;
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
      setMainTimerInfo(timerInfo, null);
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
    TimerInfoDetail info4 = TimerInfoDetail(
        costTime: 6*1000,
        type: IntervalType.rest
    );
    TimerInfoDetail info5 = TimerInfoDetail(
        costTime: 6*1000,
        type: IntervalType.rest
    );
    TimerInfoDetail info6 = TimerInfoDetail(
        costTime: 6*1000,
        type: IntervalType.rest
    );
    timerInfoDetailList.add(info1);
    timerInfoDetailList.add(info2);
    timerInfoDetailList.add(info3);
    timerInfoDetailList.add(info4);
    timerInfoDetailList.add(info5);
    timerInfoDetailList.add(info6);
    TimerInfo timerInfo = TimerInfo(
        isDefault: true,
        timerList: timerInfoDetailList,
        totalTime: 0 // 총 시간 초기화
    );
    timerInfo.calcTotalTime(); // 총 시간 계산

    setMainTimerInfo(timerInfo, null);// 시작시 초기 시간 세팅

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: Column(
                    children: [
                      Container(
                        height: 350,
                        //color: Colors.redAccent,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 50,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.grey
                                            ),
                                            child: Center(
                                              child: Text("인터벌 제목 1"
                                                  ,style: TextStyle(fontSize: 30)
                                              ),
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 50,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white
                                            ),
                                            child: Center(
                                              child: Text("인터벌 제목 2"
                                                  ,style: TextStyle(fontSize: 30)
                                              ),
                                            )
                                        ),
                                      ),
                              ]
                            ),
                                ),
                                //Text("${runState}", style: TextStyle(fontSize: 30),),
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
                      Container(
                      child: Column(
                      children: getIntervalDetailCard(timerInfo),
                      ),
                    ),
                  ])
                ),
              /*Container(
                  child: Container(
                    color: Colors.blueAccent
                )
              )*/
            ],
          ),
        ),
      ),
    );
  }
}



