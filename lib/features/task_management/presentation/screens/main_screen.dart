// Flutter의 Material Design 위젯을 사용하기 위해 가져옵니다.
import 'package:flutter/material.dart';

// MainScreen은 StatefulWidget입니다.
// StatefulWidget은 화면의 내용이 사용자의 상호작용이나 데이터 변경에 따라 바뀔 수 있는 동적인 위젯입니다.
// 예를 들어, 할 일 목록을 추가하거나 삭제하면 화면이 업데이트되어야 합니다.
class MainScreen extends StatefulWidget {
  // 생성자. super.key는 StatefulWidget에 key를 전달하는 역할을 합니다.
  const MainScreen({super.key});

  // override는 부모 클래스(여기서는 StatefulWidget)에 정의된 메소드를 자식 클래스에서 재정의(override)한다는 의미입니다.
  // createState()는 StatefulWidget의 필수 메서드로, 이 위젯의 가변 상태를 생성합니다.
  // StatefulWidget은 상태(State) 객체를 생성하는 createState() 메소드를 구현해야 합니다.
  // 이 메소드가 반환하는 State 객체에서 실제 화면 UI와 로직을 관리합니다.
  @override
  State<MainScreen> createState() => _MainScreenState();
}

// _는 해당 파일내부에서만 사용하는 멤버를 나타낸는 관습적 코딩이며 접근제한을 실제로도 적용해줌
// _MainScreenState 클래스는 MainScreen 위젯의 '상태'를 관리합니다.
// 클래스 이름 앞에 밑줄(_)이 붙으면 private 클래스가 되어 이 파일 안에서만 사용할 수 있습니다.
class _MainScreenState extends State<MainScreen> {
  // build 메소드는 화면에 보여질 UI를 구성하고 반환합니다.
  // State 객체의 상태가 변경될 때마다 (예: setState() 호출) 이 build 메소드가 다시 실행되어 화면이 갱신됩니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold는 Material Design 앱의 기본적인 레이아웃 구조를 제공합니다.
    // 앱 바(AppBar), 본문(body), 플로팅 액션 버튼 등을 쉽게 배치할 수 있습니다.
    return Scaffold(appBar: AppBar(title: const Text('오늘의 할일')));
  }
}
