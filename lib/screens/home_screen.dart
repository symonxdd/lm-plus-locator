import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();

  void _findNearestOffices() {
    // TODO: request location and show the nearest LM+ offices.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LM+ Locator'),
        actions: [
          IconButton(
            onPressed: _authService.signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Uitloggen',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We gebruiken je locatie enkel om het dichtstbijzijnde '
                'kantoor te vinden. Je locatie wordt nooit opgeslagen of '
                'gedeeld.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _findNearestOffices,
                icon: const Icon(Icons.my_location),
                label: const Text('Vind mijn dichtstbijzijnde LM+ kantoor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
