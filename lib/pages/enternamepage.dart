import 'package:flutter/material.dart';
import 'package:wordquest/pages/welcomepage.dart'; // Import the WelcomePage

class Enternamepage extends StatefulWidget {
  final Function(String) onSubmitName; // Callback to save the name
  final bool isNightMode;
  final Function(bool) onThemeChanged;

  const Enternamepage({
    super.key,
    required this.onSubmitName,
    required this.isNightMode,
    required this.onThemeChanged,
  });

  @override
  State<Enternamepage> createState() => _EnternamepageState();
}

class _EnternamepageState extends State<Enternamepage> {
  final TextEditingController _nameController = TextEditingController();

  // Function to handle the submit action
  void _submitName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      widget.onSubmitName(name); // Call the callback function to save the name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage(userName: name)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isNightMode; // Get the current theme mode

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Name'),
        centerTitle: true,
        backgroundColor: isDarkMode
            ? Colors.black
            : const Color(0xFF4646D8), // Gradient color
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1C1C64), // Dark Purple
              Color(0xFF4646D8), // Violet
              Color(0xFF7D7DF0), // Lighter Violet
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Image to be added here

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name entry field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black, // Text color based on theme
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.white54
                                : Colors.black54, // Hint text color
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[200], // Adaptive color
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Submit button with border and rounded shape
                    ElevatedButton(
                      onPressed: _submitName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? Colors.blueAccent // Button color for dark mode
                            : const Color(
                                0xFF4646D8), // Violet gradient color for light mode
                        foregroundColor:
                            Colors.white, // Text color for the button
                        padding: const EdgeInsets.symmetric(
                            vertical: 17, horizontal: 35),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Round button shape
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/picachu.png',
                // Replace with your image path
                height: 290, // Adjust height as needed
                width: 290, // Adjust width as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
