// Flutter의 Material Design 위젯과 Riverpod 상태 관리를 위해 필요한 패키지들을 가져옵니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/features/authentication/presentation/widgets/common_text_field.dart';
import 'package:flutter_todo_app/routes/routes.dart';
import 'package:flutter_todo_app/utils/app_styles.dart';
import 'package:flutter_todo_app/utils/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

// RegisterScreen은 ConsumerStatefulWidget입니다.
// StatefulWidget처럼 동적인 상태를 가질 수 있으면서, 동시에 Riverpod의 Provider와 상호작용할 수 있습니다.
// 이를 통해 회원가입 로직 처리 후 상태를 업데이트하는 등의 작업을 쉽게 할 수 있습니다.
class RegisterScreen extends ConsumerStatefulWidget {
  // 생성자. super.key는 부모 클래스에 key를 전달하는 역할을 합니다.
  const RegisterScreen({super.key});

  // ConsumerStatefulWidget은 ConsumerState 객체를 생성하는 createState() 메소드를 구현해야 합니다.
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

// _RegisterScreenState 클래스는 RegisterScreen 위젯의 상태를 관리합니다.
// ConsumerState를 상속받아 'ref' 객체를 사용할 수 있습니다.
// 'ref'를 사용해 회원가입 기능을 제공하는 Provider를 호출할 수 있습니다.
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // 이메일 입력 필드를 제어하기 위한 컨트롤러.
  final _emailEditingController = TextEditingController();
  // 비밀번호 입력 필드를 제어하기 위한 컨트롤러.
  final _passwordEditingController = TextEditingController();

  // '이용약관 동의' 체크박스의 상태를 저장하는 변수.
  bool isChecked = false;

  @override
  // 위젯이 화면에서 사라질 때 호출되는 메소드입니다.
  // 컨트롤러들이 더 이상 필요 없을 때 메모리 누수를 방지하기 위해 dispose()를 호출해 리소스를 해제합니다.
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  // build 메소드는 이 화면의 UI를 구성합니다.
  // 여기서는 build메서드를 Scaffold 위젯으로 감싸고, AppBar를 추가하여 화면 상단에 앱 바를 표시합니다.
  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따라 위젯 크기를 동적으로 조절하기 위해 SizeConfig를 초기화합니다.
    SizeConfig.init(context);
    // Scaffold를 가장 바깥쪽에 두어 화면 전체의 레이아웃을 잡습니다.
    return Scaffold(
      // body의 내용물만 SafeArea로 감싸서 시스템 UI(상태바, 노치 등)를 피하게 합니다.
      body: SafeArea(
        // 화면 전체에 좌우, 상단 여백을 줍니다.
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.getProportionateWidth(10),
            SizeConfig.getProportionateHeight(50),
            SizeConfig.getProportionateWidth(10),
            0,
          ),
          // 화면 콘텐츠가 길어질 경우 스크롤이 가능하도록 SingleChildScrollView로 감쌉니다.
          // 이렇게 하면 키보드가 올라올 때 UI가 가려져 발생하는 'Bottom Overflow' 오류를 방지할 수 있습니다.
          child: SingleChildScrollView(
            // 위젯들을 세로로 배치하기 위해 Column 위젯을 사용합니다.
            child: Column(
              children: [
                // 화면 상단의 제목 텍스트입니다.
                Text(
                  'Create your account! 👤',
                  style: Appstyles.titleTextStyle,
                ),
                // 위젯들 사이에 수직 간격을 주기 위한 SizedBox입니다.
                SizedBox(height: SizeConfig.getProportionateHeight(25)),
                // 이메일 입력을 위한 공통 텍스트 필드 위젯입니다.
                CommonTextField(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  controller: _emailEditingController,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                // 비밀번호 입력을 위한 공통 텍스트 필드 위젯입니다.
                // obscureText를 true로 설정하여 입력 내용이 가려지도록 합니다.
                CommonTextField(
                  hintText: 'Enter password',
                  textInputType: TextInputType.text,
                  obscureText: true,
                  controller: _passwordEditingController,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(15)),
                // 체크박스와 텍스트를 가로로 나란히 배치하기 위해 Row 위젯을 사용합니다.
                Row(
                  children: [
                    // '이용약관 동의' 체크박스입니다.
                    Checkbox(
                      value: isChecked,
                      // 체크박스의 상태가 변경될 때 호출됩니다.
                      onChanged: (bool? value) {
                        // setState를 호출하여 isChecked 상태를 업데이트하고 화면을 다시 그리도록 합니다.
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    // 체크박스 옆에 표시될 텍스트입니다.
                    Text(
                      'I agree to the Terms & Conditions',
                      style: Appstyles.normalTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(25)),
                // InkWell 위젯은 자식 위젯에 탭 효과(물결 효과)를 추가합니다.
                InkWell(
                  // 탭했을 때 실행될 로직을 여기에 작성합니다. 지금은 비어있습니다.
                  onTap: () {},
                  // 버튼의 모양을 정의하는 Container 위젯입니다.
                  child: Container(
                    alignment: Alignment.center,
                    height: SizeConfig.getProportionateHeight(50),
                    width: SizeConfig.screenWidth,
                    // 버튼의 배경색과 모서리 둥글기를 설정합니다.
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // 버튼 내부에 표시될 텍스트입니다.
                    child: Text(
                      'Sign Up 👤',
                      style: Appstyles.normalTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.getProportionateHeight(1),
                      width: SizeConfig.screenWidth * 0.40,
                      decoration: const BoxDecoration(color: Colors.grey),
                    ),
                    SizedBox(height: SizeConfig.getProportionateHeight(5)),
                    Text('OR', style: Appstyles.normalTextStyle),
                    SizedBox(height: SizeConfig.getProportionateHeight(5)),
                    Container(
                      height: SizeConfig.getProportionateHeight(1),
                      width: SizeConfig.screenWidth * 0.40,
                      decoration: const BoxDecoration(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                // google, apple, facebook버튼 UI Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: SizeConfig.getProportionateHeight(40),
                      width: SizeConfig.screenWidth * 0.25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.deepOrange,
                      ),
                    ),
                    Container(
                      height: SizeConfig.getProportionateHeight(40),
                      width: SizeConfig.screenWidth * 0.25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.apple,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: SizeConfig.getProportionateHeight(40),
                      width: SizeConfig.screenWidth * 0.25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: Appstyles.normalTextStyle,
                    ),
                    // GestureDetector는 터치 이벤트를 감지하는 위젯입니다.
                    // Sign up을 터치할수 있게 됩니다.
                    GestureDetector(
                      onTap: () {
                        context.goNamed(AppRoutes.signIn.name);
                      },
                      child: Text(
                        ' Sign In',
                        style: Appstyles.normalTextStyle.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
