import 'package:flutter/material.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';

// CommonTextField는 앱 전체에서 공통적으로 사용될 텍스트 입력 필드 위젯입니다.
// 이메일, 비밀번호 등 다양한 종류의 텍스트 입력을 처리할 수 있도록 만들어졌습니다.
// StatefulWidget으로 만든 이유는 비밀번호 필드에서 텍스트 보이기/숨기기 상태를
// 위젯 내부적으로 관리하기 위함입니다.
class CommonTextField extends StatefulWidget {
  // 생성자: CommonTextField를 생성할 때 필요한 값들을 전달받습니다.
  const CommonTextField({
    super.key, // 부모 위젯에 key를 전달합니다.
    required this.hintText, // 입력 필드에 표시될 안내 텍스트 (예: '이메일을 입력하세요')
    required this.controller, // 입력된 텍스트를 제어하고 가져오기 위한 컨트롤러
    required this.textInputType, // 키보드 타입을 지정합니다 (예: 이메일, 숫자, 일반 텍스트)
    this.obscureText = false, // 텍스트를 가릴지 여부 (주로 비밀번호에 사용)
  });

  // 외부에서 전달받는 속성들을 final로 선언합니다.
  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

// _CommonTextFieldState는 CommonTextField의 상태를 관리하는 클래스입니다.
class _CommonTextFieldState extends State<CommonTextField> {
  // 위젯 내부에서만 사용될 비밀번호 보이기/숨기기 상태 변수입니다.
  // 'late' 키워드는 이 변수가 나중에 초기화될 것임을 나타냅니다.
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때, 부모 위젯에서 전달받은 obscureText 값으로
    // 내부 상태(_isObscured)를 초기화합니다.
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    // TextFormField는 사용자의 입력을 받고 유효성 검사도 할 수 있는 강력한 입력 필드 위젯입니다.
    return TextFormField(
      keyboardType: widget.textInputType, // 생성자에서 받은 키보드 타입 설정
      controller: widget.controller, // 생성자에서 받은 컨트롤러 연결
      obscureText: _isObscured, // 내부 상태 변수를 사용하여 텍스트 가리기 여부 결정
      decoration: InputDecoration(
        hintText: widget.hintText, // 안내 텍스트 설정
        hintStyle: Appstyles.normalTextStyle, // 안내 텍스트 스타일 적용
        filled: true, // 배경색을 채울지 여부
        fillColor: Colors.white, // 배경색은 흰색으로 지정
        // 만약 비밀번호 필드(widget.obscureText가 true)라면,
        // 텍스트 보이기/숨기기 토글 아이콘을 오른쪽에 추가합니다.
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  // _isObscured 상태에 따라 다른 아이콘을 보여줍니다.
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // 아이콘을 누를 때마다 _isObscured 상태를 반전시키고,
                  // setState()를 호출하여 화면을 다시 그리도록 합니다.
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null, // 비밀번호 필드가 아니면 아이콘을 표시하지 않습니다.
        // 입력 필드의 테두리 스타일을 정의합니다.
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
          borderSide: const BorderSide(color: Colors.grey, width: 1.0), // 평상시 테두리
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
          borderSide: const BorderSide(color: Colors.blue, width: 1.0), // 포커스 됐을 때 테두리
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0), // 내부 여백
      ),
    );
  }
}