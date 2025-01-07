import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/extensions/string_extensions.dart';
import '../../../../shared/services/snackbar/snackbar_service.dart';
import '../../../../shared/widgets/custom_checkbox.dart';
import '../../domain/models/task_model.dart';
import '../viewmodels/task_list_viewmodel.dart';

class CreateOrEditTaskBottomSheet extends StatefulWidget {
  const CreateOrEditTaskBottomSheet({
    super.key,
    required this.viewModel,
    this.task,
  });

  final TaskListViewModel viewModel;
  final TaskModel? task;

  @override
  State<CreateOrEditTaskBottomSheet> createState() =>
      _CreateOrEditTaskBottomSheetState();
}

class _CreateOrEditTaskBottomSheetState
    extends State<CreateOrEditTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();

  bool get editMode => widget.task != null;

  bool finished = false;
  void setFinished(bool value) {
    setState(() {
      finished = value;
    });
  }

  bool loading = false;
  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  String title = '';
  void setTitle(String value) {
    title = value;
  }

  String description = '';

  void setDescription(String value) {
    description = value;
  }

  bool formIsValid() {
    return formKey.currentState?.validate() == true;
  }

  Future<void> submit() async {
    final isValid = formIsValid();

    if (!isValid) {
      return;
    }

    final task = TaskModel(
      id: editMode ? widget.task!.id : Uuid().v4(),
      title: title,
      description: description.nullIfEmpty,
      finished: finished,
    );

    try {
      setLoading(true);

      late final Result<TaskModel> response;

      if (editMode) {
        response = await widget.viewModel.updateTask(task);
      } else {
        response = await widget.viewModel.insertTask(task);
      }

      if (!mounted) return;

      if (response.isError()) {
        final error = response.exceptionOrNull();

        SnackbarService.showError(context, message: error.toString());
        return;
      }
    } finally {
      setLoading(false);
    }

    Navigator.pop(context, task);
  }

  @override
  void initState() {
    if (editMode) {
      title = widget.task!.title;
      description = widget.task!.description ?? '';
      finished = widget.task!.finished;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(24).copyWith(
            bottom: 24 + MediaQuery.paddingOf(context).bottom,
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Row(
                spacing: 16,
                children: [
                  IgnorePointer(
                    ignoring: loading,
                    child: CustomCheckbox(
                      value: finished,
                      onChanged: setFinished,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: title,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onChanged: setTitle,
                      enabled: !loading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "What's in your mind?",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  SizedBox.square(
                    dimension: 28,
                    child: Icon(
                      Icons.edit,
                      color: Colors.blueGrey.shade200,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: description,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      onChanged: setDescription,
                      enabled: !loading,
                      decoration: InputDecoration(
                        hintText: "Add a note...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: loading ? null : submit,
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  child: Text(
                    editMode ? 'Update' : 'Create',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
