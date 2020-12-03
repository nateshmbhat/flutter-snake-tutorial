import 'package:flutter/material.dart';
import 'package:flutter_snake/controller/board_controller.dart';
import 'package:provider/provider.dart';

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(create: (_) => BoardController(), child: Board()),
    );
  }
}

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<BoardController>(context);
    return Column(
      children: [
        GridView.count(
            shrinkWrap: true,
            crossAxisCount: BoardController.BLOCKS_PER_ROW,
            children: controller.board
                .asMap()
                .map(
                  (index, block) => MapEntry(
                    index,
                    Block(
                      index: index,
                      state: block,
                    ),
                  ),
                )
                .values
                .toList()),
        Expanded(child: GameControllerButtons())
      ],
    );
  }
}

class Block extends StatelessWidget {
  final BlockState state;
  final int index;
  final int row, col;

  const Block({Key key, @required this.state, @required this.index})
      : row = index ~/ BoardController.BLOCKS_PER_ROW,
        col = index % BoardController.BLOCKS_PER_ROW,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BlockState.snake:
        return Container(
          color: Colors.black54,
        );
      case BlockState.board:
        return drawBoard();
      case BlockState.food:
        return Container(
          color: Colors.red,
        );
    }
    return Container();
  }

  Widget drawBoard() {
    return Container(
      height: 100,
      width: 100,
      color: col % 2 == 0
          ? (row % 2 == 0 ? Colors.green : Colors.lightGreen)
          : (row % 2 == 0 ? Colors.lightGreen : Colors.green),
      child: Center(child: Text('$index')),
    );
  }
}

class GameControllerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<BoardController>(context, listen: false);
    return LayoutBuilder(
      builder: (context, size) {
        return Column(
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  controller.changeDirection(Direction.top);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Top')],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          controller.changeDirection(Direction.left);
                        },
                        child: Text('Left'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          controller.changeDirection(Direction.right);
                        },
                        child: Text('Right'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  controller.changeDirection(Direction.bottom);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('bottom'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
