import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body:  Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
        ),
        child:Center(
        child: Lottie.asset(
          'assets/lottie/Welcome.json',
          width: 250,
          height: 250,
          repeat: false,
          animate: true,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();

            _controller.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
            });
          },
        ),
      ),
      ),
    );
  }
}
