import 'package:flutter/material.dart';

class CustomThemes {
  static final lightThemeMode = ThemeData(
    useMaterial3: true,
    indicatorColor: const Color(0xffE7EAF3),
    scaffoldBackgroundColor: const Color(0xffffffff),
    shadowColor: const Color.fromARGB(163, 216, 215, 215),
    dividerColor: Colors.white,
    cardColor: const Color(0xff333c67),
    disabledColor: const Color(0xff333c67),
    hintColor: const Color(0xff333c67),
    hoverColor: const Color(0xffffffff),
    splashColor: const Color.fromARGB(255, 255, 255, 255),
    dialogBackgroundColor:  Colors.white.withOpacity(.6) ,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[300],
      
    ),
  //    switchTheme: SwitchThemeData(
  //   thumbColor: WidgetStateProperty.all(Colors.white), 
  //   trackColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)), 
  //   trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  //   trackOutlineWidth: WidgetStateProperty.all(0), 
 
  //   splashRadius: 20, 
  // ),
    unselectedWidgetColor: const Color(0xff333c67),
    secondaryHeaderColor: const Color(0xffD0D2E7),
    focusColor: const Color.fromARGB(255, 225, 213, 244),
    highlightColor: const Color.fromARGB(255, 232, 225, 244),
    canvasColor: const Color.fromARGB(255, 232, 225, 244),
    primaryColorDark: const Color.fromARGB(160, 94, 53, 177),
    primaryColorLight: const Color.fromARGB(114, 179, 157, 219),
  );

  static final darkThemeMode = ThemeData(
    useMaterial3: true,
    primaryColorDark: const Color.fromARGB(159, 28, 15, 56),
    primaryColorLight: const Color.fromARGB(113, 31, 17, 57),
    highlightColor: const Color.fromARGB(255, 57, 54, 62),
    canvasColor: const Color.fromARGB(255, 59, 55, 64),
    dialogBackgroundColor:  Colors.black.withOpacity(.8),
    focusColor: const Color.fromARGB(255, 47, 45, 50),
    unselectedWidgetColor: const Color.fromARGB(255, 166, 166, 166),
    indicatorColor: const Color(0xff343434),
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
    hintColor: const Color.fromARGB(235, 244, 244, 244),
    disabledColor: const Color.fromARGB(235, 244, 244, 244),
    shadowColor: const Color.fromARGB(
        0, 0, 0, 0), // Use the dynamic shadow color variable
    dividerColor: const Color.fromARGB(41, 202, 202, 202),
    cardColor: const Color.fromARGB(255, 215, 215, 215),
    hoverColor: const Color.fromARGB(146, 26, 15, 28),
    splashColor: const Color.fromARGB(255, 17, 17, 17),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF1F1F1F),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    secondaryHeaderColor: const Color(0xffbbbbbb),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff1F1F1F),
    ),
  //   switchTheme: SwitchThemeData(
  //   thumbColor: WidgetStateProperty.all(Colors.white), 
  //   trackColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
  //   trackOutlineColor: WidgetStateProperty.all(Colors.transparent), 
  //   trackOutlineWidth: WidgetStateProperty.all(0),
  //   splashRadius: 20,
  // ),
  );
  //greem Color.fromARGB(255, 2, 212, 65),
  //blue  Color.fromARGB(255, 2, 75, 212),
}
