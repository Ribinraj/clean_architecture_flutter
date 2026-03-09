import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_bloc.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_event.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_state.dart';

/// ============================================================
/// USER DETAIL PAGE — Shows one user's full details
/// ============================================================
///
/// 📌 DATA FLOW:
/// 1. Receives userId from GoRouter URL (/users/5 → userId = 5)
/// 2. Dispatches GetUserEvent(5)
/// 3. BLoC → UseCase → Repository → DataSource → API
/// 4. API returns user JSON → parsed → BLoC emits UserLoaded
/// 5. BlocBuilder shows the user's details

class UserDetailPage extends StatefulWidget {
  final int userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    // Fetch this user's data
    context.read<UserBloc>().add(GetUserEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          // Loading
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // User loaded — show details
          if (state is UserLoaded) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Big avatar
                  CircleAvatar(
                    radius: 50,
                    child: Text(user.name[0], style: const TextStyle(fontSize: 40)),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),

                  // Email tile
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),

                  // Phone tile
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: Text(user.phone),
                  ),
                  const SizedBox(height: 24),

                  // Edit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/users/${user.id}/edit'),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit User'),
                    ),
                  ),
                ],
              ),
            );
          }

          // Error
          if (state is UserError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
