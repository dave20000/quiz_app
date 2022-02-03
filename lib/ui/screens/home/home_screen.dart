import 'package:flutter/material.dart';
import 'package:quiz_app/ui/screens/quiz/quiz_screen.dart';
import 'package:quiz_app/ui_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [
    "linux",
    "sql",
    "devops",
    "cms",
    "code",
    "docker",
    "uncategorized",
  ];

  List<String> difficulties = ["Easy", "Medium", "Hard"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIHelper.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UIHelper.backgroundColor,
        elevation: 0,
        title: const Text(
          "Welcome to Quiz App",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => UIHelper.verticalDivider(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1,
                color: UIHelper.mainThemeColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: UIHelper.mainThemeColor,
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: const Offset(2, 4),
                )
              ],
            ),
            child: InkWell(
              onTap: () {
                String url =
                    "https://quizapi.io/api/v1/questions?apiKey=i9yLZ9k0XSPw6uhwAwBfEePOY9J4BkR7UUxEGhtv";
                url = url + "&category=${categories[index]}";
                url = url + "&difficulty=${difficulties[1]}";
                url = url + "&limit=20";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(testUrl: url),
                  ),
                );
              },
              splashColor: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
                leading: Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: UIHelper.mainThemeColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: UIHelper.mainThemeColor,
                    ),
                  ),
                ),
                title: Text(
                  categories[index][0].toUpperCase() +
                      categories[index].substring(1),
                  style: TextStyle(
                    color: UIHelper.mainThemeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  "20/20 Questions",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Difficulty"),
                    PopupMenuButton<int>(
                      padding: EdgeInsets.zero,
                      onSelected: (int selectedValue) {},
                      itemBuilder: (context) => const [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Easy"),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text("Medium"),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text("High"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
