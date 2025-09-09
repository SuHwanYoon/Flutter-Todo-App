import 'package:flutter/cupertino.dart';

// SizeConfig 클래스는 앱의 UI 요소 크기를 화면 크기에 맞게 동적으로 조절하는 역할을 합니다.
// 이렇게 하면 다양한 해상도와 화면 비율을 가진 장치에서도 UI가 깨지거나 어색해 보이지 않고
// 일관된 레이아웃을 유지할 수 있습니다. (반응형 UI)
class SizeConfig {
  // 화면의 너비와 높이를 저장할 변수입니다.
  // static으로 선언하여 앱 어디서든 SizeConfig.screenWidth처럼 쉽게 접근할 수 있습니다.
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;

  // 앱이 시작될 때 첫 화면(예: main.dart의 MaterialApp)에서 이 함수를 호출하여
  // 현재 장치의 화면 크기를 초기화해야 합니다.
  // 이 초기화 메서드를 사용하면 MediaQuery를 통해 현재 화면 크기를 읽어서 초기화되기 때문에
  // 그 이후에는 0 이 아니라 기기화면 크기 값으로 동작하게 된다
  static void init(BuildContext context) {
    // MediaQuery.of(context).size는 현재 화면의 크기 정보를 담고 있는 객체입니다.
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  // 디자이너가 제공한 UI 시안의 기준 높이(inputHeight)를 받아서
  // 현재 화면 높이에 비례하는 값으로 변환해줍니다.
  // 812.0은 디자이너가 기준으로 삼은 화면의 높이입니다. (예: iPhone X)
  static double getProportionateHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight;
  }

  // 디자이너가 제공한 UI 시안의 기준 너비(inputWidth)를 받아서
  // 현재 화면 너비에 비례하는 값으로 변환해줍니다.
  // 375.0은 디자이너가 기준으로 삼은 화면의 너비입니다. (예: iPhone X)
  static double getProportionateWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth;
  }
}