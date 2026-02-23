import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Style {
  static final Style _instance = Style._internal();
  factory Style() => _instance;
  Style._internal();

  TextStyle bold = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  TextStyle semiBold = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  TextStyle medium = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  TextStyle regular = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle light = GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
  );
}