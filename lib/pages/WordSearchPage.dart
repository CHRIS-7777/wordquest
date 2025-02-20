import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wordquest/pages/editpage.dart';
import 'package:wordquest/pages/enternamepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordquest/pages/welcomepage.dart';

class WordSearchPage extends StatefulWidget {
  final String userName;
  final bool isNightMode;
  final Function(bool) onThemeChanged;

  const WordSearchPage({
    super.key,
    required this.userName,
    required this.isNightMode,
    required this.onThemeChanged,
  });

  @override
  _WordSearchPageState createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _definitionList = [];

  // Logout function to clear saved data and navigate to the EnterNamePage
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName'); // Remove the saved name

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Enternamepage(
          onSubmitName: _saveName,
          isNightMode: widget.isNightMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

  // Function to save the name (can be defined elsewhere or just a placeholder)
  void _saveName(String name) {
    // Save the name here (using SharedPreferences or other logic)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = widget.isNightMode; // Use the passed isNightMode flag

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Word Quest',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.iconTheme,
      ),
      drawer: Container(
        decoration: BoxDecoration(
          // Apply gradient when toggle is off (night mode is false)
          gradient: isDarkMode
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFF1C1C64),
                    Color(0xFF4646D8),
                    Color(0xFF7D7DF0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? null
                      : const LinearGradient(
                          colors: [
                            Color(0xFF4646D8),
                            Color(0xFF7D7DF0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: isDarkMode ? theme.primaryColor : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDarkMode ? Colors.black : Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: isDarkMode
                            ? theme.iconTheme.color
                            : const Color(0xFF4646D8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hey, ${widget.userName}!',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.userName}@example.com',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: theme.iconTheme.color),
                title: Text('Home', style: theme.textTheme.bodyLarge),
                onTap: () {
                  // Navigate to home
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WelcomePage(userName: widget.userName),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: theme.iconTheme.color),
                title: Text('Settings', style: theme.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(
                        userName: widget.userName,
                        isNightMode: widget.isNightMode,
                        onThemeChanged: widget.onThemeChanged,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: theme.iconTheme.color),
                title: Text('About', style: theme.textTheme.bodyLarge),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: theme.iconTheme.color),
                title: Text('Logout', style: theme.textTheme.bodyLarge),
                onTap: () {
                  _logout(); // Call the logout function
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFF1C1C64),
                    Color(0xFF4646D8),
                    Color(0xFF7D7DF0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isDarkMode ? Colors.black : null,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    hintText: "Type a Word",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _fetchDefinition,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? const Color.fromARGB(255, 47, 118, 240)
                        : Colors.white,
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 0, 139, 253),
                    padding: const EdgeInsets.symmetric(
                        vertical: 17, horizontal: 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: _definitionList.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/picachu2.png',
                            // Replace with your image path
                            height: 400, // Adjust height as needed
                            width: 400, // Adjust width as needed
                          ),
                        )
                      : ListView.builder(
                          itemCount: _definitionList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '• ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _definitionList[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchDefinition() async {
    final word = _controller.text;
    if (word.isEmpty) return;

    final url =
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<String> definitions = [];

        for (var meaning in data[0]['meanings']) {
          for (var definition in meaning['definitions']) {
            definitions.add(definition['definition']);
          }
        }

        setState(() {
          _definitionList = definitions;
        });
      } else {
        setState(() {
          _definitionList = ['Definition not found.'];
        });
      }
    } catch (e) {
      setState(() {
        _definitionList = ['Error fetching definition.'];
      });
    }
  }
}
