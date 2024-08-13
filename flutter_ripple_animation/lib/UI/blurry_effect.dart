import 'package:flutter/material.dart';

class BlurryEffectScreen extends StatefulWidget {
  const BlurryEffectScreen({super.key});

  @override
  State<BlurryEffectScreen> createState() => _BlurryEffectScreenState();
}

class _BlurryEffectScreenState extends State<BlurryEffectScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          child: Text("HI! I am Blurry Screen!!"),
        ),
      ),
    );
  }
}
