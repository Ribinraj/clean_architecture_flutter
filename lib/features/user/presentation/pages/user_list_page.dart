import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_bloc.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_event.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_state.dart';

/// ============================================================
/// USER LIST PAGE — Shows all users (Main screen)
/// ============================================================
///
/// 📌 COMPLETE DATA FLOW WHEN THIS PAGE OPENS:
///
/// 1. initState() runs
/// 2. Dispatches GetUsersEvent to BLoC
/// 3. BLoC calls GetUsers use case
/// 4. GetUsers calls UserRepository.getUsers()
/// 5. UserRepositoryImpl calls UserRemoteDataSource.getUsers()
/// 6. DataSource makes HTTP GET /users via Dio
/// 7. API returns JSON array of users
/// 8. JSON → List<UserModel> → List<UserEntity>
/// 9. BLoC emits UsersLoaded(users)
/// 10. BlocBuilder rebuilds → shows ListView of users
///
/// 📌 BLOC WIDGETS USED:
/// BlocConsumer = BlocListener + BlocBuilder combined
///   - Listener: for side effects (SnackBars, navigation)
///   - Builder: for rebuilding the UI

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    // Load users when page opens
    context.read<UserBloc>().add(GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),

      // ➕ Floating button to create new user
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/users/create'),
        child: const Icon(Icons.add),
      ),

      body: BlocConsumer<UserBloc, UserState>(
        // ── LISTENER: runs once per state change (for side effects)
        listener: (context, state) {
          if (state is UserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            // Refresh list after create/update/delete
            context.read<UserBloc>().add(GetUsersEvent());
          }
        },

        // ── BUILDER: rebuilds UI based on current state
        builder: (context, state) {
          // Loading
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Users loaded
          if (state is UsersLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];

                // Each user is displayed as a Card
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    // Avatar with first letter
                    leading: CircleAvatar(child: Text(user.name[0])),

                    // Name & email
                    title: Text(user.name),
                    subtitle: Text(user.email),

                    // Delete button
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, user.id),
                    ),

                    // Tap → go to detail page
                    onTap: () => context.push('/users/${user.id}'),
                  ),
                );
              },
            );
          }

          // Error
          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<UserBloc>().add(GetUsersEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Initial (nothing happened yet)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Shows a confirmation dialog before deleting
  void _confirmDelete(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<UserBloc>().add(DeleteUserEvent(userId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
