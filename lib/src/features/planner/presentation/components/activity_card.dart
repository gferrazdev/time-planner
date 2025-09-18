import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/features/planner/presentation/components/edit_activity_modal.dart';
import 'package:time_planner/src/features/planner/presentation/planner_view_model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(activity.startTime);
    final endTime = timeFormat.format(activity.endTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.blueAccent, size: 28),
                    const SizedBox(height: 8),
                    Text('$startTime\n$endTime', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: VerticalDivider(thickness: 1, width: 1, color: Colors.black12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(activity.description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Duração: ${activity.endTime.difference(activity.startTime).inMinutes} minutos', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black54),
                onSelected: (value) {
                  final viewModel = context.read<PlannerViewModel>();
                  if (value == 'edit') {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => ChangeNotifierProvider.value(value: viewModel, child: EditActivityModal(activity: activity)),
                      isScrollControlled: true,
                    );
                  } else if (value == 'delete') {
                    viewModel.deleteActivity(activity.id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text('Editar')]),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text('Excluir', style: TextStyle(color: Colors.red))]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}