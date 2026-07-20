import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardProvider>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    if (provider.loading) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: provider.users.length,
      itemBuilder: (context, index) {
        final user = provider.users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: Chip(label: Text(user.role)),
        );
      },
    );
  }
}
