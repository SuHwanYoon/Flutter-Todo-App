

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class Appstyles {

  static final headingTextStyle = GoogleFonts.mcLaren(
    fontSize: SizeConfig.getProportionateHeight(22),
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

 static final titleTextStyle = GoogleFonts.mcLaren(
    fontSize: SizeConfig.getProportionateHeight(18),
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  

  static final normalTextStyle = GoogleFonts.mcLaren(
    fontSize: SizeConfig.getProportionateHeight(12),
    fontWeight: FontWeight.w100,
    color: Colors.black,
  );

}
