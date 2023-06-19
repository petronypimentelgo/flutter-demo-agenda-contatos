import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmação'),
      content: Text('Deseja confirmar a ação?'),
      actions: <Widget>[
        TextButton(
          child: Text('Não'),
          onPressed: () {
            // Ação a ser executada quando o botão "Não" for pressionado
            Navigator.of(context).pop(false); // Fecha o diálogo e retorna false
          },
        ),
        TextButton(
          child: Text('Sim'),
          onPressed: () {
            // Ação a ser executada quando o botão "Sim" for pressionado
            Navigator.of(context).pop(true); // Fecha o diálogo e retorna true
          },
        ),
      ],
    );
  }
}
