import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kharcha/navigation.dart';
import 'package:kharcha/screens/auth/login.dart';
import 'package:kharcha/utils/theme/theme.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: KharchaTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}
