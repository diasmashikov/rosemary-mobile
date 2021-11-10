import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/cubit/contacts_cubit.dart';
import 'package:rosemary/data/models/contact.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import 'package:rosemary/utils/validators/contacts_forms_validator.dart';
import 'package:url_launcher/link.dart';

import '../../navigation_drawer_widget.dart';
import 'favorites_screen.dart';
import 'package:sizer/sizer.dart';

class ContactsScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const ContactsScreen({
    Key? key,
    required this.token,
    required this.userData,
    required this.repository,
    required this.cartOrderItemsCount,
  }) : super(key: key);
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  // for ios
  double clothImageWidth = 400;
  double clothImageHeight = 380;
  double verticalMargin = 40;

  late ContactsCubit _contactsCubit;

  var _controllerPhoneNumbers = TextEditingController();
  var _controllerSocialMedias = TextEditingController();
  var _controllerWorkingSchedule = TextEditingController();
  var contacts;

  List<String> _phoneNumbers = [];
  List<String> _socialMedias = [];
  String _workingSchedule = "";

  final GlobalKey<FormState> _contactsFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _contactsCubit = BlocProvider.of<ContactsCubit>(context);
  }

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;
  @override
  Widget build(BuildContext context) {
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    return Scaffold(
        drawer: NavigationDrawerWidget(
            token: widget.token,
            userData: widget.userData,
            repository: widget.repository,
            cartOrderItemsCount: widget.cartOrderItemsCount),
        appBar: CustomAppBar(
            title: "Контакты",
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
        body: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            contacts = SingletonShopData.contacts;

            _phoneNumbers = contacts!.phoneNumbers;
            _socialMedias = contacts.socialMedias;
            _workingSchedule = contacts.workingSchedule;

            return InkWell(
              onLongPress: () => (widget.userData!.isAdmin == true)
                  ? {
                      displayDialogMenu(
                          context, "Внести изменения", contacts, _contactsCubit)
                    }
                  : {},
              child: Container(
                  margin: EdgeInsets.only(right: 4.w, left: 4.w, top: 0.1..h),
                  child: ListView(
                    children: [
                      _buildGreetingTitle(),
                      Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                      _buildPhoneContactSection(_phoneNumbers),
                      Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                      _buildSocialMediaSection(_socialMedias),
                      Divider(color: Color.fromRGBO(58, 67, 59, 1)),
                      _buildOpeninsHours(_workingSchedule),
                    ],
                  )),
            );
          },
        ));
  }

  Widget _buildGreetingTitle() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Text("Команда Rosemary всегда рада Вам!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Bold',
            fontSize: 16.sp,
          )),
    );
  }

  Widget _buildPhoneContactSection(List<String> phoneNumbers) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Позвонить нам: ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 12.sp,
            )),
        SizedBox(
          height: 2.h,
        ),
        _getPhoneNumbers(phoneNumbers)
      ]),
    );
  }

  Widget _getPhoneNumbers(List<String> phoneNumbers) {
    return Column(
        children: phoneNumbers
            .map(
              (phoneNumber) => Column(
                children: [
                  Text(phoneNumber,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold',
                        fontSize: 11.sp,
                      )),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            )
            .toList());
  }

  Widget _buildSocialMediaSection(List<String> socialMedias) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text("Социальные сети: ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(58, 67, 59, 1),
              fontFamily: 'Merriweather-Bold',
              fontSize: 12.sp,
            )),
        SizedBox(
          height: 1.h,
        ),
        _getSocialMedias(socialMedias)
      ]),
    );
  }

  Widget _getSocialMedias(List<String> socialMedias) {
    return Column(
        children: socialMedias
            .map(
              (socialMedia) => Column(
                children: [
                  Link(
                      uri: Uri.parse(socialMedia),
                      builder: (context, followLink) {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: socialMedia.split('.')[1].toUpperCase(),
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontFamily: 'Merriweather-Bold',
                                fontSize: 12.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = followLink,
                            ),
                          ]),
                        );
                      }),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            )
            .toList());
  }

  Widget _buildOpeninsHours(String workingSchedule) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: verticalMargin),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("Часы работы: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Bold',
                fontSize: 12.sp,
              )),
          SizedBox(
            height: 20,
          ),
          Text(workingSchedule,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(58, 67, 59, 1),
                fontFamily: 'Merriweather-Regular',
                fontSize: 11.sp,
              )),
        ]));
  }

  void displayDialogMenu(BuildContext context, String title, Contact? content,
      ContactsCubit contactsCubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Внести изменения"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Form(
                key: _contactsFormKey,
                child: Column(
                  children: [
                    CustomTextFieldForm().buildTextFormField(
                        formName: "Номера телефонов",
                        hint: "+77777777 - Алматы\n+775324234 - Нью-Йорк",
                        controller: _controllerPhoneNumbers,
                        validator:
                            ContactsFormsValidator().validateFieldForEmptySpace,
                        savedContent: _phoneNumbers.join('\n')),
                    CustomTextFieldForm().buildTextFormField(
                        formName: "Социальные сети",
                        hint: "https://www.instagram.com/rosemarybrand_/",
                        controller: _controllerSocialMedias,
                        validator:
                            ContactsFormsValidator().validateFieldForEmptySpace,
                        savedContent: _socialMedias.join('\n')),
                    CustomTextFieldForm().buildTextFormField(
                        formName: "Часы работы",
                        hint: "Часы работы",
                        controller: _controllerWorkingSchedule,
                        validator:
                            ContactsFormsValidator().validateFieldForEmptySpace,
                        savedContent: _workingSchedule),
                  ],
                )),
            OutlinedButton(
              child: Text('Сохранить',
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Color.fromRGBO(58, 67, 59, 1),
                      fontFamily: 'SolomonSans-SemiBold')),
              onPressed: () {
                contactsCubit
                    .updateContacts(
                        content!.id,
                        _controllerPhoneNumbers.text,
                        _controllerSocialMedias.text,
                        _controllerWorkingSchedule.text,
                        widget.token)
                    .then((_) {
                  Navigator.of(context).pop();
                  var phoneNumbersArr =
                      _controllerPhoneNumbers.text.split('\n');
                  var socialMediasArr =
                      _controllerSocialMedias.text.split('\n');
                  contacts.phoneNumbers = phoneNumbersArr;
                  contacts.socialMedias = socialMediasArr;
                  contacts.workingSchedule = _controllerWorkingSchedule.text;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Обновлено'),
                    duration: const Duration(seconds: 2),
                  ));
                });
                setState(() {});
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
              ),
            ),
          ])),
    );
  }

  void updateAfterReturn() {
    setState(() {});
  }
}
