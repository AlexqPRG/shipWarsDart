import 'dart:io';

import 'package:water_fight/water_fight.dart' as water_fight;

void clean(){
  stdout.write('\x1B[2J\x1B[0;0H');
}

class Ship{
    String name;
    int size;

    Ship(this.name, this.size);
}

// class GameArea{
//   late List<List<String>> grid;
//   late List<Ship> ships;

//   GameArea(int size){
//     grid = List.generate(size, (_) => List.filled(size, "[ ]"));
//     ships = [];
//   }

//   void placeShips(Ship ship, int x, int y, bool how){
//     for(int i = 0; i < ship.size; i++){
//       grid[x][y+i] = "[⛴️]";
//     }
//     printArea();
//   }

//   void printArea(){
//     print("Поле:");
//     for (var row in grid){
//       print(row.join(' '));
//     }
//   }
// }

class Player{
  String name;
  late List<List<String>> pole;
  List<Ship> ships;

  Player(this.name, int size, this.ships){
    pole = List.generate(size, (_) => List.filled(size, "[ ]"));
  }

  void printPole(){
    print("Поле");
    for(var row in pole){
      print(row.join(' '));
    }
  }

  void placeShips(Ship ship, int x, int y, bool how){
    for(int i = 0; i < ship.size; i++){
      pole[x][y+i] = "[⛴️]";
    }
    printPole();
  }

  void placingShips(){
    for(int i = 0; i < ships.length; i++){
      print("Размещение корабля ${ships[i].name}");
      print("Введите координату X:");
      String? xInput = stdin.readLineSync();
      var xInputValue = int.tryParse(xInput!);

      print("Введите координату Y:");
      String? yInput = stdin.readLineSync();
      var yInputValue = int.tryParse(yInput!);

      print("Разместить корабль горизонтально? 1 - Да, 2 - Нет");
      String? howInput = stdin.readLineSync();
      var howInputValue = int.tryParse(howInput!);
      bool how = howInputValue == 1 ? true : false;
      placeShips(ships[i], xInputValue!, yInputValue!, how);
    }
  }


}



void main(List<String> arguments) {
  while(true){
    print("Выберите размер поля:\n1 - 8x8\n2 - 10x10\n3 - 14x14");
    String? input = stdin.readLineSync();

    var intInput = int.tryParse(input!);

    if(intInput! > 3 || intInput < 0){
      print("Вы ввели неверное значение!");
      continue;
    }
    late int size;
    switch (intInput){
      case 1:
        size = 8;
      case 2:
        size = 10;
      case 3:
        size = 14;
    }

    List<Ship> ships = [];
    ships.add(Ship("Аврора", 1));
    ships.add(Ship("Бисмарк", 2));
    ships.add(Ship("Титаник", 3));

    Player player1 = Player("First", size, ships);
    player1.placingShips();

    clean();
    Player player2 = Player("Second", size, ships);
    player2.placingShips();
    

    player1.printPole();
    print("ssssssssssssssssssssssssssssssssssssssss");
    player2.printPole();
  }
}
