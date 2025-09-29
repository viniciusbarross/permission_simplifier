import 'package:flutter/material.dart';
import '../permission_simplifier_manager.dart';

/// A basic dialog widget to inform the user when a permission has been
/// permanently denied and needs to be activated in the system settings.
class SimpleDeniedAlert extends StatelessWidget {
  final String title;
  final String content;

  const SimpleDeniedAlert({
    super.key,
    this.title = 'Permissão Necessária',
    this.content =
        'A permissão foi negada permanentemente. Por favor, vá para as Configurações do App para ativá-la manualmente.',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCELAR'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            PermissionSimplifierManager.openSettings();
          },
          child: const Text('ABRIR CONFIGURAÇÕES'),
        ),
      ],
    );
  }
}
