import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_architecture/injection_container.dart' as di;
import 'package:clean_architecture/features/user/presentation/bloc/user_bloc.dart';
import 'package:clean_architecture/features/user/presentation/pages/user_list_page.dart';
import 'package:clean_architecture/features/user/presentation/pages/user_detail_page.dart';
import 'package:clean_architecture/features/user/presentation/pages/user_form_page.dart';
import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';

/// ============================================================
/// APP ROUTER — GoRouter navigation setup
/// ============================================================
///
/// 📌 WHAT IS GoRouter?
/// GoRouter gives you URL-based navigation, like websites.
/// Each page has a URL path (e.g., /users, /users/5, /users/create)
///
/// 📌 ROUTES TABLE:
/// /users           → User List Page (home)
/// /users/create    → Create User Form
/// /users/:id       → User Detail Page (e.g., /users/5)
/// /users/:id/edit  → Edit User Form
///
/// 📌 IMPORTANT:
/// Each route wraps its page in BlocProvider.
/// This gives the page access to UserBloc.

final GoRouter appRouter = GoRouter(
  initialLocation: '/users', // App starts here
  routes: [
    GoRoute(
      path: '/users',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => di.sl<UserBloc>(), // GetIt creates BLoC
          child: const UserListPage(),
        );
      },
      routes: [
        // /users/create
        GoRoute(
          path: 'create',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => di.sl<UserBloc>(),
              child: const UserFormPage(), // user=null → Create mode
            );
          },
        ),

        // /users/:id (e.g., /users/5)
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final userId = int.parse(state.pathParameters['id']!);
            return BlocProvider(
              create: (_) => di.sl<UserBloc>(),
              child: UserDetailPage(userId: userId),
            );
          },
          routes: [
            // /users/:id/edit
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final userId = int.parse(state.pathParameters['id']!);
                return BlocProvider(
                  create: (_) => di.sl<UserBloc>(),
                  child: UserFormPage(
                    user: UserEntity(
                      id: userId,
                      name: '',
                      email: '',
                      phone: '',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
