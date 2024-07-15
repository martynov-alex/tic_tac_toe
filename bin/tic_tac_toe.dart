import 'dart:io';

// фигуры в клетке поля
const int empty = 0;
const int cross = 1;
const int nought = 2;
// состояние игрового процесса
const int playing = 0;
const int draw = 1; // ничья
const int crossWin = 2; // победа Х
const int noughtWin = 3; // победа О
const int quit = 3;

void main() {
  late List<List<int>> board;
  int boardSize = 3; // размер игрового поля по умолчанию
  int state = playing;
  int currentPlayer = cross; // текущий игрок

  // Создание игрового поля от 3х3 до 9х9
  while (true) {
    stdout.write('Enter the size of the board (3-9): ');
    final readSize = stdin.readLineSync();
    if (readSize == null) continue;

    int? size = int.tryParse(readSize);
    size ??= boardSize;

    if (size < 3 || size > 9) {
      print('The size should be in the range 3-9');
      continue;
    }

    boardSize = size;
    board = List.generate(
      boardSize,
      (_) => List.filled(boardSize, empty),
    );
    break;
  }

  // Вывод в терминал состояния игрового поля
  stdout.write('  ');

  for (int i = 0; i < boardSize; i++) {
    stdout.write('${i + 1} '); // Вывод номера столбца
  }
  stdout.writeln();

  for (int i = 0; i < boardSize; i++) {
    stdout.write('${i + 1} '); // Вывод номера строки

    for (int j = 0; j < boardSize; j++) {
      switch (board[i][j]) {
        case empty:
          stdout.write('. ');
        case cross:
          stdout.write('X ');
        case nought:
          stdout.write('O ');
      }
    }

    stdout.writeln();
  }

  while (state == playing) {
    final buffer = StringBuffer();
    buffer.writeln("${currentPlayer == cross ? 'X' : 'O'}'s turn.");
    buffer.write('Enter row and column (e.g. 1 2): ');
    stdout.write(buffer.toString());

    bool validInput = false;

    int? x, y;

    while (!validInput) {
      final input = stdin.readLineSync();
      if (input == null) {
        stdout.writeln('Invalid input. Please try again: ');
        continue;
      }
      if (input == 'q') {
        state = quit;
        break;
      }
      final coordinates = input.split(' ');
      if (coordinates.length != 2) {
        stdout.write('Invalid input. Please try again: ');
        continue;
      }
      x = int.tryParse(coordinates[0]);
      y = int.tryParse(coordinates[1]);
      if (x == null || y == null) {
        stdout.write('Invalid input. Please try again: ');
        continue;
      }
      if (x < 1 || x > boardSize || y < 1 || y > boardSize) {
        stdout.write('Invalid input. Please try again: ');
        continue;
      }

      x -= 1;
      y -= 1;
      if (board[x][y] == empty) {
        board[x][y] = currentPlayer;
        // Поиск наличия выигрышной комбинации
        // Проверка по строкам и столбцам
        bool winFound = false;
        for (int i = 0; i < boardSize; i++) {
          if (board[i].every((cell) => cell == currentPlayer)) {
            winFound = true;
            break;
          }
          if (board.every((row) => row[i] == currentPlayer)) {
            winFound = true;
            break;
          }
        }

        // Проверка по диагоналям
        if (!winFound) {
          if (List.generate(boardSize, (i) => board[i][i])
              .every((cell) => cell == currentPlayer)) {
            winFound = true;
          }
        }

        // Проверка по обратной диагонали
        if (!winFound) {
          if (List.generate(boardSize, (i) => board[i][boardSize - i - 1])
              .every((cell) => cell == currentPlayer)) {
            winFound = true;
          }
        }

        // Определение победителя
        if (winFound) {
          state = currentPlayer == cross ? crossWin : noughtWin;
        } // Проверка на ничью
        else if (board.every((row) => row.every((cell) => cell != empty))) {
          state = draw;
        }

        // Вывод в терминал состояния игрового поля
        stdout.write('  ');
        for (int i = 0; i < boardSize; i++) {
          stdout.write('${i + 1} '); // Вывод номера столбца
        }
        stdout.writeln();
        for (int i = 0; i < boardSize; i++) {
          stdout.write('${i + 1} '); // Вывод номера строки
          for (int j = 0; j < boardSize; j++) {
            switch (board[i][j]) {
              case empty:
                stdout.write('. ');
              case cross:
                stdout.write('X ');
              case nought:
                stdout.write('O ');
            }
          }
          stdout.writeln();
        }

        switch (state) {
          case crossWin:
            stdout.writeln('X wins!');
          case noughtWin:
            stdout.writeln('O wins!');
          case draw:
            stdout.writeln('Draw!');
          default:
            break;
        }

        // Смена хода
        currentPlayer = (currentPlayer == cross) ? nought : cross;
        validInput = true;
      } else {
        stdout.write('This cell is already occupied! Please try again: ');
      }
    }
  }
}
