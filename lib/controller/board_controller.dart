import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum BlockState { snake, board, food }
enum Direction { left, right, top, bottom }

class BoardController extends ChangeNotifier {
  List<BlockState> board;
  List<int> snakePos = [43, 44, 45];
  Timer _ticker;

  Direction _direction = Direction.right;

  int _foodPos;

  static const MAX_BLOCKS = 110;
  static const BLOCKS_PER_ROW = 10;

  BoardController() : board = List.generate(MAX_BLOCKS, (index) => BlockState.board) {
    _ticker = Timer.periodic(Duration(seconds: 1), (timer) {
      _move();
    });
    snakePos.forEach((pos) {
      board[pos] = BlockState.snake;
    });
    _generateFood();
  }

  void changeDirection(Direction direction) {
    if (_direction == direction) return;
    if (_areOppositeDirections(_direction, direction)) return;
    _direction = direction;
  }

  bool _areOppositeDirections(Direction a, Direction b) {
    if (a == Direction.left && b == Direction.right || a == Direction.right && b == Direction.left) return true;
    if (a == Direction.top && b == Direction.bottom || a == Direction.bottom && b == Direction.top) return true;
    return false;
  }

  void _move() {
    int headPos = snakePos.last;
    int row = headPos ~/ BLOCKS_PER_ROW;
    int col = headPos % BLOCKS_PER_ROW;
    int lastCol = BLOCKS_PER_ROW - 1;
    int lastRow = MAX_BLOCKS ~/ BLOCKS_PER_ROW - 1;
    switch (_direction) {
      case Direction.left:
        col -= 1;
        if (col < 0) col = lastCol;
        break;
      case Direction.right:
        col += 1;
        if (col > lastCol) col = 0;
        break;
      case Direction.top:
        row -= 1;
        if (row < 0) row = lastRow;
        break;
      case Direction.bottom:
        row += 1;
        if (row > lastRow) row = 0;
        break;
    }
    int newPos = row * BLOCKS_PER_ROW + col;
    if (snakePos.contains(newPos)) {
      _handleGameOver();
      return;
    }
    snakePos.add(newPos);
    board[newPos] = BlockState.snake;

    if (newPos == _foodPos) {
      _generateFood();
    } else {
      board[snakePos.removeAt(0)] = BlockState.board;
    }
    notifyListeners();
  }

  void _generateFood() {
    var validBlocks = Set.from(List.generate(MAX_BLOCKS, (index) => index)).difference(Set.from(snakePos));
    var position = Random().nextInt(validBlocks.length);
    _foodPos = validBlocks.toList()[position];
    board[_foodPos] = BlockState.food;
    notifyListeners();
  }

  void _handleGameOver() {
    board = List.generate(MAX_BLOCKS, (index) => BlockState.board);
    _direction = Direction.right;
    snakePos = [43, 44, 45];
    snakePos.forEach((pos) {
      board[pos] = BlockState.snake;
    });
    _generateFood();
  }
}
