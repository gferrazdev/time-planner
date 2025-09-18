import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_planner/src/core/data/local/app_database.dart';
import 'package:time_planner/src/core/di/injection.dart';
import 'package:time_planner/src/features/planner/presentation/components/add_activity_modal.dart';
import 'package:time_planner/src/features/planner/presentation/components/edit_activity_modal.dart';
import 'package:time_planner/src/features/planner/presentation/components/time_grid.dart';
import 'package:time_planner/src/features/planner/presentation/components/time_list_view.dart';
import 'package:time_planner/src/features/planner/presentation/planner_view_model.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<PlannerViewModel>(),
      child: const _PlannerContent(),
    );
  }
}

class _PlannerContent extends StatefulWidget {
  const _PlannerContent();

  @override
  State<_PlannerContent> createState() => _PlannerContentState();
}

class _PlannerContentState extends State<_PlannerContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlannerViewModel>(context, listen: false)
          .onDaySelected(DateTime.now(), DateTime.now());
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir a atividade "${activity.description}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
              onPressed: () {
                context.read<PlannerViewModel>().deleteActivity(activity.id);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlannerViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Planner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Limpar todas as atividades',
            onPressed: () {
              sl<AppDatabase>().activitiesDao.clearActivities();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Atividades limpas!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: viewModel.focusedDay,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) => isSameDay(viewModel.selectedDay, day),
            onDaySelected: viewModel.onDaySelected,
            eventLoader: viewModel.getEventsForDay,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
            ),
            headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SegmentedButton<PlannerViewType>(
              segments: const [
                ButtonSegment(value: PlannerViewType.grid, label: Text('Grade'), icon: Icon(Icons.grid_view)),
                ButtonSegment(value: PlannerViewType.list, label: Text('Lista'), icon: Icon(Icons.view_list)),
              ],
              selected: {viewModel.viewType},
              onSelectionChanged: (newSelection) {
                viewModel.setViewType(newSelection.first);
              },
            ),
          ),
          Expanded(
            child: viewModel.viewType == PlannerViewType.grid
                ? TimeGrid(
                    selectedDay: viewModel.selectedDay ?? DateTime.now(),
                    activities: viewModel.activitiesForSelectedDay,
                    onEventTap: (activity) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ChangeNotifierProvider.value(
                          value: viewModel,
                          child: EditActivityModal(activity: activity),
                        ),
                        isScrollControlled: true,
                      );
                    },
                    onEventDelete: (activity) {
                      _showDeleteConfirmationDialog(context, activity);
                    },
                  )
                : const TimeListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (modalContext) => ChangeNotifierProvider.value(
              value: context.read<PlannerViewModel>(),
              child: const AddActivityModal(),
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}