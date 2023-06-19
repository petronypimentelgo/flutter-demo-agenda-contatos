import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contatos_2/ui/home_page.dart';
import 'package:flutter/material.dart';

import '../model/contato.dart';

class AddContato extends StatefulWidget {
  const AddContato({Key? key}) : super(key: key);

  @override
  State<AddContato> createState() => _AddContatoState();
}

class _AddContatoState extends State<AddContato> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: const Text("Novo Contato"),
         centerTitle: true,
       ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            getTextField(hintText: "Nome", textInputType: TextInputType.text, controller: nomeController, focusNode: focusNode),
            getTextField(hintText: "E-mail", textInputType: TextInputType.emailAddress, controller: emailController),
            getTextField(hintText: "Telefone", textInputType: TextInputType.phone, controller: telefoneController),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Contato contato = Contato(name: nomeController.text, email: emailController.text, telefone: telefoneController.text);
                    addContatoAndNavigationHome(contato, context);
                }, child: Text("Salvar"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),),
                ElevatedButton(onPressed: () => {
                  nomeController.text = '',
                  emailController.text = '',
                  telefoneController.text = '',
                  focusNode.requestFocus()
                }, child: Text("Limpar"), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),)
              ],
            )
          ],          
        ),
      ),
    );
  }

  Widget getTextField(
        {
          required String hintText,
          TextInputType textInputType = TextInputType.name,
          required TextEditingController controller,
          FocusNode? focusNode
        }
      ) {
    return  Padding(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: 'Enter $hintText',
          labelText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5)
            ),
          ),
        ),
      ),
    );
  }

  void addContatoAndNavigationHome(Contato contato, BuildContext context) {
    final contatoRef = FirebaseFirestore.instance.collection('contatos').doc();
    contato.id = contatoRef.id;
    final data = contato.toJson();
    contatoRef.set(data).whenComplete((){
      log('User Inserted...');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}

