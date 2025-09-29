import 'package:flutter/material.dart';
import 'package:permission_simplifier/permission_simplifier.dart';
// ignore: depend_on_referenced_packages

void main() {
  // Always ensure Flutter bindings are initialized before calling platform-specific code.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PermissionExampleApp());
}

/// The main application widget, providing the MaterialApp context.
class PermissionExampleApp extends StatelessWidget {
  const PermissionExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Permissions Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PermissionScreen(),
    );
  }
}

/// The screen where the permission logic and UI feedback reside.
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  String _statusMessage = 'Aguardando requisição...';
  bool _locationGranted = false;

  /// Handles the permission request and updates the UI based on the result.
  Future<void> _requestLocation() async {
    setState(() {
      _statusMessage = 'Requisitando permissão de Localização...';
    });

    // 1. Chama o Manager do seu pacote
    final result = await PermissionSimplifierManager.request(
      Permission.location,
    );

    // 2. Trata o resultado
    if (result.isGranted) {
      setState(() {
        _statusMessage = '✅ Permissão de Localização CONCEDIDA!';
        _locationGranted = true;
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Localização concedida!')));
    } else if (result.requiresSettingsOpen) {
      // 3. Permissão Negada Permanentemente - Mostra o diálogo de alerta
      setState(() {
        _statusMessage =
            '❌ Permissão Negada Permanentemente. Necessário Configurações.';
        _locationGranted = false;
      });

      // Chamando o SimpleDeniedAlert dentro do contexto de Scaffold
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => const SimpleDeniedAlert(),
      );
    } else {
      // 4. Permissão Negada (temporariamente)
      setState(() {
        _statusMessage =
            '⚠️ Permissão de Localização NEGADA (Tente novamente).';
        _locationGranted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O Scaffold é o ancestral necessário para o ScaffoldMessenger funcionar
      appBar: AppBar(
        title: const Text('Simple Permissions Demo'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.location_on, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _requestLocation,
                icon: const Icon(Icons.search),
                label: const Text('Requisitar Localização'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: _locationGranted
                      ? Colors.green.shade600
                      : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
