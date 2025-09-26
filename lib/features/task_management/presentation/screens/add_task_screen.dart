import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/task_management/presentation/widgets/title_description.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';

// AddTaskScreen은 새로운 작업을 추가하는 화면을 담당하는 StatefulWidget입니다.
// ConsumerStatefulWidget을 상속하여 Riverpod의 상태 관리를 사용합니다.
class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  // 제목과 설명을 입력받기 위한 TextEditingController입니다.
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // 우선순위 선택 버튼에 사용될 텍스트 리스트입니다.
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  // 현재 선택된 우선순위의 인덱스를 저장하는 변수입니다.
  int _selectedPriorityIndex = 0;

  @override
  void dispose() {
    // 위젯이 dispose될 때 컨트롤러를 정리하여 메모리 누수를 방지합니다.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 위젯 크기를 조절하기 위해 SizeConfig를 초기화합니다.
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
            // 작업 제목을 입력받는 위젯입니다.
            TitleDescription(
              title: ' Task Title',
              prefixIcon: Icons.notes,
              hintText: 'Enter task title',
              maxLines: 1,
              controller: _titleController,
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
            // 작업 설명을 입력받는 위젯입니다.
            TitleDescription(
              title: ' Task Description',
              prefixIcon: Icons.notes,
              hintText: 'Enter task description',
              maxLines: 3,
              controller: _descriptionController,
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(20.0)),
            // 우선순위를 선택하는 Row 위젯입니다.
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
                    // 우선순위 버튼들을 가로로 나열하기 위해 ListView.builder를 사용합니다.
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
                              // 선택된 우선순위에 따라 버튼 색상을 변경합니다.
                              color: _selectedPriorityIndex == index
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            child: Text(
                              priority,
                              style: Appstyles.normalTextStyle.copyWith(
                                // 선택된 우선순위에 따라 텍스트 색상을 변경합니다.
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
            // 'Add Task' 버튼입니다.
            InkWell(
              onTap: () {
                // TODO: 작업 추가 로직 구현
              },
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