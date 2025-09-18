import 'package:flutter/material.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';

class EventLayoutProperties {
  final Activity activity;
  final double top;
  final double height;
  final double left;
  final double width;

  EventLayoutProperties({
    required this.activity,
    required this.top,
    required this.height,
    required this.left,
    required this.width,
  });
}

class TimeGrid extends StatefulWidget {
  final List<Activity> activities;
  final Function(Activity) onEventTap;
  final Function(Activity) onEventDelete;
  final double hourHeight;
  final double rightPadding;
  final double leftPadding;
  final DateTime selectedDay;

  const TimeGrid({
    super.key,
    required this.activities,
    required this.onEventTap,
    required this.onEventDelete,
    this.hourHeight = 100.0,
    this.rightPadding = 10.0,
    this.leftPadding = 65.0,
    required this.selectedDay,
  });

  @override
  State<TimeGrid> createState() => _TimeGridState();
}

class _TimeGridState extends State<TimeGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToRelevantTime());
  }

  @override
  void didUpdateWidget(TimeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDay != widget.selectedDay ||
        oldWidget.activities.length != widget.activities.length) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollToRelevantTime());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return now.year == day.year && now.month == day.month && now.day == day.day;
  }

  void _scrollToRelevantTime() {
    if (!_scrollController.hasClients) return;

    DateTime scrollTargetTime;
    final now = DateTime.now();
    final isSelectedDayToday = _isToday(widget.selectedDay);

    if (widget.activities.isNotEmpty) {
      widget.activities.sort((a, b) => a.startTime.compareTo(b.startTime));
      if (isSelectedDayToday) {
        final pastOrCurrentActivities = widget.activities.where((act) => act.startTime.isBefore(now)).toList();
        scrollTargetTime = pastOrCurrentActivities.isNotEmpty
            ? pastOrCurrentActivities.last.startTime
            : widget.activities.first.startTime;
      } else {
        scrollTargetTime = widget.activities.first.startTime;
      }
    } else {
      scrollTargetTime = widget.selectedDay.copyWith(
        hour: now.hour,
        minute: now.minute,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
    }

    final finalScrollTime = scrollTargetTime.hour > 0
        ? scrollTargetTime.subtract(const Duration(hours: 1))
        : scrollTargetTime.copyWith(hour: 0, minute: 0);

    final offset = _calculateTopOffset(finalScrollTime);
    
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  List<EventLayoutProperties> _calculateLayout(
      List<Activity> activities, double totalWidth) {
    if (activities.isEmpty) return [];
    List<EventLayoutProperties> layoutProps = [];
    activities.sort((a, b) => a.startTime.compareTo(b.startTime));
    
    List<List<Activity>> collisionGroups = [];
    if (activities.isNotEmpty) {
      for (var event in activities) {
        bool placed = false;
        for (var group in collisionGroups) {
          if (group.isNotEmpty && !event.startTime.isBefore(group.last.endTime)) {
            group.add(event);
            placed = true;
            break;
          }
        }
        if (!placed) {
          collisionGroups.add([event]);
        }
      }
    }

    for (int i = 0; i < collisionGroups.length; i++) {
      final group = collisionGroups[i];
      for (final activity in group) {
        layoutProps.add(EventLayoutProperties(
            activity: activity,
            top: _calculateTopOffset(activity.startTime),
            height: _calculateHeight(activity.startTime, activity.endTime),
            left: (totalWidth / collisionGroups.length) * i,
            width: (totalWidth / collisionGroups.length),
        ));
      }
    }
    return layoutProps;
  }

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width -
        widget.leftPadding -
        widget.rightPadding;
    final layoutProperties = _calculateLayout(widget.activities, availableWidth);

    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: 24 * widget.hourHeight,
        child: Stack(
          children: [
            _buildTimeLines(),
            if (widget.activities.isEmpty)
              _buildEmptyDayMessage(),
            ...layoutProperties.map((props) => _buildActivityEvent(props)).toList(),
          ],
        ),
      ),
    );
  }

 Widget _buildEmptyDayMessage() {
    DateTime messageTime;
    String messageText;
    final now = DateTime.now();

    if (_isToday(widget.selectedDay)) {
      messageTime = now;
      messageText = 'Nenhuma atividade para hoje.';
    } else {
      messageTime = widget.selectedDay.copyWith(
        hour: now.hour,
        minute: now.minute,
      );
      messageText = 'Nenhuma atividade para este dia.';
    }

    return Positioned(
      top: _calculateTopOffset(messageTime),
      left: widget.leftPadding,
      right: widget.rightPadding,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            messageText,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLines() {
    return Column(
      children: List.generate(24, (index) {
        return SizedBox(
          height: widget.hourHeight,
          child: Row(
            children: [
              SizedBox(
                width: widget.leftPadding - 5,
                child: Center(
                  child: Text(
                    '${index.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey.shade200, width: 1)),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActivityEvent(EventLayoutProperties props) {
    return Positioned(
      top: props.top,
      left: widget.leftPadding + props.left,
      width: props.width > 2 ? props.width - 2 : props.width,
      height: props.height,
      child: GestureDetector(
        onTap: () => widget.onEventTap(props.activity),
        onLongPress: () => widget.onEventDelete(props.activity),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            props.activity.description,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
        ),
      ),
    );
  }

  double _calculateTopOffset(DateTime time) {
    return (time.hour * widget.hourHeight) +
        (time.minute / 60 * widget.hourHeight);
  }

  double _calculateHeight(DateTime start, DateTime end) {
    final durationInMinutes = end.difference(start).inMinutes;
    final calculatedHeight = durationInMinutes / 60 * widget.hourHeight;
    return calculatedHeight < 20 ? 20 : calculatedHeight;
  }
}