import 'dart:async';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:pacman_front/models/cell_model.dart';
import 'dart:convert';
import 'package:pacman_front/models/graph_model.dart';

class ApiService {
  final path = 'http://localhost:5000';

  Future<GraphModel> graphSearch() async {
    final url = Uri.parse('$path/dfs_tablero');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'op': 'Next'}),
    );
    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);
      return GraphModel.fromJson(data);
    } else {
      throw Exception('Error al cargar el grafo');
    }
  }

  Future<void> graphConf(String body) async {
    final url = Uri.parse('$path/conf');

    developer.log("Nueva configuracion enviada");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Stream<GraphModel> graphDataStream() async* {
    // Utilizamos async* para crear un generador asíncrono
    while (true) {
      try {
        final graph = await graphSearch();
        yield graph;
      } catch (e) {
        // Manejo de errores
        developer.log('Error: $e');
        // Puedes emitir un error al Stream si lo deseas
        // throw e;
      }
      // Esperamos 45 segundos antes de realizar la próxima búsqueda
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<String> generarConfiguracion(int noFilas, int noColums, List<int> inicio, List<List<CellModel>> grid) async {
    final Map<String, dynamic> jsonMap = {
      "noFilas": noFilas,
      "noColums": noColums,
      "inicio": inicio,
      "conexiones": [],
    };

    for (int i = 0; i < noFilas; i++) {
      for (int j = 0; j < noColums; j++) {
        final cell = grid[i][j];
        final List<List<int>> conexiones = [];

        if (!cell.isBlocked) {
          for (final conexion in cell.conexiones) {
            final fila = conexion[0];
            final columna = conexion[1];
            conexiones.add([fila, columna]);
          }

          jsonMap["conexiones"].add({
            "nodo": [i, j],
            "conexiones": conexiones,
          });
        }
      }
    }

    return json.encode(jsonMap);
  }
}
