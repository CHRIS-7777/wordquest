import 'package:flutter/material.dart';
import 'package:wordquest/pages/wordsearchpage.dart'; // Import WordSearchPage

class WelcomePage extends StatelessWidget {
  final String userName;

  const WelcomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF121212) // Dark background color
        : const Color(0xFFFFFFFF); // Light background color
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;
    final gradientColors = isDarkMode
        ? [const Color(0xFF4646D8), const Color(0xFF1C1C64)]
        : [
            const Color(0xFF4646D8),
            const Color(0xFF7D7DF0),
          ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0, // Make the AppBar blend into the background
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Curved top container
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: 80,
              color: backgroundColor, // Dynamically adapt to theme
            ),
          ),
          // Page content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or image
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    'assets/student-removebg.png',
                    width: 200,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 30),
                // Title with username
                Text(
                  'Welcome to Quest, $userName!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    shadows: [
                      Shadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.8)
                            : Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Subtitle
                Text(
                  'Your journey to explore words begins here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 40),
                // Button to navigate to WordSearchPage
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordSearchPage(
                          userName: userName,
                          isNightMode:
                              isDarkMode, // Pass the correct value for night mode
                          onThemeChanged:
                              (newMode) {}, // Pass actual callback function if needed
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: isDarkMode
                        ? Colors.grey[800]
                        : Colors.white, // Adaptive button color
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.blue[300]
                          : const Color.fromARGB(255, 7, 133, 236),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Quote
                Text(
                  '"A new word is a window to a new world!"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper for the curved top design
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100); // Start at the bottom left
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100, // Create a curve
    );
    path.lineTo(size.width, 0); // Line to the top right
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
