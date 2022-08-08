import 'package:flutter/material.dart';

import 'models/item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = <Item>[];

  HomePage() {
    items.add(Item(title: "Item 1", done: false));
    items.add(Item(title: "Item 2", done: true));
    items.add(Item(title: "Item 3", done: false));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: ListView.builder(
        itemCount: widget.items.length, // Tamanho da lista em tempo de execução
        itemBuilder: (context, index) {
          // Como desenha esses itens na tela
          final item = widget.items[index];
          return CheckboxListTile(
            value: item.done, // True ou false
            onChanged: (value) {}, // retorna True ou false
            title: Text(item.title ?? ''),
            key: Key(item.title ?? ''), // Não pode se repetir
          );
        },
      ),
    );
  }
}
