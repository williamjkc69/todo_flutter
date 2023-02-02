import 'package:flutter/material.dart';
import 'package:todo_flutter/helpers/utils.dart';
import 'package:todo_flutter/services/todo_servce.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  var todoItem;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      final item = widget.todo as Map;
      isEdit = true;
      todoItem = item;
      titleController.text = item['title'];
      descriptionController.text = item['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${isEdit ? 'Edit' : 'Add'} Todo")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) return;

    final id = todo['_id'];
    final isCompleted = todo['is_completed'];

    final isSuccess = await TodoService.updateData(id, body);

    (isSuccess)
        ? showSuccessMessage(context, message: 'Update Success')
        : showErrorMessage(context, message: 'Update Failed');
  }

  Future<void> submitData() async {
    const url = '/v1/todos';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.submitData(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';

      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failed');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
