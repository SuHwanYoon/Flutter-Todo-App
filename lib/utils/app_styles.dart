import 'package:flutter/material.dart';
import 'package:flutter_todo_app/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

// Appstyles 클래스는 앱 전체에서 사용될 텍스트 스타일을 정의합니다.
// 이렇게 스타일을 한 곳에서 관리하면 앱의 디자인 일관성을 유지하기 쉽고,
// 나중에 스타일을 변경해야 할 때 이 파일만 수정하면 되므로 유지보수가 편리해집니다.
class Appstyles {

  // 'static final'은 이 변수가 앱이 실행되는 동안 변하지 않는다는 것을 의미하며,
  // Appstyles.headingTextStyle처럼 인스턴스를 생성하지 않고도 바로 접근할 수 있게 해줍니다.
  
  // 제목(heading)에 사용될 텍스트 스타일입니다.
  // Google Fonts의 McLaren 폰트를 사용합니다.
  static final headingTextStyle = GoogleFonts.mcLaren(
    // 글자 크기는 SizeConfig를 사용하여 화면 높이에 비례하여 조절됩니다.
    // 이렇게 하면 다양한 크기의 화면에서도 UI가 일관되게 보입니다.
    fontSize: SizeConfig.getProportionateHeight(22),
    // 글자 두께를 600 (w600)으로 설정하여 약간 굵게 표시합니다.
    fontWeight: FontWeight.w600,
    // 글자 색상을 검은색으로 지정합니다.
    color: Colors.black,
  );

  // 소제목(title)에 사용될 텍스트 스타일입니다.
  static final titleTextStyle = GoogleFonts.mcLaren(
    fontSize: SizeConfig.getProportionateHeight(18),
    // 글자 두께를 400 (w400)으로 설정하여 보통 두께로 표시합니다.
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  
  // 일반 텍스트(normal)에 사용될 텍스트 스타일입니다.
  static final normalTextStyle = GoogleFonts.mcLaren(
    fontSize: SizeConfig.getProportionateHeight(12),
    // 글자 두께를 100 (w100)으로 설정하여 매우 얇게 표시합니다.
    fontWeight: FontWeight.w100,
    color: Colors.black,
  );

}