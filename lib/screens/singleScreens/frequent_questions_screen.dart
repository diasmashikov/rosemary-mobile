import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/frequently_asked_questions_cubit.dart';
import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:rosemary/utils/dialogs/dialog_frequent_questions/dialog_frequent_questions.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import 'package:rosemary/utils/validators/frequent_questions_forms_validator.dart';
import 'package:rosemary/utils/validators/promotion_forms_validator.dart';
import 'package:rosemary/utils/expansion_tiles/expansion_tile_frequent_questions/expansion_tile_frequent_questions.dart';

import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';

import 'package:sizer/sizer.dart';

class FrequentQuestionsScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const FrequentQuestionsScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _FrequentQuestionsState createState() => _FrequentQuestionsState();
}

class _FrequentQuestionsState extends State<FrequentQuestionsScreen> {
  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;

  final GlobalKey<FormState> _frequentQuestionsFormKey = GlobalKey<FormState>();

  late List<AskedQuestion> _askedQuestions;
  late FrequentlyAskedQuestionsCubit _frequentlyAskedQuestionsCubit;

  var _controllerQuestionTitle = TextEditingController();
  var _controllerDescription = TextEditingController();

  var _controllerQuestionTitleUpdate = TextEditingController();
  var _controllerDescriptionUpdate = TextEditingController();

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  void initState() {
    log(widget.token!);
    super.initState();

    _frequentlyAskedQuestionsCubit =
        BlocProvider.of<FrequentlyAskedQuestionsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    print("BLYA");
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    return Scaffold(
        drawer: NavigationDrawerWidget(
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: widget.cartOrderItemsCount),
        appBar: CustomAppBar(
            title: "Частые вопросы",
            favoriteIcon: Icons.favorite_outline,
            shoppingCartIcon: Icons.shopping_cart_outlined,
            settingsIcon: null,
            adminPanel: (widget.userData!.isAdmin != true)
                ? null
                : Icons.admin_panel_settings_outlined,
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: SingletonOrderCount.orderCount),
        body: BlocBuilder<FrequentlyAskedQuestionsCubit,
            FrequentlyAskedQuestionsState>(
          builder: (context, state) {
            _askedQuestions = SingletonShopData.askedQuestions!;

            return Container(
                margin: EdgeInsets.symmetric(
                    horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                    vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
                child: ListView.builder(
                    itemCount: (widget.userData!.isAdmin == true)
                        ? _askedQuestions.length + 1
                        : _askedQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _askedQuestions.length &&
                          widget.userData!.isAdmin == true) {
                        return _buildAddNewQuestion(
                            width: double.infinity,
                            height: 100,
                            frequentlyAskedQuestionsCubit:
                                _frequentlyAskedQuestionsCubit);
                      }
                      return CustomExpansionTile(
                              askedQuestions: _askedQuestions,
                              title: _askedQuestions[index].title,
                              expansionTileTextColor: _expansionTileTextColor,
                              frequentlyAskedQuestionsCubit:
                                  _frequentlyAskedQuestionsCubit,
                              id: _askedQuestions[index].id,
                              token: widget.token!,
                              index: index,
                              setStateCall: setState,
                              context: context,
                              formKey: _frequentQuestionsFormKey)
                          .buildExpansionTile(context);
                      /*
                      _buildExpansionTile(
                          title: _askedQuestions[index].title,
                          description: _askedQuestions[index].description,
                          isAdmin: widget.userData!.isAdmin,
                          frequentlyAskedQuestionsCubit:
                              _frequentlyAskedQuestionsCubit,
                          id: _askedQuestions[index].id,
                          token: widget.token,
                          index: index);
                          */
                    }));
          },
        ));
  }

  Widget _buildAddNewQuestion(
      {required double height,
      required double width,
      required FrequentlyAskedQuestionsCubit frequentlyAskedQuestionsCubit}) {
    return InkWell(
      onTap: () => {displayDialogAdd(context, frequentlyAskedQuestionsCubit)},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            child: Icon(Icons.add,
                color: Color.fromRGBO(58, 67, 59, 0.8), size: 20.w),
          )
        ],
      ),
    );
  }


  void displayDialogAdd(BuildContext context,
          FrequentlyAskedQuestionsCubit frequentlyAskedQuestionsCubit) =>
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Добавить вопрос"),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter _setState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                            key: _frequentQuestionsFormKey,
                            child: Column(children: [
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Вопрос",
                                  hint: "Вопрос",
                                  controller: _controllerQuestionTitle,
                                  validator: FrequentQuestionsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Ответ",
                                  hint: "Ответ",
                                  controller: _controllerDescription,
                                  validator: FrequentQuestionsFormsValidator()
                                      .validateFieldForEmptySpace),
                            ])),
                        OutlinedButton(
                          child: Text('Добавить вопрос',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'SolomonSans-SemiBold')),
                          onPressed: () {
                            if (_frequentQuestionsFormKey.currentState!
                                .validate()) {
                              frequentlyAskedQuestionsCubit
                                  .postAskedQuestion(
                                      _controllerQuestionTitle.text,
                                      _controllerDescription.text,
                                      widget.token)
                                  .then((_) {
                                Navigator.of(context).pop();
                                _askedQuestions.add(AskedQuestion(
                                    title: _controllerQuestionTitle.text,
                                    description: _controllerDescription.text,
                                    id: "temporary id"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text('Вопрос сохранен'),
                                  duration: const Duration(seconds: 2),
                                ));
                                _controllerQuestionTitle.text = "";
                                _controllerDescription.text = "";

                                setState(() {});
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 0.2.w,
                                color: Color.fromRGBO(58, 67, 59, 1)),
                          ),
                        )
                      ],
                    ),
                  );
                }));
          });
  void updateAfterReturn() {
    setState(() {});
  }
}
