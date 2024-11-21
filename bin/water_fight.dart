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

class Player{
  String name;
  late List<List<String>> pole;
  late List<List<String>> gamePole;
  bool win = false;
  List<Ship> ships;
  int count = 0;
  int successAttack = 0;

  Player(this.name, int size, this.ships){
    pole = List.generate(size, (_) => List.filled(size, "[ ]"));
    gamePole = List.generate(size, (_) => List.filled(size, "[ ]"));
    for(var item in ships){
      count += item.size;
    }
  }

  void checkWin(){
    if(successAttack == count){
      
      win = true;
    }
  }

  String printPole(){
    String result = "";
    String header = "  ";
    for(int i = 1; i < pole.length+1; i++){
      header += " $i  ";
    }

  String gameHeader = "";
    for(int i = 1; i < gamePole.length+1; i++){
      gameHeader += " $i  ";
    }
    result += "$header    $gameHeader\n";
    for(int i = 0; i < pole.length; i++){
      result += "${i+1} ${pole[i].join(' ')}      ${gamePole[i].join(' ')}\n";
    }
    return result;
  }

  void placeShips(Ship ship, int x, int y, bool how){
    for(int i = 0; i < ship.size; i++){
      if(how){
        pole[x][y+i] = "[⛴️]";
      }else{
        pole[x+i][y] = "[⛴️]";
      }
      
    }
    print(printPole());
  }

  void placingShips(){
    for(int i = 0; i < ships.length; i++){
      print("Размещение корабля ${ships[i].name} ${"⛴️ "*ships[i].size}");
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
      placeShips(ships[i], xInputValue!-1, yInputValue!-1, how);
    }
  }
}

String attack(int x, int y, Player player1, Player player2){
  if(player1.pole[x][y] != "[ ]"){
    player2.gamePole[x][y] = "[X]";
    player2.successAttack++;
    player2.checkWin();
    return "Попал";
  }
  player2.gamePole[x][y] = "[0]";
  return "Промах";
}

void game(Player player1, Player player2){
  bool firstPlayer = true;

  while(!player1.win && !player2.win){
    print("Ход игрока: ${firstPlayer ? player1.name : player2.name}");
    String result;
    do{
      firstPlayer ? print(player1.printPole()) : print(player2.printPole());
      print("Введите координату X:");
      String? xInput = stdin.readLineSync();
      var xInputValue = int.tryParse(xInput!);

      print("Введите координату Y:");
      String? yInput = stdin.readLineSync();
      var yInputValue = int.tryParse(yInput!);

      result = attack(xInputValue!-1, yInputValue!-1, firstPlayer ? player2 : player1, firstPlayer ? player1 : player2);
      print(result);
    }while(result == "Попал" && !player1.win && !player2.win);
      

    firstPlayer = !firstPlayer;
    clean();
  }
  clean();
  print("Выиграл игрок: ${player1.win ? player1.name : player2.name}");
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
    
    print("Введите имя первого игрока:");
    String? nameFirst = stdin.readLineSync();
    Player player1 = Player(nameFirst!, size, ships);
    player1.placingShips();

    clean();

    print("Введите имя второго игрока:");
    String? nameSecond = stdin.readLineSync();
    Player player2 = Player(nameSecond!, size, ships);
    player2.placingShips();

    clean();


    game(player1, player2);
  }
}
