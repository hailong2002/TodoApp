import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'model.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  String function = '';


  Future<void> _addDialog() async{
    final globalKey = GlobalKey<FormState>();
    TextEditingController textController = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: AlertDialog(
            title: const Text('Add a task', style: TextStyle(fontSize: 25)),
            content: Form(
              key: globalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                TextFormField(
                      controller: textController,
                      style: const TextStyle(fontSize: 20),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task';
                        }
                        return null;
                      }
                    ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              if(globalKey.currentState!.validate()){
                                Provider.of<Todo>(context, listen: false).addData(textController.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add',style: TextStyle(fontSize: 18))
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            child: const Text('Cancel', style: TextStyle(fontSize: 18))
                        )
                      ],
                    ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _editDialog(String task, int index) async{
    TextEditingController textController = TextEditingController(text: task);
    final globalKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: AlertDialog(
            title: const Text('Edit task', style: TextStyle(fontSize: 25)),
            content: Form(
              key: globalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: textController,
                    style: const TextStyle(fontSize: 20),
                    validator: (value){
                      if(value == null || value.isEmpty){
                          return 'Please enter a task';
                        }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              if(globalKey.currentState!.validate()){
                                Provider.of<Todo>(context, listen: false).editData(index, textController.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Edit', style: TextStyle(fontSize: 18))
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            child: const Text('Cancel', style: TextStyle(fontSize: 18))
                        )
                      ],
                    ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteDialog(int index) async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: AlertDialog(
            title: const Text('Confirm delete', style: TextStyle(fontSize: 25, color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure want to delete?',style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ElevatedButton(
                      onPressed: (){
                        Provider.of<Todo>(context, listen: false).deleteData(index);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete', style: TextStyle(fontSize: 18))
                  ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Cancel', style: TextStyle(fontSize: 18))
                  )
                ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

    void showTaskDetails(String task){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Task Details', style: TextStyle(fontSize: 25)),
              content: Text(task,style: const TextStyle(fontSize: 20 )),
            );

          }
      );
    }



  @override
  Widget build(BuildContext context) {

    var todo = Provider.of<Todo>(context);
    todo.loadData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('To do list'),
        actions: [
          IconButton(onPressed: _addDialog, icon: const Icon(Icons.add_rounded, size: 25))
        ],
      ),
      body: Container(
        child: todo.todoList.isEmpty ? const Center(child: Text('You have nothing to do', style: TextStyle(fontSize: 27))) :
         ListView.builder(
              itemCount: todo.todoList.length,
              itemBuilder: (context, index){
                  return ListTile(
                    title: Text(todo.todoList[index],
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                    ),
                    onTap: (){
                      showTaskDetails(todo.todoList[index]);
                      },
                    leading: Text('${index+1}.', style: const TextStyle(fontSize: 20)),
                    trailing: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue,),
                              onPressed: (){
                                _editDialog(todo.todoList[index], index);
                          }),
                          const SizedBox(width: 10),
                          IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: (){
                                _deleteDialog(index);
                              }
                          ),
                        ],
                      ),
                    ),
                  );
              }

              )


      )
    );


  }
}
