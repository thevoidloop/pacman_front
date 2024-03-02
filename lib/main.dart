import 'package:flutter/material.dart';
import 'package:pacman_front/models/cell_model.dart';
import 'package:pacman_front/services/api_service.dart';
import 'package:pacman_front/views/map_view.dart';

void main() {
  final List<List<CellModel>> grid = List.generate(
    9, // Número de filas
    (i) => List.generate(
      9, // Número de columnas
      (j) {
        final temp = CellModel();
        if ((i == 0) || (j == 0) || (i == 8) || (j == 8)) {
          temp.isBlocked = true;
        }
        return temp;
      },
    ),
  );

  final List<int> objetivo = [8, 8];
  final List<int> inicio = [1, 1];
  runApp(MyApp(
    grid: grid,
    objetivo: objetivo,
    inicio: inicio,
  ));
}

class MyApp extends StatelessWidget {
  final List<List<CellModel>> grid;
  final List<int> objetivo;
  final List<int> inicio;
  final api = ApiService();

  MyApp({super.key, required this.grid, required this.objetivo, required this.inicio});

  @override
  Widget build(BuildContext context) {
    generarConexionesTablero(grid, api, inicio);
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Profundidad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: BombermanBoard(
            grid: grid,
          ),
        ),
      ),
    );
  }
}

void generarConexionesTablero(List<List<CellModel>> grid, ApiService api, List<int> inicio) async {
  for (int row = 0; row < 9; row++) {
    for (int col = 0; col < 9; col++) {
      grid[row][col].generarConexiones(row, col, 9, grid);
    }
  }

  final bodyConfiguration = await api.generarConfiguracion(9, 9, inicio, grid);
  await api.graphConf(bodyConfiguration);
}
