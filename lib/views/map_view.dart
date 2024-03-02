import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman_front/main.dart';
import 'package:pacman_front/models/cell_model.dart';
import 'package:pacman_front/models/graph_model.dart';
import 'package:pacman_front/services/api_service.dart';
import 'package:pacman_front/views/winner_view.dart';

class BombermanBoard extends StatefulWidget {
  final List<List<CellModel>> grid;

  const BombermanBoard({super.key, required this.grid});

  @override
  //TODO
  // ignore: no_logic_in_create_state
  State<BombermanBoard> createState() => _BombermanBoardState(grid: grid);
}

class _BombermanBoardState extends State<BombermanBoard> {
  final List<List<CellModel>> grid;
  late List<int> objetivo = [7, 5];
  late List<int> inicio = [1, 1];
  var isWinner = false;
  final ApiService api = ApiService();

  _BombermanBoardState({required this.grid});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeCell = ((size.height * 0.7) / grid.length);
    final positionedWidthBegin = (size.width - (size.height * 0.7)) / 2;
    final positionedHeightBegin = (size.height - (size.height * 0.7)) / 2;

    return StreamBuilder<GraphModel>(
      stream: api.graphDataStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          inicio = snapshot.data!.nodoActual;
          if (!isWinner) {
            developer.log(inicio.toString(), name: "Nodo Examinado");
            developer.log(objetivo.toString(), name: "Nodo Objetivo");
            developer.log(snapshot.data!.stack.toString(), name: "Pila");
            developer.log("-------------------------------------------------------");
          }
          if ((inicio[0] == objetivo[0]) && (inicio[1] == objetivo[1])) isWinner = true;
          if (isWinner) {
            return WinnerCard(
              onPressedCallback: () {
                reiniciarGrid();
              },
            );
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              ..._buildGridCells(context),
              Positioned(
                left: (objetivo[1] * sizeCell) + positionedWidthBegin,
                top: (objetivo[0] * sizeCell) + positionedHeightBegin,
                child: Container(
                  width: sizeCell,
                  height: sizeCell,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('objetivo.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (inicio[1] * sizeCell) + positionedWidthBegin,
                top: (inicio[0] * sizeCell) + positionedHeightBegin,
                child: Container(
                  width: sizeCell,
                  height: sizeCell,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('inicio.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  List<Widget> _buildGridCells(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeCell = ((size.height * 0.7) / grid.length);
    final positionedWidthBegin = (size.width - (size.height * 0.7)) / 2;
    final positionedHeightBegin = (size.height - (size.height * 0.7)) / 2;

    List<Widget> cells = [];
    AssetImage image;

    // Construir las celdas del tablero
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[row].length; col++) {
        if (grid[row][col].isBlocked) {
          image = const AssetImage('stoneWall.png');
        } else {
          image = const AssetImage('particleBoard.png');
        }
        cells.add(
          Positioned(
            left: (col * sizeCell) + positionedWidthBegin, // Ajusta el tamaño de la celda
            top: (row * sizeCell) + positionedHeightBegin, // Ajusta el tamaño de la celda
            child: GestureDetector(
              onTap: () {
                grid[row][col].isBlocked = !grid[row][col].isBlocked;
                generarConexionesTablero(grid, api, inicio);
              },
              child: Container(
                width: sizeCell,
                height: sizeCell,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.black),
                  // color: cell.isOccupied ? Colors.blue : Colors.white,
                ),
                // Aquí puedes agregar cualquier contenido adicional a la celda
              ),
            ),
          ),
        );
      }
    }
    return cells;
  }

  void reiniciarGrid() async {
    var random = Random();
    for (var fila in grid) {
      fila.clear();
    }
    grid.clear();

    grid.addAll(
      List.generate(
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
      ),
    );

    isWinner = false;
    inicio = [5, 5];

    objetivo = [2 + random.nextInt(5), 1 + random.nextInt(6)];
    final bodyConfiguration = await api.generarConfiguracion(9, 9, inicio, grid);
    await api.graphConf(bodyConfiguration);
  }
}
