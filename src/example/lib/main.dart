import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:highlight_on_update/highlight_on_update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  late Timer timer;

  String _customText = 'Edit the text field below to test custom values!';
  String _priceText = '';

  void _updatePrice(Timer _) {
    setState(() {
      _priceText = math.Random().nextInt(100000000).toString();
    });
  }

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 2),
      _updatePrice,
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _updateCustomText(String value) {
    setState(() {
      _customText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HighlightOnUpdateTheme(
      to: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Text(
                  'Current price: \$',
                  style: TextStyle(fontSize: 20),
                ),
                HighlightOnUpdateText(
                  _priceText,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom text:\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HighlightOnUpdateText(
                        _customText,
                        style: const TextStyle(fontSize: 16),
                        to: const Color(0xAAFFFFFF),
                      ),
                    ],
                  ),
                  // const Divider(height: 48.0),
                  const SizedBox(height: 12.0),
                  const Spacer(),
                  TextField(
                    controller: _controller,
                    minLines: 3,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    onChanged: _updateCustomText,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
