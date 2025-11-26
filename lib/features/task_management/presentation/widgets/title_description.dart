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
    this.maxLength,
    this.showCharacterCount = false,
    this.minLines,
    this.focusNode,
  });

  final String title;
  final IconData prefixIcon;
  final String hintText;
  final int maxLines;
  final TextEditingController controller;
  final int? maxLength;
  final bool showCharacterCount;
  final int? minLines;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Appstyles.titleTextStyle.copyWith(
            fontSize: 18.0,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: SizeConfig.getProportionateHeight(10.0)),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(color: colorScheme.onSurface),
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          buildCounter: showCharacterCount && maxLength != null
              ? (context, {required currentLength, required isFocused, maxLength}) {
                  return Text(
                    '$currentLength/$maxLength',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  );
                }
              : null,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: isDarkMode
                ? colorScheme.surfaceContainerHighest
                : Colors.grey[200],
            prefixIcon: maxLines > 1
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Icon(prefixIcon, color: colorScheme.onSurfaceVariant),
                  )
                : Icon(prefixIcon, color: colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            alignLabelWithHint: true,
          ),
          textAlignVertical: TextAlignVertical.top,
        ),
      ],
    );
  }
}
