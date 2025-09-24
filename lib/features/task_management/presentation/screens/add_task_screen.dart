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
  // 아래 위젯버튼에서 사용할 텍스트 리스트로 선언
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  int _selectedPriorityIndex = 0;

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
            SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
            // 우선순위 선택하는 Row 위젯
            Row(
              children: [
                Text(
                  'Priority',
                  style: Appstyles.headingTextStyle.copyWith(
                    fontSize: SizeConfig.getProportionateHeight(18),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: SizeConfig.getProportionateHeight(40),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _priorities.length,
                      itemBuilder: (context, index) {
                        final priority = _priorities[index];
                        // GestureDetector는 탭 이벤트를 감지하는 위젯입니다.
                        // 사용자가 우선순위 버튼을 탭하면 _selectedPriorityIndex를 업데이트하고
                        // 화면을 다시 그려 선택된 우선순위가 시각적으로 표시되도록 합니다.
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriorityIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.getProportionateWidth(8.0),
                            ),
                            padding: EdgeInsets.all(
                              SizeConfig.getProportionateHeight(8.0),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _selectedPriorityIndex == index
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            child: Text(
                              priority,
                              style: Appstyles.normalTextStyle.copyWith(
                                color: _selectedPriorityIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
            InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.getProportionateHeight(50),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // 'Add Task' 버튼 내부에 아이콘과 텍스트를 배치합니다.
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 30),
                    Text(
                      'Add Task',
                      style: Appstyles.normalTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
