import 'package:flutter/material.dart';
import 'package:clean_architecture/injection_container.dart' as di;
import 'package:clean_architecture/app_router.dart';

/// ============================================================
/// MAIN.DART — App starts here!
/// ============================================================
///
/// 📌 WHAT HAPPENS WHEN APP STARTS:
///
/// Step 1: main() runs
/// Step 2: initDependencies() registers everything in GetIt
/// Step 3: runApp() builds the MaterialApp
/// Step 4: GoRouter opens /users (UserListPage)
/// Step 5: BlocProvider creates UserBloc (via GetIt)
/// Step 6: UserListPage dispatches GetUsersEvent
/// Step 7: BLoC → UseCase → Repository → DataSource → API
/// Step 8: Users appear on screen! 🎉

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all dependencies in GetIt
  await di.initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clean Architecture CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // GoRouter handles all navigation
      routerConfig: appRouter,
    );
  }
}
