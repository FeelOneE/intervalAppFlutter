import 'package:interval/entity/IntervalType.dart';

class TimerInfoDetail{
  int costTime; // 소요 시간(ms)
  IntervalType type; // 운동 상태

  TimerInfoDetail({ required this.costTime, required this.type});
}