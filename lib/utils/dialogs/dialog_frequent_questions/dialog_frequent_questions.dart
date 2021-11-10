import 'package:flutter/material.dart';
import 'package:rosemary/cubit/frequently_asked_questions_cubit.dart';
import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/utils/dialogs/dialog.dart';
import 'package:rosemary/utils/dialogs/dialog_frequent_questions/dialog_frequent_questions_menu_item.dart';
import 'package:rosemary/utils/validators/frequent_questions_forms_validator.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:sizer/sizer.dart';

class DialogFrequentQuestions extends CustomDialog {
  final BuildContext context;
  final String title;
  final FrequentlyAskedQuestionsCubit frequentlyAskedQuestionsCubit;
  final String id;
  final String? token;
  final int index;
  final List<AskedQuestion> askedQuestions;
  void Function(VoidCallback fn) setStateCall;
  final GlobalKey<FormState> formKey;

  DialogFrequentQuestions(
      {required this.context,
      required this.title,
      required this.frequentlyAskedQuestionsCubit,
      required this.id,
      required this.token,
      required this.index,
      required this.askedQuestions,
      required this.setStateCall,
      required this.formKey});

  @override
  Widget buildDialogAdd() {
    // TODO: implement buildDialogAdd
    throw UnimplementedError();
  }

  @override
  void buildDialogMenu() {
    DialogFrequentQuestionsMenuItems menuItems =
        DialogFrequentQuestionsMenuItems(
            context: context,
            title: "Внести изменения",
            frequentlyAskedQuestionsCubit: frequentlyAskedQuestionsCubit,
            id: id,
            token: token,
            index: index,
            askedQuestions: askedQuestions,
            setStateCall: setStateCall);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Внести изменения"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              menuItems.buildMenuItemDelete(),
              SizedBox(
                height: 3.h,
              ),
              menuItems.buildMenuItemUpdate(buildDialogUpdate)
            ],
          )),
    );
  }

  @override
  void buildDialogUpdate() {
    var _controllerQuestionTitleUpdate = TextEditingController();
    var _controllerDescriptionUpdate = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Внести изменения"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                Form(
                    key: formKey,
                    child: Column(children: [
                      CustomTextFieldForm().buildTextFormField(
                          formName: "Вопрос",
                          hint: "Вопрос",
                          controller: _controllerQuestionTitleUpdate,
                          validator: FrequentQuestionsFormsValidator()
                              .validateFieldForEmptySpace,
                          savedContent: askedQuestions[index].title),
                      CustomTextFieldForm().buildTextFormField(
                          formName: "Ответ",
                          hint: "Ответ",
                          controller: _controllerDescriptionUpdate,
                          validator: FrequentQuestionsFormsValidator()
                              .validateFieldForEmptySpace,
                          savedContent: askedQuestions[index].description),
                    ])),
                OutlinedButton(
                  child: Text('Изменить вопрос',
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Color.fromRGBO(58, 67, 59, 1),
                          fontFamily: 'SolomonSans-SemiBold')),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      print(_controllerDescriptionUpdate.text);
                      print(_controllerQuestionTitleUpdate.text);

                      frequentlyAskedQuestionsCubit
                          .updateAskedQuestion(
                              id,
                              token,
                              _controllerQuestionTitleUpdate.text,
                              _controllerDescriptionUpdate.text)
                          .then((_) {
                        Navigator.of(context).pop();
                        askedQuestions[index].title =
                            _controllerQuestionTitleUpdate.text;
                        askedQuestions[index].description =
                            _controllerDescriptionUpdate.text;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Вопрос обновлен'),
                          duration: const Duration(seconds: 1),
                        ));
                        setStateCall(() {});
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
