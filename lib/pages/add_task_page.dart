import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/common/utils/theme.dart';
import 'package:to_do_app/common/widgets/button.dart';
import 'package:to_do_app/common/widgets/input_field.dart';

import '../common/utils/colors.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "11:55 PM";
  String _startTime = DateFormat("hh:mm a")
      .format(
        DateTime.now(),
      )
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [
    1,
    2,
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
  ];

  int _selectedColor = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                placeholder: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                placeholder: "Enter your note",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                placeholder: DateFormat("dd / MM / yyyy").format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: greyClr,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      placeholder: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: greyClr,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      placeholder: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: greyClr,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Remind",
                placeholder: "$_selectedRemind days early",
                widget: DropdownButton(
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: greyClr,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle.merge(
                    const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  underline: Container(height: 0),
                  items: remindList.map<DropdownMenuItem<String>>(
                    (int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    },
                  ).toList(),
                ),
              ),
              MyInputField(
                title: "Repeat",
                placeholder: _selectedRepeat,
                widget: DropdownButton(
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: greyClr,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  items: repeatList.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: greyClr),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "Create Task",
                    onTap: () => _validateTask(),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 25,
          color: Get.isDarkMode ? whiteClr : blackClr,
        ),
      ),
      actions: const [
        Icon(
          Icons.person,
          size: 25,
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      print("It's null");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();

    String formattedTime;

    if (pickedTime == null) {
      print("Time cancelled");
      return;
    }

    // formattedTime = pickedTime.format(context);
    DateTime currentTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      pickedTime.hour,
      pickedTime.minute,
    );
    formattedTime = DateFormat('hh:mm a').format(currentTime);

    if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClrMaterial
                        : (index == 1 ? pinkClr : yellowClr),
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: whiteClr,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _validateTask() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? whiteClr : blackClr,
          colorText: Get.isDarkMode ? blackClr : whiteClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3));
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("current row id is $value");
  }
}
