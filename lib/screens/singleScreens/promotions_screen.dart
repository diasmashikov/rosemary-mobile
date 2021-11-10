import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/promotions_cubit.dart';
import 'package:rosemary/data/models/promotion.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:rosemary/utils/testForm.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import 'package:rosemary/utils/validators/promotion_forms_validator.dart';

import '../../navigation_drawer_widget.dart';

import 'package:sizer/sizer.dart';

class PromotionsScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;
  final int? cartOrderItemsCount;

  const PromotionsScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.cartOrderItemsCount})
      : super(key: key);
  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;

  File? imageFile;
  final picker = ImagePicker();

  final GlobalKey<FormState> _promotionFormKey = GlobalKey<FormState>();


  late PromotionsCubit _promotionsCubit;

  var _controllerFirstLine = TextEditingController();
  
  var _controllerSecondLine = TextEditingController();
  var _controllerThirdLine = TextEditingController();
  var _controllerDescription = TextEditingController();
  var _controllerActivePeriod = TextEditingController();
  var inputActivePeriod = "";
  var _controllerSlogan = TextEditingController();

  

  late List<Promotion> _promotions;

  bool isInputEnabled = false;

  @override
  void initState() {
    super.initState();

    _promotionsCubit = BlocProvider.of<PromotionsCubit>(context);
  }

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) {
     if(imageFile != null) {
                              isInputEnabled = true;
                            }
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    return Scaffold(
        drawer: NavigationDrawerWidget(
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: widget.cartOrderItemsCount),
        appBar: CustomAppBar(
            title: "Акции",
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
        body: BlocBuilder<PromotionsCubit, PromotionsState>(
          builder: (context, state) {
            _promotions = SingletonShopData.promotions!;

            print("FETCH PROMOTED FROM BUILD");
            print(_promotions);

            return Container(
                margin: EdgeInsets.symmetric(
                    horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                    vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
                child: ListView.builder(
                    itemCount: (widget.userData!.isAdmin == true)
                  ? _promotions.length + 1
                  : _promotions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _promotions.length &&
                    widget.userData!.isAdmin == true) {
                        return _buildAddNewPromotion(
                            width: double.infinity,
                            height: 150,
                            promotionsCubit: _promotionsCubit);
                      }

                      return _buildPromotionContainer(
                          width: double.infinity,
                          height: 20.h,
                          imagePath: _promotions[index].image,
                          activePeriod: _promotions[index].activePeriod,
                          promotionSlogan: _promotions[index].slogan,
                          firstLine: _promotions[index].firstLine,
                          secondLine: _promotions[index].secondLine,
                          thirdLine: _promotions[index].thirdLine,
                          isAdmin: widget.userData!.isAdmin,
                          id: _promotions[index].id,
                          index: index);
                    }));
          },
        ));
  }

  Widget _buildPromotionContainer({
    required double width,
    required double height,
    required String imagePath,
    required String activePeriod,
    required String promotionSlogan,
    required String firstLine,
    required String secondLine,
    required String thirdLine,
    required bool isAdmin,
    required String id,
    required int index,
  }) {
    return InkWell(
      onLongPress: () => (isAdmin == true)
          ? {
              displayDialogMenu(
                  context, "Внести изменения", _promotionsCubit, id, index)
            }
          : {},
      onTap: () {},
      child: Container(
        width: width,
        child: Card(
          child: Column(
            children: [
              Stack(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: height,
                  width: width,
                  child: (id != 'temporary id')
                      ? Image.network(
                          imagePath,
                          height: height,
                          width: width,
                          fit: BoxFit.cover,
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          colorBlendMode: BlendMode.darken,
                        )
                      : Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          height: height,
                          width: width,
                        ),
                ),
                Column(children: <Widget>[
                  SizedBox(
                    // height / 4
                    height: height / 4,
                  ),
                  Center(
                      child: Text(firstLine,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.sp))),
                  Center(
                      child: Text(secondLine,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Bold',
                              fontSize: 15.5.sp))),
                  Center(
                      child: Text(thirdLine,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 11.sp))),
                ])
              ]),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(
                    horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                    vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activePeriod,
                        style: TextStyle(
                            color: Color.fromRGBO(58, 67, 59, 0.5),
                            fontFamily: 'Merriweather-Regular',
                            fontSize: 9.sp)),
                    SizedBox(
                      height: 4,
                    ),
                    Text(promotionSlogan,
                        style: TextStyle(
                            color: Color.fromRGBO(58, 67, 59, 1),
                            fontFamily: 'Merriweather-Regular',
                            fontSize: 12.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void displayDialogMenu(BuildContext context, String title,
          PromotionsCubit promotionsCubit, String id, index) =>
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
            title: Text("Внести изменения"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onLongPress: () {
                      promotionsCubit.deletePromotion(id, widget.token);
                      print(_promotions);
                      _promotions.removeAt(index);
                      Navigator.of(dialogContext).pop();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Акция удалена'),
                        duration: const Duration(milliseconds: 500),
                      ));
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
                                fontSize: 11.5.sp))
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );

 
  void displayDialogAdd(
          BuildContext context, PromotionsCubit promotionsCubit) =>
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Добавить акцию"),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter _setState) {
                  return SingleChildScrollView(
                    child: 
                     Column(
                          children: [
                            Container(
                                padding: EdgeInsets.zero,
                                child: (imageFile == null)
                                    ? Center(
                                        child: InkWell(
                                          onTap: () {
                                            chooseImage(ImageSource.gallery,
                                                promotionsCubit).then((value) => 
                                                _setState(() {}));
                                          },
                                          child: Icon(Icons.add_a_photo_outlined,
                                              size: 20.w,
                                              color: PRIMARY_DARK_COLOR),
                                        ),
                                      )
                                    : Image.file(imageFile!),
                                width: 25.w,
                                height: 14.h),

                           

                            Form(key: _promotionFormKey, child: Column(children: [
                              CustomTextFieldForm().buildTextFormField(formName: "Первая линия",hint:  "Первая линия", controller: _controllerFirstLine, validator: PromotionFormsValidator().validateFieldForEmptySpace, isInputEnabled: isInputEnabled),
                              CustomTextFieldForm().buildTextFormField(formName: "Вторая линия",hint:  "Вторая линия", controller: _controllerSecondLine, validator: PromotionFormsValidator().validateFieldForEmptySpace, isInputEnabled: isInputEnabled),
                              CustomTextFieldForm().buildTextFormField(formName: "Третья линия",hint:  "Третья линия", controller: _controllerThirdLine, validator: PromotionFormsValidator().validateFieldForEmptySpace, isInputEnabled: isInputEnabled),
                              CustomTextFieldForm().buildTextFormField(formName: "Описание",hint:  "Описание", controller: _controllerDescription, validator: PromotionFormsValidator().validateFieldForEmptySpace, isInputEnabled: isInputEnabled),
                              CustomTextFieldForm().buildTextFormField(formName: "Активный период",hint:  "21 августа - 21 сентября", controller: _controllerActivePeriod, validator: PromotionFormsValidator().validateActivePeriod, isInputEnabled: isInputEnabled),
                              CustomTextFieldForm().buildTextFormField(formName: "Слоган",hint:  "Слоган", controller: _controllerSlogan, validator: PromotionFormsValidator().validateFieldForEmptySpace, isInputEnabled: isInputEnabled),
                            ],),),
                            OutlinedButton(
                              child: Text('Добавить акцию',
                                  style: TextStyle(
                                      fontSize: 11.5.sp,
                                      color: Color.fromRGBO(58, 67, 59, 1),
                                      fontFamily: 'SolomonSans-SemiBold')),
                              onPressed: () {
                                if (_promotionFormKey.currentState!.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                         promotionsCubit
                                    .postPromotion(
                                        _controllerFirstLine.text,
                                        _controllerSecondLine.text,
                                        _controllerThirdLine.text,
                                        _controllerDescription.text,
                                        _controllerActivePeriod.text,
                                        _controllerSlogan.text,
                                        imageFile,
                                        widget.token)
                                    .then((_) {
                                  _promotions.add(Promotion(
                                      firstLine: _controllerFirstLine.text,
                                      secondLine: _controllerSecondLine.text,
                                      thirdLine: _controllerThirdLine.text,
                                      description: _controllerDescription.text,
                                      activePeriod: _controllerActivePeriod.text,
                                      slogan: _controllerSlogan.text,
                                      image: imageFile!.path,
                                      id: "temporary id"));

                                      _controllerFirstLine.text = "";
                                        _controllerSecondLine.text = "";
                                        _controllerThirdLine.text= "";
                                        _controllerDescription.text= "";
                                        _controllerActivePeriod.text= "";
                                        _controllerSlogan.text= "";
                                  
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text('Акция сохранена'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                  setState(() {});
                                  imageFile = null;
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

  Widget _buildAddNewPromotion(
      {required double height,
      required double width,
      required PromotionsCubit promotionsCubit}) {
    return InkWell(
      onTap: () => {
        _controllerActivePeriod.text = "",
        displayDialogAdd(context, promotionsCubit)},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            child: Icon(Icons.add,
                color: Color.fromRGBO(58, 67, 59, 0.8), size: 100),
          )
        ],
      ),
    );
  }

  Future chooseImage(
      ImageSource source, PromotionsCubit promotionsCubit) async {
    final pickedFile = await picker.pickImage(source: source);
;

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        /*
       Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pop();
        displayDialogAdd(context, promotionsCubit);
        print("CYKAAAAAAA" + imageFile.toString());
        */
      } else {
        print("No image is selected");
      }
    });
  }

  void updateAfterReturn() {
    setState(() {});
  }
}
