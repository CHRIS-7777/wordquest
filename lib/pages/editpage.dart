import 'package:flutter/material.dart';

import 'package:wordquest/pages/WordSearchPage.dart';

class EditPage extends StatefulWidget {
  final String userName;
  final Function(bool) onThemeChanged;
  final bool isNightMode;

  const EditPage({
    super.key,
    required this.userName,
    required this.isNightMode,
    required this.onThemeChanged,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late bool _isNightMode;

  @override
  void initState() {
    super.initState();
    _isNightMode = widget.isNightMode; // Initialize the theme state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WordSearchPage(
                  userName: widget.userName,
                  isNightMode: _isNightMode, // Pass the current theme state
                  onThemeChanged:
                      widget.onThemeChanged, // Pass theme change callback
                ),
              ),
            );
          },
        ),
      ),
      body: Container(
        // Apply gradient when toggle is off (night mode is false)
        decoration: BoxDecoration(
          gradient: _isNightMode
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFF4646D8),
                    Color(0xFF7D7DF0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: _isNightMode ? Colors.black : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Night Mode",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _isNightMode,
                    onChanged: (bool value) {
                      setState(() {
                        _isNightMode = value;
                      });
                      widget.onThemeChanged(
                          value); // Notify parent of the theme change
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
