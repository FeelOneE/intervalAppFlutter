import 'package:flutter/material.dart';
import 'package:interval/entity/IntervalType.dart';
import 'package:interval/entity/TimerInfoDetail.dart';

class IntervalDetailCard extends StatefulWidget {
  const IntervalDetailCard({
    super.key,
    required this.info,
    required this.convertMillToMinAndSec,
    required this.backgroundColor
  });

  final TimerInfoDetail info;
  final Function convertMillToMinAndSec;
  final Color backgroundColor;

  @override
  State<IntervalDetailCard> createState() => _IntervalDetailCardState();
}

class _IntervalDetailCardState extends State<IntervalDetailCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.backgroundColor
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      widget.info.type == IntervalType.run ?
                      Icons.directions_run
                          :
                      widget.info.type == IntervalType.rest ?
                      Icons.directions_walk
                          :
                      Icons.self_improvement
                      ,size: 50,
                    ),
                    Text(widget.convertMillToMinAndSec(widget.info.costTime)
                      ,style: TextStyle(fontSize: 30)
                    ),

                  ]
              )
          ),
        ),
        SizedBox(height: 30)
      ],
    );
  }
}