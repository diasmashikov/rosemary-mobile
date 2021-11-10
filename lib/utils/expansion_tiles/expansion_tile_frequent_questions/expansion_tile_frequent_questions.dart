import 'package:flutter/material.dart';
import 'package:rosemary/cubit/frequently_asked_questions_cubit.dart';
import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/utils/decorators/ExpansionTileDecorator.dart';
import 'package:rosemary/utils/dialogs/dialog_frequent_questions/dialog_frequent_questions.dart';
import 'package:rosemary/utils/expansion_tiles/expansion_tile_frequent_questions/expansion_tile_frequent_questions_content.dart';
import 'package:rosemary/utils/listeners/expansion_tile_listener.dart';
import 'package:sizer/sizer.dart';

class CustomExpansionTile {
  final BuildContext context;
  final void Function(VoidCallback fn) setStateCall;
  final String title;
  Color expansionTileTextColor;
  final List<AskedQuestion> askedQuestions;
  final FrequentlyAskedQuestionsCubit frequentlyAskedQuestionsCubit;
  final String id;
  final int index;
  final String token;
  final GlobalKey<FormState> formKey;

  CustomExpansionTile(
      {required this.askedQuestions,
      required this.title,
      //required this.setStateCall,
      required this.expansionTileTextColor,
      required this.context,
      required this.frequentlyAskedQuestionsCubit,
      required this.id,
      required this.token,
      required this.index,
      required this.setStateCall,
      required this.formKey});

  Widget buildExpansionTile(context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: StatefulBuilder(builder: (_context, _setState) {
        return InkWell(
          onLongPress: () {
            DialogFrequentQuestions(
                    context: context,
                    title: "Внести изменения",
                    frequentlyAskedQuestionsCubit:
                        frequentlyAskedQuestionsCubit,
                    id: id,
                    token: token,
                    index: index,
                    askedQuestions: askedQuestions,
                    setStateCall: setStateCall,
                    formKey: formKey)
                .buildDialogMenu();
          },
          child: ExpansionTile(
              tilePadding: EdgeInsets.all(0),
              onExpansionChanged: ExpansionTileListener(
                      expansionTileTextColor: expansionTileTextColor,
                      setStateCall: _setState)
                  .onTileExpanded,
              iconColor: expansionTileTextColor,
              title: ExpanstionTileComponents().buildExpansionTileTitle(
                  title: title, expansionTileTextColor: expansionTileTextColor),
              children: [
                ExpansionTileFrequentQuestionsContent(
                    description: askedQuestions[index].description,
                    expansionTileTextColor: expansionTileTextColor)
              ]),
        );
      }),
    );
  }
}
