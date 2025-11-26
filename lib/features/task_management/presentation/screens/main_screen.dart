// Flutter의 Material Design 위젯을 사용하기 위해 가져옵니다.
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/features/authentication/presentation/screens/accounts_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/add_task_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/all_tasks_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/completed_tasks_screen.dart';
import 'package:flutter_todo_app/features/task_management/presentation/screens/incomplete_tasks_screen.dart';

// MainScreen의 State에 접근하기 위한 GlobalKey입니다.
// 이를 통해 다른 위젯에서 MainScreen의 상태를 제어할 수 있습니다.
final mainScreenKey = GlobalKey<_MainScreenState>();

// ConsumerStatefulWidget은 상태 관리를 위해 Riverpod의 Consumer를 사용할 수 있는 StatefulWidget입니다.
// consumer는 Riverpod의 Provider를 구독(watch)할 수 있게 해줍니다.
// 예를 들어, 할 일 목록을 추가하거나 삭제하면 화면이 업데이트되어야 합니다.
class MainScreen extends StatefulWidget {
  // 생성자. super.key는 StatefulWidget에 key를 전달하는 역할을 합니다.
  const MainScreen({super.key}); // key는 여기서 전달받습니다.

  // override는 부모 클래스(여기서는 StatefulWidget)에 정의된 메소드를 자식 클래스에서 재정의(override)한다는 의미입니다.
  // createState()는 StatefulWidget의 필수 메서드로, 이 위젯의 가변 상태를 생성합니다.
  // StatefulWidget은 상태(State) 객체를 생성하는 createState() 메소드를 구현해야 합니다.
  // 이 메소드가 반환하는 State 객체에서 실제 화면 UI와 로직을 관리합니다.
  @override
  State<MainScreen> createState() => _MainScreenState();
}

// _MainScreenState 클래스는 MainScreen 위젯의 '상태'를 관리합니다.
// 클래스 이름 앞에 밑줄(_)이 붙으면 private 클래스가 되어 이 파일 안에서만 사용할 수 있습니다.
// with 키워드는 다중 상속을 가능하게 합니다. 여기서는 SingleTickerProviderStateMixin을 사용하여 애니메이션 컨트롤러에 필요한 Ticker를 제공합니다.
// SingleTickerProviderStateMixin은 애니메이션을 사용할 때 필요한 Ticker를 제공하는 믹스인입니다.
class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  // late 키워드는 변수가 나중에 초기화될 것임을 나타냅니다.
  // 탭 바(TabBar)와 탭 뷰(TabBarView)를 제어하는 데 사용될 TabController를 선언
  late TabController _tabController;
  // 현재 선택된 탭의 인덱스를 저장하는 변수입니다.
  int currentIndex = 0;

  // 외부에서 탭을 변경할 수 있도록 하는 public 메서드입니다.
  void changeTab(int index) => _tabController.animateTo(index);

  // 외부에서 SnackBar를 표시할 수 있도록 하는 public 메서드입니다.
  void showSnackBar(String message, {Color backgroundColor = Colors.green}) {
    // 혹시 이전에 표시된 SnackBar가 있다면 지웁니다.
    ScaffoldMessenger.of(context).clearSnackBars();
    // 새로운 SnackBar를 표시합니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // initState() 메소드는 State 객체가 처음 생성될 때 호출됩니다.
  // 여기서는 TabController를 초기화하는 데 사용됩니다.
  // vsync: this는 현재 State 객체를 TickerProvider로 사용하겠다는 의미입니다.
  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    // TabController의 인덱스가 변경될 때마다(예: 스와이프) 리스너를 추가합니다.
    // 이 리스너는 BottomNavigationBar의 현재 인덱스를 업데이트하여
    // 화면과 네비게이션 바가 항상 동기화되도록 합니다.
    _tabController.addListener(() {
      // TabController의 현재 인덱스로 currentIndex를 업데이트합니다.
      setState(() => currentIndex = _tabController.index);
    });
    super.initState();
  }

  // dispose() 메소드는 State 객체가 제거될 때 호출됩니다.
  // 여기서는 TabController를 해제하여 메모리 누수를 방지합니다.
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  // build 메소드는 화면에 보여질 UI를 구성하고 반환합니다.
  // State 객체의 상태가 변경될 때마다 (예: setState() 호출) 이 build 메소드가 다시 실행되어 화면이 갱신됩니다.
  @override
  Widget build(BuildContext context) {
    // Scaffold는 Material Design 앱의 기본적인 레이아웃 구조를 제공합니다.
    // 앱 바(AppBar), 본문(body), 플로팅 액션 버튼 등을 쉽게 배치할 수 있습니다.
    // TabBarView는 여러 개의 탭을 스와이프하여 전환할 수 있는 뷰를 제공합니다.
    // TabBarView의 controller 속성에 _tabController를 지정하여 탭 전환을 제어합니다.
    // children에는 각 탭에 해당하는 화면 위젯들을 나열합니다.
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        // 스와이프로 탭 전환 비활성화 - 하단 탭바만 사용 가능
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          AllTasksScreen(),
          IncompleteTasksScreen(),
          AddTaskScreen(),
          CompletedTasksScreen(),
          AccountsScreen(),
        ],
      ),
      // BottomNavigationBar는 화면 하단에 고정된 네비게이션 바를 제공합니다.
      // currentIndex는 현재 선택된 탭의 인덱스를 나타냅니다.
      // onTap 콜백은 사용자가 탭을 선택할 때 호출되며
      // setState()를 호출하여 currentIndex를 업데이트하고 화면을 갱신합니다.
      // elevation은 네비게이션 바의 그림자 깊이를 설정합니다.
      // type은 네비게이션 바의 유형을 지정합니다. 여기서는 고정된 유형을 사용합니다.
      // items에는 네비게이션 바에 표시될 아이콘과 레이블을 정의합니다.
      // setState()는 상태가 변경되었음을 Flutter 프레임워크에 알리고
      // build() 메소드를 다시 호출하여 UI를 갱신합니다.
      // 이렇게 하면 사용자가 탭을 선택할 때마다 화면이 해당 탭에 맞게 업데이트됩니다.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            _tabController.index = value;
          });
        },
        iconSize: 20.0,
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous_outlined),
            label: 'Incomplete',
            activeIcon: Icon(Icons.dangerous)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
            activeIcon: Icon(Icons.add_circle)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Completed',
            activeIcon: Icon(Icons.check_circle)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
            activeIcon: Icon(Icons.account_circle)
          ),
        ],
      ),
    );
  }
}
