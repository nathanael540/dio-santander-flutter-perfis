import 'package:contatos/src/classes/contato.dart';
import 'package:dio/dio.dart';

class ContatoService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://parseapi.back4app.com/classes',
      // Headers
      headers: {
        'X-Parse-Application-Id': "fkE4pxnUSo9VNeKwhnHKXZJRJQqPVbSXBqlKjP1O",
        'X-Parse-REST-API-Key': "RmzeHbSXL1TskT7zW9mbf7ILYHl5OmTuMd2Xjejt",
      },
    ),
  );

  Future<bool> addContato(Contato contato) async {
    try {
      await _dio.post('/Contato', data: contato.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateContato(Contato contato) async {
    try {
      await _dio.put('/Contato/${contato.id}', data: contato.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteContato(String id) async {
    try {
      await _dio.delete('/Contato/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Contato>> getAll() async {
    try {
      Response response = await _dio.get('/Contato');

      List<Contato> contatos = [];

      if (response.data['results'] != null &&
          response.data['results'] is List) {
        contatos = response.data['results']
            .map<Contato>(
              (e) => Contato.fromMap(e),
            )
            .toList();
      }

      return contatos;
    } catch (e) {
      return [];
    }
  }
}
