import 'package:contatos/src/views/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppCore extends StatelessWidget {
  const AppCore({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Perfis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.pink,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.pink,
            onPrimary: Colors.white,
            secondary: Colors.blue,
            onSecondary: Colors.black,
            background: Colors.white,
            onBackground: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            error: Colors.red,
            onError: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.pink,
              statusBarColor: Colors.pink,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            centerTitle: true,
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            elevation: 7,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
