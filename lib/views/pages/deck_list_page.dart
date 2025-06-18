import 'package:flutter/widgets.dart';

class DeckListPage extends StatefulWidget {
  const DeckListPage({super.key});

  @override
  State<DeckListPage> createState() => _DeckListPageState();
}

class _DeckListPageState extends State<DeckListPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("card"),
    );
  }
}