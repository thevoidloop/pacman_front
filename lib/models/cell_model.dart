class CellModel {
  bool isBlocked = false;
  List<List<int>> conexiones = [];

  void lockBox(flag) {
    if (flag) {
      isBlocked = flag;
      conexiones = [];
    }
  }

  void generarConexiones(int x, int y, int tamanoTablero, List<List<CellModel>> grid) {
    if (!isBlocked) {
      // Limpiar conexiones anteriores
      conexiones.clear();

      // Comprobar las celdas adyacentes
      if (x > 0) {
        // Celda a la izquierda
        if (!isCellBlocked(x - 1, y, tamanoTablero, grid)) {
          conexiones.add([x - 1, y]);
        }
      }
      if (x < tamanoTablero - 1) {
        // Celda a la derecha
        if (!isCellBlocked(x + 1, y, tamanoTablero, grid)) {
          conexiones.add([x + 1, y]);
        }
      }
      if (y > 0) {
        // Celda arriba
        if (!isCellBlocked(x, y - 1, tamanoTablero, grid)) {
          conexiones.add([x, y - 1]);
        }
      }
      if (y < tamanoTablero - 1) {
        // Celda abajo
        if (!isCellBlocked(x, y + 1, tamanoTablero, grid)) {
          conexiones.add([x, y + 1]);
        }
      }
    }
  }

  bool isCellBlocked(int x, int y, int tamanoTablero, List<List<CellModel>> grid) {
    return (x < 0 ||
        x >= tamanoTablero ||
        y < 0 ||
        y >= tamanoTablero ||
        (x == 0 && y == 0) ||
        (x == tamanoTablero - 1 && y == tamanoTablero - 1) ||
        grid[x][y].isBlocked);
  }
}
