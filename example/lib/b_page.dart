import 'package:flutter/material.dart';


class BPage extends StatefulWidget {
  const BPage({super.key});

  @override
  State<BPage> createState() => _BPageState();
}

class _BPageState extends State<BPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("B Page"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Replace CPage 带参数\n{\"key1\": \"value1\"}"),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/c_page", arguments: {"key": "value"});
          },
        ),
      ),
    );
  }
}
