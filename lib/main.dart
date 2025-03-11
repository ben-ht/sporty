import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sporty/ui/chat/chat.dart';
import 'package:sporty/ui/create/create.dart';
import 'package:sporty/ui/event_details/event_details.dart';
import 'package:sporty/ui/event_feed/event_feed.dart';
import 'package:sporty/ui/search/search.dart';
import 'package:sporty/ui/signup/widgets/signup.dart';
import 'package:sporty/ui/signup/widgets/sports_selection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/service/events_service.dart';
import 'model/event/event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://fosyvfvlcmvvzeizrgss.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvc3l2ZnZsY212dnplaXpyZ3NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzMDE5MjcsImV4cCI6MjA1NDg3NzkyN30.eN4vLxA7TJNWLSTjVkPuWo5y_507oJJpBrsA-PQLZ5E");
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyAppState()),
          // Provider(create: (context) => EventsService()),
        ],
        child: MyApp(),
      )
  );
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
        onGenerateRoute: (settings) {
          if (settings.name == '/event_details') {
            final event = settings.arguments as Event;
            return MaterialPageRoute(builder: (context) => EventDetail(event: event));
          }
          return null;
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
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);

    // Lazy-initialize pages when building
    final pages = [
      const EventFeed(),
      const CreateApp(),
      const Search(),
      const ChatApp(),
    ];
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
          BottomNavigationBarItem(icon: Icon(Icons.create), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        ],
      ) : null,
    );
  }
}
