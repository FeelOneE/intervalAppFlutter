
import 'package:interval/entity/TimerInfoDetail.dart';

class TimerInfo{
  int totalTime; // 총 소요 시간(ms)
  bool isDefault; // 기본 타이머 표시 여부
  List<TimerInfoDetail> timerList; // 타이머 구성 리스트

  TimerInfo({required this.isDefault, required this.timerList, required this.totalTime});

  void calcTotalTime(){
    if(timerList.isNotEmpty){
      for(TimerInfoDetail info in timerList){
        totalTime += info.costTime;
      }
    }
  }
}