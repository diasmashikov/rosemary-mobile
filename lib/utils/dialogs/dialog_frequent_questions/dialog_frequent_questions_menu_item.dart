import 'package:flutter/material.dart';
import 'package:rosemary/cubit/frequently_asked_questions_cubit.dart';
import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/utils/dialogs/dialog_menu_items.dart';
import 'package:sizer/sizer.dart';

class DialogFrequentQuestionsMenuItems extends CustomDialogMenuItems {
  final BuildContext context;
  final String title;
  final FrequentlyAskedQuestionsCubit frequentlyAskedQuestionsCubit;
  final String id;
  final String? token;
  final int index;
  final List<AskedQuestion> askedQuestions;
  void Function(VoidCallback fn) setStateCall;

  DialogFrequentQuestionsMenuItems(
      {required this.context,
      required this.title,
      required this.frequentlyAskedQuestionsCubit,
      required this.id,
      required this.token,
      required this.index,
      required this.askedQuestions,
      required this.setStateCall});

  @override
  Widget buildMenuItemDelete() {
    return InkWell(
      onLongPress: () {
        frequentlyAskedQuestionsCubit.deleteAskedQuestion(id, token).then((_) {
          Navigator.of(context).pop();
          askedQuestions.removeAt(index);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Вопрос удален'),
            duration: const Duration(seconds: 2),
          ));
          setStateCall(() {});
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.delete_outlined,
            size: 6.w,
            color: Color.fromRGBO(58, 67, 59, 1),
          ),
          SizedBox(
            width: 5.w,
          ),
          Text("Удалить",
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 14))
        ],
      ),
    );
  }

  @override
  Widget buildMenuItemUpdate(void Function() buildDialogUpdate) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        buildDialogUpdate();
      },
      child: Row(
        children: [
          Icon(
            Icons.change_circle_outlined,
            size: 6.w,
            color: Color.fromRGBO(58, 67, 59, 1),
          ),
          SizedBox(
            width: 5.w,
          ),
          Text("Изменить",
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 11.sp))
        ],
      ),
    );
  }
}

/*
frequentlyAskedQuestionsCubit
                          .deleteAskedQuestion(id, token)
                          .then((_) {
                        Navigator.of(context).pop();
                        _askedQuestions.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Вопрос удален'),
                          duration: const Duration(seconds: 2),
                        ));
                        setState(() {});
                      }); */

/*
Navigator.of(context).pop();

                      displayDialogUpdate(
                          context,
                          token,
                          frequentlyAskedQuestionsCubit,
                          index,
                          _controllerDescriptionUpdate,
                          _controllerQuestionTitleUpdate,
                          id,
                          _askedQuestions[index]);

                          */
