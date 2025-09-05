// Flutter의 Material Design 위젯과 Riverpod 상태 관리를 위해 필요한 패키지들을 가져옵니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// SignInScreen은 ConsumerStatefulWidget입니다.
// 일반 StatefulWidget과 비슷하지만, Riverpod의 Provider를 구독하고 상태 변화에 반응할 수 있는 기능이 추가되었습니다.
// 여기에서는 로그인상태에 따라서 다른 화면으로 이동하는 로직이 포함될 예정입니다.
// 'Consumer'라는 이름이 붙은 위젯은 Riverpod와 함께 사용됩니다.
class SignInScreen extends ConsumerStatefulWidget {
  // 생성자. super.key는 부모 클래스에 key를 전달하는 역할을 합니다.
  const SignInScreen({super.key});

  // ConsumerStatefulWidget은 ConsumerState 객체를 생성하는 createState() 메소드를 구현해야 합니다.
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

// _SignInScreenState 클래스는 SignInScreen 위젯의 상태를 관리합니다.
// ConsumerState를 상속받았기 때문에, 'ref' 객체를 통해 Riverpod의 Provider에 접근할 수 있습니다.
class _SignInScreenState extends ConsumerState<SignInScreen> {
  // build 메소드는 이 화면의 UI를 구성합니다.
  // 여기서는 build메서드를 Scaffold 위젯으로 감싸고, AppBar를 추가하여 화면 상단에 앱 바를 표시합니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold는 앱 화면의 기본 골격을 만듭니다.
    // Scaffold의 요소로는 body , navigationBar, floatingActionButton 등이 있습니다.
    // AppBar는 화면 상단의 앱 바를 나타냅니다.
    return Scaffold(appBar: AppBar(title: const Text('Sign In')));
  }
}
