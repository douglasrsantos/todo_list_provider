import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/total_tasks_model.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';

class TodoCardFilter extends StatefulWidget {
  final String label;
  final TaskFilterEnum taskFilter;
  final TotalTasksModel? totalTasksModel;
  final bool selected;

  const TodoCardFilter({
    Key? key,
    required this.label,
    required this.taskFilter,
    required this.selected,
    this.totalTasksModel,
  }) : super(key: key);

  @override
  State<TodoCardFilter> createState() => _TodoCardFilterState();
}

class _TodoCardFilterState extends State<TodoCardFilter> {
  double _getPercentFinish() {
    final total = widget.totalTasksModel?.totalTasks ?? 0.0;
    final totalFinish = widget.totalTasksModel?.totalTasksFinish ?? 0.1;

    double percent = (totalFinish * 100) / total;

    if (percent.isInfinite || percent.isNaN) {
      return percent = 0;
    } else {
      return percent / 100;
    }
  }

  int get _numberOfTasks {
    switch (widget.taskFilter) {
      case TaskFilterEnum.today:
        return context.select<HomeController, int>(
            (controller) => controller.tasksToDoToday);
      case TaskFilterEnum.tomorrow:
        return context.select<HomeController, int>(
            (controller) => controller.tasksToDoTomorrow);
      case TaskFilterEnum.week:
        return context.select<HomeController, int>(
            (controller) => controller.tasksToDoWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.read<HomeController>().findTasks(filter: widget.taskFilter),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 120,
          maxWidth: 150,
        ),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.selected ? context.primaryColor : Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey.withOpacity(.8),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_numberOfTasks TAREFAS',
              style: context.titleStyle.copyWith(
                fontSize: 10,
                color: widget.selected ? Colors.white : Colors.grey,
              ),
            ),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.selected ? Colors.white : Colors.black,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0.0,
                end: _getPercentFinish(),
              ),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  backgroundColor: widget.selected
                      ? context.primaryColorLight
                      : Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.selected ? Colors.white : context.primaryColor,
                  ),
                  value: value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
