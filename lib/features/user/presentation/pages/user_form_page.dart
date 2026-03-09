import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clean_architecture/features/user/domain/entities/user_entity.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_bloc.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_event.dart';
import 'package:clean_architecture/features/user/presentation/bloc/user_state.dart';

/// ============================================================
/// USER FORM PAGE — Create or Edit a user
/// ============================================================
///
/// 📌 TWO MODES:
/// - user == null  →  CREATE mode (empty form)
/// - user != null  →  EDIT mode (form pre-filled with user data)
///
/// 📌 DATA FLOW (Create):
/// User fills form → taps "Create" → dispatches CreateUserEvent
///   → BLoC → CreateUser UseCase → Repository → DataSource
///   → HTTP POST /users → success → BLoC emits UserSuccess
///   → Listener catches it → shows SnackBar → navigates back
///
/// 📌 DATA FLOW (Edit):
/// Same but uses UpdateUserEvent and HTTP PUT

class UserFormPage extends StatefulWidget {
  final UserEntity? user; // null = create, non-null = edit

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for the form fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  bool get isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    // If editing, pre-fill the fields with existing data
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks!
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Create User'),
        centerTitle: true,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            context.go('/users'); // Go back to list
          }
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a name';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter an email';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is UserLoading ? null : _submit,
                        child: state is UserLoading
                            ? const CircularProgressIndicator()
                            : Text(isEditing ? 'Update' : 'Create'),
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

  /// Validate and submit the form
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
        id: widget.user?.id ?? 0,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (isEditing) {
        context.read<UserBloc>().add(UpdateUserEvent(user));
      } else {
        context.read<UserBloc>().add(CreateUserEvent(user));
      }
    }
  }
}
