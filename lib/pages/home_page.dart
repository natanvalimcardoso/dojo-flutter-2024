import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<String> listDojo = [];
  SharedPreferences? prefs;

  removeItem({required int index}) {
    setState(() {
      listDojo.removeAt(index);
      prefs?.setStringList('listaDojo', listDojo);
    });
  }

  addItem({required String item}) async {
    if (item.isNotEmpty) {
      setState(() {
        listDojo.add(item);
        prefs?.setStringList('listaDojo', listDojo);
        controller.clear();
      });
    }
  }

  getItem() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      listDojo = prefs?.getStringList('listaDojo') ?? [];
    });
    print(listDojo);
  }

  @override
  void initState() {
    getItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addItem(item: controller.text);
            },
            child: const Text('Criar'),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listDojo.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(listDojo[index]),
                    trailing: IconButton(
                      onPressed: () {
                        removeItem(index: index);
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
