import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/src/core/ui/widgets/primary_button.dart';
import 'package:time_planner/src/features/planner/presentation/planner_view_model.dart';

class AddActivityModal extends StatefulWidget {
  const AddActivityModal({super.key});

  @override
  State<AddActivityModal> createState() => _AddActivityModalState();
}

class _AddActivityModalState extends State<AddActivityModal> {
  final _descriptionController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isStartTime) async {
    final initialDate = isStartTime ? _startTime : _endTime;
    final date = await showDatePicker(context: context, initialDate: initialDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (date == null || !mounted) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
    if (time == null) return;
    setState(() {
      final newDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStartTime) {
        _startTime = newDateTime;
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = newDateTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<PlannerViewModel>();
    final timeFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Nova Atividade', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.isEmpty) ? 'Descrição é obrigatória' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('Início: ${timeFormat.format(_startTime)}')),
                IconButton(icon: const Icon(Icons.calendar_month), onPressed: () => _pickDateTime(true)),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('Fim: ${timeFormat.format(_endTime)}')),
                IconButton(icon: const Icon(Icons.calendar_month), onPressed: () => _pickDateTime(false)),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Salvar Atividade',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  viewModel.addActivity(
                    description: _descriptionController.text,
                    startTime: _startTime,
                    endTime: _endTime,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}