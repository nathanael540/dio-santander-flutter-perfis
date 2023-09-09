import 'dart:io';
import 'package:contatos/src/services/contato_service.dart';
import 'package:contatos/src/views/pages/home_page.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:contatos/src/classes/contato.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEditPage extends StatefulWidget {
  final Contato? contato;

  const AddEditPage({super.key, this.contato});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  bool get isEdit => widget.contato != null;

  Contato contatoLocal = Contato(
    nome: '',
    telefone: '',
    foto: '',
  );
  bool get contatoTemFoto => contatoLocal.foto.isNotEmpty;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEdit) {
        setState(() {
          contatoLocal = widget.contato!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar contato' : 'Adicionar contato'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(
                backgroundImage: contatoTemFoto
                    ? FileImage(File(
                        contatoLocal.foto,
                      ))
                    : null,
                radius: 64,
                child: !contatoTemFoto
                    ? const Icon(
                        Icons.person,
                        size: 64,
                      )
                    : null,
              ),
              TextButton(
                onPressed: _changeFoto,
                child: Text(isEdit ? "Trocar foto" : 'Adicionar foto'),
              ),
              TextField(
                controller: TextEditingController(text: contatoLocal.nome),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                onChanged: (value) {
                  contatoLocal.nome = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: contatoLocal.telefone),
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                ),
                onChanged: (value) {
                  contatoLocal.telefone = value;
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isEdit ? _editContato : _addContato,
                child: Text(isEdit ? 'Editar' : 'Adicionar'),
              ),
            ],
          ),
          if (loading)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _addContato() async {
    if (contatoLocal.nome.isEmpty || contatoLocal.telefone.isEmpty) {
      if (!mounted) return;
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
              'Preencha todos os campos.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      loading = true;
    });

    final added = await ContatoService().addContato(contatoLocal);

    setState(() {
      loading = false;
    });

    if (added) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar contato!'),
        ),
      );
    }
  }

  void _editContato() async {
    if (contatoLocal.nome.isEmpty || contatoLocal.telefone.isEmpty) {
      if (!mounted) return;
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
              'Preencha todos os campos.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      loading = true;
    });

    final edited = await ContatoService().updateContato(contatoLocal);

    setState(() {
      loading = false;
    });

    if (edited) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao editar contato!'),
        ),
      );
    }
  }

  Future<bool> _getPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    // Android 13+
    if (await Permission.photos.request().isGranted) {
      return true;
    }

    return false;
  }

  void _changeFoto() async {
    final bool permission = await _getPermission();

    if (!permission) {
      if (!mounted) return;
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Permissão negada'),
            content: const Text(
              'Para adicionar uma foto, é necessário dar permissão de acesso ao armazenamento.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha uma opção'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Câmera'),
                onTap: () {
                  _getFoto(isCamera: true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Galeria'),
                onTap: () {
                  _getFoto(isCamera: false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _getFoto({bool isCamera = false}) async {
    setState(() {
      loading = true;
    });

    CroppedFile? image;
    XFile? file = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    setState(() {
      loading = false;
    });

    if (file == null) return;

    setState(() {
      loading = true;
    });

    image = await ImageCropper().cropImage(
      sourcePath: file.path,
      maxWidth: 500,
      maxHeight: 500,
      compressQuality: 70,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cortar imagem',
          toolbarColor: Colors.pink,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.pink,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );

    setState(() {
      loading = false;
    });

    if (image == null) return;

    _saveFoto(image);
  }

  void _saveFoto(CroppedFile image) async {
    setState(() {
      loading = true;
    });

    final response = await ImageGallerySaver.saveImage(
      await image.readAsBytes(),
    );

    setState(() {
      loading = false;
    });

    if (response['isSuccess']) {
      if (!mounted) return;
      setState(() {
        contatoLocal.foto = image.path;
      });
    } else {
      if (!mounted) return;
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
              'Não foi possível salvar a foto.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }
}
