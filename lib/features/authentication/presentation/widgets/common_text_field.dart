import 'package:flutter/material.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';

// 비밀번호 보이기/숨기기 상태를 내부적으로 관리하기 위해 StatefulWidget으로 변경합니다.
class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.textInputType,
    this.obscureText = false, // 기본값을 false로 설정하여 null이 아니도록 합니다.
  });

  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  // 위젯 내부에서 비밀번호 보이기/숨기기 상태를 관리합니다.
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    // 부모 위젯에서 전달된 초기 obscureText 값으로 내부 상태를 설정합니다.
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      controller: widget.controller,
      // 내부 상태(_isObscured)를 사용하여 텍스트를 가립니다.
      obscureText: _isObscured,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Appstyles.normalTextStyle,
        filled: true,
        fillColor: Colors.white,
        // 비밀번호 필드일 경우에만 토글 아이콘을 추가합니다.
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // 아이콘을 누르면 상태를 변경하고 화면을 다시 그립니다.
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      ),
    );
  }
}
