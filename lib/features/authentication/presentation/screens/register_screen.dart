// Flutter의 Material Design 위젯과 Riverpod 상태 관리를 위해 필요한 패키지들을 가져옵니다.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // build 메소드는 회원가입 화면의 UI를 구성하고 반환합니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold는 앱 화면의 기본 골격을 만듭니다.
    // AppBar는 화면 상단의 앱 바를 나타냅니다.
    return Scaffold(appBar: AppBar(title: const Text('Register')));
  }
}
