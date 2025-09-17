import 'package:flutter/material.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';

//stateless widget은 상태가 없는 위젯입니다.
//즉, 위젯이 생성된 후에는 변경되지 않는다는 의미입니다.
//따라서, 이 위젯은 단순히 주어진 데이터를 화면에 표시하는 역할을 합니다.
class TitleDescription extends StatelessWidget {
  const TitleDescription({
    super.key,
    required this.title,
    required this.prefixIcon,
    required this.hintText,
    required this.maxLines,
    required this.controller,
  });

  final String title;
  final IconData prefixIcon;
  final String hintText;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Appstyles.titleTextStyle.copyWith(fontSize: 18.0)),
        SizedBox(height: SizeConfig.getProportionateHeight(10.0)),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(prefixIcon, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
