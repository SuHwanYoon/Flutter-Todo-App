import 'package:flutter/material.dart';

// PriorityColors 클래스는 앱 전체에서 사용될 우선순위별 색상을 정의합니다.
// 이렇게 색상을 한 곳에서 관리하면 앱의 디자인 일관성을 유지하기 쉽고,
// 나중에 색상 정책을 변경해야 할 때 이 파일만 수정하면 되므로 유지보수가 편리해집니다.
class PriorityColors {
  // 'static' 메서드로 선언하여 인스턴스를 생성하지 않고도 바로 접근할 수 있게 합니다.
  static Color getColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}