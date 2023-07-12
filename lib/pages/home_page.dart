import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/common/services/theme_services.dart';
import 'package:to_do_app/common/utils/colors.dart';
import 'package:to_do_app/common/utils/theme.dart';
import 'package:to_do_app/common/widgets/button.dart';
import 'package:to_do_app/pages/add_task_page.dart';

import '../common/widgets/task_tile.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      body: Column(
        children: [
          _appTaskBar(),
          _appDateBar(),
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.appBarTheme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeController().switchTheme();
        },
        child: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_rounded,
          size: 25,
          color: Get.isDarkMode ? whiteClr : blackClr,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: 25,
          color: Get.isDarkMode ? whiteClr : blackClr,
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  _appTaskBar() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTask();
            },
          ),
        ],
      ),
    );
  }

  _appDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClrMaterial,
        selectedTextColor: whiteClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              // print(_taskController.taskList[index].toJson());
              if (_taskController.taskList[index].repeat == "Daily") {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                _taskController.taskList[index],
                              );
                            },
                            child:
                                TaskTile(task: _taskController.taskList[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (_taskController.taskList[index].date ==
                  DateFormat("dd/MM/yyyy").format(_selectedDate)) {
                    return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                _taskController.taskList[index],
                              );
                            },
                            child:
                                TaskTile(task: _taskController.taskList[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.20
            : MediaQuery.of(context).size.height * 0.28,
        color: Get.isDarkMode ? darkGreyClr : whiteClr,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    context: context,
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClrMaterial,
                  ),
            _bottomSheetButton(
              context: context,
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: pinkClr,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
              context: context,
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.transparent,
              isClosed: true,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required BuildContext context,
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClosed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClosed
                ? (Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!)
                : clr,
          ),
          color: isClosed ? Colors.transparent : clr,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClosed
                ? titleStyle
                : titleStyle.copyWith(
                    color: whiteClr,
                  ),
          ),
        ),
      ),
    );
  }
}
