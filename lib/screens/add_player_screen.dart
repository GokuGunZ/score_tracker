import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/player.dart';
import '../services/player_service.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({Key? key}) : super(key: key);

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _playerService = PlayerService();

  bool _isSubmitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final uuid = const Uuid().v4();
      final newPlayer = Player(id: uuid, name: _nameController.text.trim());

      await _playerService.createPlayer(newPlayer);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 650),
          content: Text('Giocatore creato!')),
      );

      Navigator.pop(context); // Torna alla schermata precedente
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aggiungi Giocatore')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Giocatore',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Inserisci un nome valido'
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Crea Giocatore'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}