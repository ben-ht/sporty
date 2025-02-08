import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sporty/ui/search/search.dart';
import 'package:sporty/ui/signup/widgets/Signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sporty/ui/signup/widgets/sports_selection.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Sporty',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        ),
        home: SignupScreen(),
        routes: {
          '/home': (context) => MainScreen(),
          '/signup': (context) => SignupScreen(),
          '/sportsPreferences': (context) => SportsSelection(),
          '/search': (context) => Search(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}


class MainScreen extends StatelessWidget {
  final List<Widget> pages = [
    const HomeScreen(),
    const Search()
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);

    bool showBottomNavigationBar = pages[appState.selectedIndex] is! SignupScreen;

    return Scaffold(
      body: pages[appState.selectedIndex],
      bottomNavigationBar:  showBottomNavigationBar ? BottomNavigationBar(
        currentIndex: appState.selectedIndex,
        onTap: (index) {
          appState.setSelectedIndex(index);
        },
        type: BottomNavigationBarType.fixed, // Ajoutez cette ligne
        selectedItemColor: Theme.of(context).colorScheme.primary, // Optionnel: pour une meilleure cohérence visuelle
        unselectedItemColor: Colors.grey, // Optionnel: pour une meilleure cohérence visuelle
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
      ) : null,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
