import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PracticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App Using Hive"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: Hive.openBox("fileone"),
              builder: (context,snapshot){
            return Column(
              children: [
                ListTile(
                  title: Text(snapshot.data!.get("name").toString()),
                  subtitle: Text(snapshot.data!.get("age").toString()),
                  leading: Text(snapshot.data!.get("list")["pro"].toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      snapshot.data!.put('name', "Aswin George Thomas");
                      snapshot.data!.delete("age");
                      snapshot.data!.put("list", {
                        "pro":'Flutter Developer'
                      });
                      setState(() {});
                    },
                  ),
                ),
              ],
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("fileone");
          var box2 = await Hive.openBox("filetwo");
          box2.put("college", "College of Engineering,Aranmula");
          box.put("name", "Aswin George Thomas");
          box.put("age", 21);
          box.put("list", {
            "pro":'flutter',
            'cash': 2345,
          });
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
