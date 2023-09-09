import 'package:contatos/src/classes/contato.dart';
import 'package:contatos/src/services/contato_service.dart';
import 'package:contatos/src/views/components/contato_tile.dart';
import 'package:contatos/src/views/pages/add_edit_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: ContatoService().getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Contato> contatos = snapshot.data as List<Contato>;

          if (contatos.isEmpty) {
            return const Center(
              child: Text('Nenhum contato cadastrado'),
            );
          }

          return ListView.builder(
            itemCount: contatos.length,
            itemBuilder: (context, index) {
              return ContatoTile(
                contato: contatos[index],
              );
            },
          );
        },
      ),
    );
  }
}
