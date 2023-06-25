import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:flutter/material.dart';

class BoardListView extends StatefulWidget {
  const BoardListView({super.key, required this.currentBoard});
  final String currentBoard;

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> {
  @override
  Widget build(BuildContext context) {
    final backend = Provider.of<Backend>(context);
    return FutureBuilder<List<Board>>(
      future: backend.fetchBoards(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          final List<Board> boards = snapshot.data!;
          final List<Board> sfwBoards =
              boards.where((board) => !board.nsfw).toList();
          final List<Board> nsfwBoards =
              boards.where((board) => board.nsfw).toList();
          final colorScheme = Theme.of(context).colorScheme;
          final nsfwColor = colorScheme.error;
          child = ListView(
            children: [
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  "General (SFW)",
                  style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700),
                ),
                children: _boardListTiles(context, sfwBoards),
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text(
                  "Adult (NSFW 18+)",
                  style: TextStyle(
                      fontSize: 16,
                      color: nsfwColor,
                      fontWeight: FontWeight.w700),
                ),
                children: _boardListTiles(context, nsfwBoards),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          child = const Column(
            children: [
              ListTile(
                leading: Icon(Icons.error_outline),
                title: Text(
                  'Sorry, we could not fetch boards! Try checking if you are connected to the internet',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        } else {
          child = ListView(
            children: const [
              ListTile(
                leading: CircularProgressIndicator(),
                title: Text(
                  'Loading list of Boards! Please wait!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        }
        return Expanded(child: child);
      },
    );
  }

  List<Widget> _boardListTiles(BuildContext context, List<Board> boards) {
    return boards.map(
      (board) {
        final colorScheme = Theme.of(context).colorScheme;
        final nsfwColor = colorScheme.error;
        final onNsfwColor = colorScheme.onError;
        final MaterialColor primaryColor = colorScheme.primary as MaterialColor;
        final onPrimary = colorScheme.onPrimary;
        final shade = 500 + Random().nextInt(4) * 100;
        final boardName = board.name;
        final boardTitle = board.title;
        final bool isSelected = boardName == widget.currentBoard;
        return ListTile(
          selected: isSelected,
          selectedColor: colorScheme.onBackground,
          selectedTileColor: primaryColor.shade100,
          leading: CircleAvatar(
            backgroundColor: board.nsfw ? nsfwColor : primaryColor[shade],
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '/$boardName/',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: board.nsfw ? onNsfwColor : onPrimary),
                ),
              ),
            ),
          ),
          title: Text(boardTitle),
          onTap: () {
            context.go('/board/$boardName');
            context.pop();
          },
        );
      },
    ).toList();
  }
}
