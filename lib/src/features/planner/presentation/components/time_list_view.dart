import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/src/features/planner/presentation/components/activity_card.dart';
import 'package:time_planner/src/features/planner/presentation/planner_view_model.dart';

class TimeListView extends StatelessWidget {
  const TimeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlannerViewModel>();
    final groupedEvents = viewModel.groupedActivities;
    final timeKeys = groupedEvents.keys.toList()..sort();

    if (groupedEvents.isEmpty) {
      return const Center(
        child: Text('Nenhuma atividade para este dia.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: timeKeys.length,
      itemBuilder: (context, index) {
        final time = timeKeys[index];
        final activitiesInGroup = groupedEvents[time]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 4.0),
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            ...activitiesInGroup
                .map((activity) => ActivityCard(activity: activity))
                .toList(),
          ],
        );
      },
    );
  }
}