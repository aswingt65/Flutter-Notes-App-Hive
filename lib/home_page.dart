import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_notes_app/boxes/boxes.dart';
import 'package:hive_notes_app/models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App Using Hive"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return SizedBox(
                  height: 100,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  delete(data[index]);
                                },
                                  child: const Icon(Icons.delete, color: Colors.red,)
                              ),
                              const SizedBox(width: 15,),
                              InkWell(
                                onTap: () {
                                  _editMyDialog(data[index], data[index].title.toString(), data[index].description.toString());
                                },
                                  child: const Icon(Icons.edit, color: Colors.blue,)
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Text(data[index].description.toString(), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500 ),),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Add NOTES"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter Title",
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: "Enter Description",
                    border: OutlineInputBorder()
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){

            Navigator.pop(context);}, child: const Icon(Icons.cancel, color: Colors.red,)),
          TextButton(onPressed: (){
            final data = NotesModel(title: titleController.text, description: descriptionController.text);
            final box = Boxes.getData();
            box.add(data);
            data.save();
            titleController.clear();
            descriptionController.clear();
            Navigator.pop(context);}, child: const Icon(Icons.add_circle, color: Colors.green,))
        ],
      );
    });
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editMyDialog(NotesModel notesModel, String title, String description ) async {

    titleController.text = title;
    descriptionController.text = description;

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Edit NOTES"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "Enter Title",
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: "Enter Description",
                    border: OutlineInputBorder()
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){

            Navigator.pop(context);}, child: const Icon(Icons.cancel, color: Colors.red,)),
          TextButton(onPressed: () async {

            notesModel.title = titleController.text.toString();
            notesModel.description = descriptionController.text.toString();
            notesModel.save();
            titleController.clear();
            descriptionController.clear();

            Navigator.pop(context);}, child: const Icon(Icons.edit_note, color: Colors.green,))
        ],
      );
    });
  }

}