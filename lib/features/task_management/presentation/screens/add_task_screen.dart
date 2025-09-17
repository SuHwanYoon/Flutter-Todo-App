import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/task_management/presentation/widgets/title_description.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {


  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: Appstyles.titleTextStyle.copyWith(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          children: [
            TitleDescription(
              title: ' Task Title',
              prefixIcon: Icons.notes,
              hintText: 'Enter task title',
              maxLines: 1,
              controller: _titleController,
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
            TitleDescription(
              title: ' Task Description',
              prefixIcon: Icons.notes,
              hintText: 'Enter task description',
              maxLines: 3,
              controller: _descriptionController,
            ),
          ],
        ),
      ),
    );
  }
}
