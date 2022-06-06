import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Todo
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  String _selectedDate = DateFormat.yMd().format(DateTime.now());
  String _startDate = DateFormat('hh:mm a').format(DateTime.now());
  String _endDate =
      DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15)));

  int _selectedReminder = 5;
  List<int> reminderList = [5, 10, 15, 20];

  String _repeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
