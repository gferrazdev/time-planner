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
        .addPostFrameCallback((_) => _maybeScrollToCurrentTime());
  }

  @override
  void didUpdateWidget(TimeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDay != widget.selectedDay) {
       WidgetsBinding.instance
          .addPostFrameCallback((_) => _maybeScrollToCurrentTime());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeScrollToCurrentTime() {
    if (!_scrollController.hasClients) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(
        widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day);

    if (today == selectedDay) {
      final oneHourBefore = now.subtract(const Duration(hours: 1));
      final scrollTime = oneHourBefore.hour < 0
          ? now.copyWith(hour: 0, minute: 0)
          : oneHourBefore;
      final offset = _calculateTopOffset(scrollTime);
      
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  List<EventLayoutProperties> _calculateLayout(
      List<Activity> activities, double totalWidth) {
    if (activities.isEmpty) return [];
    List<EventLayoutProperties> layoutProps = [];
    activities.sort((a, b) => a.startTime.compareTo(b.startTime));

    List<List<Activity>> collisionGroups = [];
    if(activities.isNotEmpty) {
      collisionGroups.add([activities.first]);
      for(int i = 1; i < activities.length; i++) {
        bool placed = false;
        for(final group in collisionGroups) {
          if(!activities[i].startTime.isBefore(group.last.endTime)) {
            group.add(activities[i]);
            placed = true;
            break;
          }
        }
        if(!placed) {
          collisionGroups.add([activities[i]]);
        }
      }
    }

    for (final group in collisionGroups) {
      for (int i = 0; i < group.length; i++) {
        final activity = group[i];
        layoutProps.add(EventLayoutProperties(
            activity: activity,
            top: _calculateTopOffset(activity.startTime),
            height: _calculateHeight(activity.startTime, activity.endTime),
            left: (totalWidth / collisionGroups.length) * collisionGroups.indexOf(group),
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

    if (widget.activities.isEmpty) {
      return const Center(child: Text('Nenhuma atividade para este dia.'));
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: 24 * widget.hourHeight,
        child: Stack(
          children: [
            _buildTimeLines(),
            ...layoutProperties.map((props) => _buildActivityEvent(props)).toList(),
          ],
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