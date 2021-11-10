import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/categories_cubit.dart';
import 'package:rosemary/cubit/products_cubit.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_products_screen.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/singletons/singleton_shop_data.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import 'package:rosemary/utils/validators/categories_forms_validator.dart';

import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';

import 'package:sizer/sizer.dart';

class WomenScreen extends StatefulWidget {
  final String? token;
  final User? userData;
  final int? cartOrderItemsCount;

  final Repository repository;

  // for ios
  final double productCellWidth = 190;
  final double productCellHeight = 240;

  const WomenScreen(
      {Key? key,
      required this.repository,
      required this.token,
      required this.userData,
      required this.cartOrderItemsCount})
      : super(key: key);

  @override
  _WomenScreenState createState() => _WomenScreenState();
}

class _WomenScreenState extends State<WomenScreen> {
  // for ios
  final double productCellWidth = 190;
  final double productCellHeight = 240;

  var _controllerName = TextEditingController();
  var _controllerNameUpdate = TextEditingController();

  File? imageFile;
  final picker = ImagePicker();

  late CategoriesCubit _categoriesCubit;
  late List<Category> _categories;
  bool isInputEnabled = false;

  GlobalKey<FormState> _categoriesFormKey = GlobalKey<FormState>();

  // for android
  //double productCellWidth = 160;
  //double productCellHeight = 240;

  @override
  void initState() {
    super.initState();
    _categoriesCubit = BlocProvider.of<CategoriesCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
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
          title: "Женщины",
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
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          /*
          if (!(state is CategoriesLoaded)) {
            return Center(child: CircularProgressIndicator());
          }
          */

          _categories = SingletonShopData.categories!;

          return GridView.builder(
              padding: EdgeInsets.symmetric(
                  vertical: 1.5.h,
                  horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 1.25.h,
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.25.w,
                  childAspectRatio: 6.5.w / 4.h),
              itemCount: (widget.userData!.isAdmin == true)
                  ? _categories.length + 1
                  : _categories.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == _categories.length &&
                    widget.userData!.isAdmin == true) {
                  return _buildAddNewCategory(
                      width: productCellWidth,
                      height: productCellHeight,
                      index: index);
                }
                return _buildWomanClothTypeContainer(
                    width: 45.w,
                    height: 30.h,
                    categoryInfo: _categories[index],
                    imagePath: _categories[index].image,
                    clothTypeTitle: _categories[index].name,
                    isAdmin: widget.userData!.isAdmin,
                    context: context,
                    index: index);
              });
        },
      ),
    );
  }

  void clearCache() {
    DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    setState(() {});
  }

  Widget _buildWomanClothTypeContainer(
      {required double width,
      required double height,
      required Category categoryInfo,
      required String imagePath,
      required String clothTypeTitle,
      required BuildContext context,
      required bool isAdmin,
      required int index}) {
    return InkWell(
      onLongPress: () => (isAdmin == true)
          ? {
              displayDialogMenu(context, "Внести изменения", _categoriesCubit,
                  widget.token!, categoryInfo.id, index)
            }
          : {},
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProductsCubit(repository: widget.repository),
            child: WomenProductsScreen(
                category: categoryInfo,
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          ),
        ));
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              child: (categoryInfo.id != '')
                  ? CachedNetworkImage(
                      cacheManager: CacheManager(Config('customCacheKey',
                          stalePeriod: Duration(days: 7))),
                      key: UniqueKey(),
                      imageUrl: imagePath,
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                      placeholder: (context, url) =>
                          Container(color: Color.fromRGBO(255,250,250, 0.5)),
                      memCacheHeight: 700,
                    )
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                    )),
          Center(
              child: Text(clothTypeTitle,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Merriweather-Bold',
                      letterSpacing: 3.0,
                      fontSize: 14.sp))),
        ],
      ),
    );
  }

  Widget _buildAddNewCategory(
      {required double height, required double width, required int index}) {
    return Column(
      children: [
        InkWell(
          onTap: () => {displayDialogAdd(context, _categoriesCubit, index)},
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 100,
                width: width,
                child: Icon(Icons.add,
                    color: Color.fromRGBO(58, 67, 59, 0.8), size: 30),
              )
            ],
          ),
        ),
        OutlinedButton(
          child: Text('Чистка кэша',
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'SolomonSans-SemiBold')),
          onPressed: () {
            clearCache();
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
          ),
        )
      ],
    );
  }

  void displayDialogMenu(
          BuildContext context,
          String title,
          CategoriesCubit categoriesCubit,
          String token,
          String id,
          int index) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Внести изменения"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      displayDialogUpdate(context, id, index, token,
                          _categories[index], categoriesCubit);
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
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    onLongPress: () {
                      categoriesCubit
                          .deleteCategory(id: id, token: token)
                          .then((_) {
                        Navigator.of(context).pop();
                        _categories.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Категория удалена'),
                          duration: const Duration(seconds: 2),
                        ));
                        setState(() {});
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
                                fontSize: 11.sp))
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );

  void displayDialogUpdate(BuildContext context, String id, int index,
          String token, Category category, CategoriesCubit categoriesCubit) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Внести изменения"),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter _setState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            width: 40.w,
                            height: 30.h,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                              onTap: () {
                                chooseImageUpdate(
                                    ImageSource.gallery,
                                    categoriesCubit,
                                    index,
                                    token,
                                    category,
                                    id,
                                    _setState);
                              },
                              child: (imageFile == null)
                                  ? Center(
                                      child: CachedNetworkImage(
                                          imageUrl: category.image))
                                  : Image.file(imageFile!),
                            )),
                        Form(
                          key: _categoriesFormKey,
                          child: CustomTextFieldForm().buildTextFormField(
                              formName: "Название",
                              hint: "Название продукта",
                              controller: _controllerNameUpdate,
                              validator: CategoriesFormsValidator()
                                  .validateFieldForEmptySpace,
                              savedContent: category.name
                              ),
                        ),
                        OutlinedButton(
                          child: Text('Изменить категорию',
                              style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'SolomonSans-SemiBold')),
                          onPressed: () {
                            categoriesCubit
                                .updateCategory(id, token,
                                    _controllerNameUpdate.text, imageFile)
                                .then((_) {
                              Navigator.of(context).pop();
                              if (imageFile != null) {
                                _categories[index].image = imageFile!.path;
                                _categories[index].id = '';
                              } else {
                                _categories[index].id = 'image is not loaded';
                              }
                              _categories[index].name =
                                  _controllerNameUpdate.text;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Категория обновлена'),
                                duration: const Duration(seconds: 1),
                              ));
                              setState(() {});
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(58, 67, 59, 1)),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ));

  void displayDialogAdd(
          BuildContext context, CategoriesCubit categoriesCubit, int index) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Добавить категорию"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter _setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.zero,
                        child: (imageFile == null)
                            ? Center(
                                child: InkWell(
                                  onTap: () {
                                    chooseImageAdd(ImageSource.gallery,
                                        categoriesCubit, index, _setState);
                                  },
                                  child: Icon(Icons.add_a_photo_outlined,
                                      size: 20.w, color: PRIMARY_DARK_COLOR),
                                ),
                              )
                            : Image.file(imageFile!),
                        width: 25.w,
                        height: 14.h),
                    Form(
                      key: _categoriesFormKey,
                      child: CustomTextFieldForm().buildTextFormField(
                          formName: "Название",
                          hint: "Название продукта",
                          controller: _controllerName,
                          validator: CategoriesFormsValidator()
                              .validateFieldForEmptySpace,
                          isInputEnabled: isInputEnabled),
                    ),
                    OutlinedButton(
                      child: Text('Добавить продукт',
                          style: TextStyle(
                              fontSize: 11.5.sp,
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'SolomonSans-SemiBold')),
                      onPressed: () {
                        if (_categoriesFormKey.currentState!.validate()) {
                          categoriesCubit
                              .postCategory(
                                  token: widget.token,
                                  categoryName: _controllerName.text,
                                  image: imageFile)
                              .then((_) {
                            Navigator.of(context).pop();
                            _categories.add(Category(
                                id: '',
                                name: _controllerName.text,
                                image: imageFile!.path));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Категория создана'),
                              duration: const Duration(seconds: 2),
                            ));
                            _controllerName.text = "";

                            setState(() {
                              imageFile = null;
                            });
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
              );
            })),
      );

  Future chooseImageAdd(ImageSource source, CategoriesCubit categoriesCubit,
      int index, StateSetter _setState) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        _setState(() {});
        //Navigator.of(context).pop();
        //displayDialogAdd(context, categoriesCubit, index);
      } else {
        print("No image is selected");
      }
    });
  }

  Future chooseImageUpdate(
      ImageSource source,
      CategoriesCubit categoriesCubit,
      int index,
      String token,
      Category category,
      String id,
      StateSetter _setState) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        _setState(() {});
        //Navigator.of(context).pop();
        //displayDialogUpdate(
        //  context, id, index, token, category, categoriesCubit);
      } else {
        print("No image is selected");
      }
    });
  }

  void updateAfterReturn() {
    setState(() {});
  }
}
