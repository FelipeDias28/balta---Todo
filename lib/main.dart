import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskController = TextEditingController();

  void add() {
    if (newTaskController.text.isEmpty) return;

    setState(() {
      widget.items.add(
        Item(
          title: newTaskController.text,
          done: false,
        ),
      );

      newTaskController.clear();
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    // Sempre que acessa a dado, nem sempre é na hora, por isso async
    var prefs = await SharedPreferences
        .getInstance(); // instância do Shared Preferences
    var data = prefs.getString("data");

    if (data != null) {
      Iterable decoded = jsonDecode(data); // Faz o parse de String para Json
      List<Item> result = decoded
          .map((x) => Item.fromJson(x))
          .toList(); // Esse FromJson é da Nossa Model

      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskController,
          keyboardType: TextInputType.text, // Forma do teclado
          style: const TextStyle(
            // o estilo da letra que será digitado
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: const InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length, // Tamanho da lista em tempo de execução
        itemBuilder: (context, index) {
          // Como desenha esses itens na tela
          final item = widget.items[index];
          return Dismissible(
            key: Key(item.title ?? ''), // Não pode se repetir
            child: CheckboxListTile(
              value: item.done, // True ou false
              onChanged: (value) {
                setState(() {
                  item.done = value; // Altera o valor se esta preenchido ou não
                  save();
                });
              }, // retorna True ou false
              title: Text(item.title ?? ''),
            ),
            background: Container(
              // Foi utilizado Contaiuner pois ele ocupa todo o espaço disponível
              // conforme o item é arrastado
              color: Colors.red.withOpacity(0.2),
            ),
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        backgroundColor: Colors.pink[400],
        child: const Icon(Icons.add),
      ),
    );
  }
}
