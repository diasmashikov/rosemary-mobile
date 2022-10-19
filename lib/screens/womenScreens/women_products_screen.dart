import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/constants/responsive_ui.dart';
import 'package:rosemary/cubit/product_detail_cubit.dart';
import 'package:rosemary/cubit/products_cubit.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/favorite.dart';
import 'package:rosemary/data/models/modelCharacteristics.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/radioItem.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_product_screen.dart';
import 'package:rosemary/utils/validators/women_products_forms_validator.dart';
import 'package:rosemary/utils/widgets/custom_app_bar.dart';
import 'package:rosemary/utils/widgets/custom_drop_down.dart';
import 'package:rosemary/utils/widgets/custom_text_field_form.dart';
import 'package:rosemary/utils/widgets/radio_group.dart';
import 'package:rosemary/utils/singletons/singleton_callbacks.dart';
import 'package:rosemary/utils/singletons/singleton_order_count.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';

import 'package:sizer/sizer.dart';

class WomenProductsScreen extends StatefulWidget {
  final Category category;
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const WomenProductsScreen(
      {Key? key,
      required this.token,
      required this.userData,
      required this.repository,
      required this.category,
      required this.cartOrderItemsCount})
      : super(key: key);

  @override
  _WomenProductsState createState() => _WomenProductsState();
}

class _WomenProductsState extends State<WomenProductsScreen> {
  // for ios
  double productCellWidth = 190;
  double productCellHeight = 240;

  Map<String, String> categoriesMap = {
    '6108f526ed3f4400227bed3d': "Платья",
    "6108f53ced3f4400227bed3f": "Топики",
    "6108f5a4ed3f4400227bed41": "Футболки",
    "6108f5b1ed3f4400227bed43": "Штаны",
    "6108f5c6ed3f4400227bed45": "Шорты"
  };

  Color _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);

  File? imageFile;
  List<File> imageFiles = [];
  List<String> imageFilesPaths = [];
  final picker = ImagePicker();

  late ProductsCubit _productsCubit;
  late List<Product> _products;

  List<Product>? _productsOnSearch = [];
  List<Product>? _productsOnFilter = [];

  List<String>? productsFilterOptionsList = [];
  List<String>? productsFilterOptionsSelectedList = [];

  int colorId = 0;

  late bool containsName;
  late bool containsMaterial;
  late bool containsCountry;

  late bool containsPrice;
  late bool containsColor;

  Timer? _debounce;

  int counter = 0;

  var colorsList = ["Белый", "Черный", "Красный"];
  var materialList = ["Кожа", "Ткань"];
  var countryList = ["США", "ЮАР", "Турция"];
// = colorsList.length - 1;
  late int colorsListLength;
  late int materialListLength;
  late int countryListLength;
//  materialList.length - 1;
//colorsListLength;
  late int colorsEndPoint;
  late int materialEndPoint;
  late int countryEndPoint;
  //colorsEndPoint + materialListLength;

  var _controllerName = TextEditingController();
  var _controllerPrice = TextEditingController();
  var _controllerColor = TextEditingController();
  var _controllerSizes = TextEditingController();
  var _controllerDescription = TextEditingController();
  var _controllerMaterial = TextEditingController();
  var _controllerCountryProducer = TextEditingController();
  var _controllerStyle = TextEditingController();
  var _controllerModelCharacteristics = TextEditingController();
  var _controllerDiscount = TextEditingController();

  var _controllerNameUpdate = TextEditingController();
  var _controllerPriceUpdate = TextEditingController();
  var _controllerColorUpdate = TextEditingController();
  var _controllerSizesUpdate = TextEditingController();
  var _controllerDescriptionUpdate = TextEditingController();
  var _controllerMaterialUpdate = TextEditingController();
  var _controllerCountryProducerUpdate = TextEditingController();
  var _controllerStyleUpdate = TextEditingController();
  var _controllerModelCharacteristicsUpdate = TextEditingController();

  var _controllerCountInStock = TextEditingController();

  var _controllerCountInStockUpdate = TextEditingController();

  var _controllerProducts = TextEditingController();

  final GlobalKey<FormState> _womenProductsFormKey = GlobalKey<FormState>();

  bool isInputEnabled = false;

  String newArrival = "Да";
  String recommended = "Да";
  String fashionCollection = "Все";
  List<String?> newArrivalOptions = ["Да", "Нет"];
  List<String?> recommendedOptions = ["Да", "Нет"];
  List<String?> fashionCollections = ["Все", "Версачи", "Он зи фло"];

  @override
  void initState() {
    super.initState();
    // = colorsList.length - 1;
    colorsListLength = colorsList.length - 1;

    materialListLength = materialList.length;

    countryListLength = countryList.length;
//  materialList.length - 1;
//colorsListLength;
    colorsEndPoint = colorsListLength;

    materialEndPoint = colorsEndPoint + materialListLength;

    countryEndPoint = materialEndPoint + countryListLength;
    //colorsEndPoint + materialListLength;

    _productsCubit = BlocProvider.of<ProductsCubit>(context);
    _productsCubit.fetchProducts(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      isInputEnabled = true;
    }
    SingletonCallbacks.refreshOrderCountCallBack = updateAfterReturn;
    print(SingletonOrderCount.orderCount);
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
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (!(state is ProductsLoaded)) {
            return CircularProgressIndicator();
          }
          _products = (state as ProductsLoaded).products!;
          //_favorites = (state as FavoritesInProductsLoaded).favorites!;

          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: APP_SCREEN_CONTENT_PADDING_H_WIDTH,
                vertical: APP_SCREEN_CONTENT_PADDING_V_WIDTH),
            child: ListView(
              shrinkWrap: true,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Container(
                    width: double.maxFinite,
                    child: Card(
                      child: TextField(
                        onChanged: _onSearchChanged,
                        controller: _controllerProducts,
                        cursorColor: PRIMARY_DARK_COLOR,
                        style: TextStyle(
                            color: PRIMARY_DARK_COLOR, fontSize: 12.sp),
                        decoration: new InputDecoration(
                            prefixIcon: Icon(Icons.search,
                                color: Color.fromRGBO(58, 67, 59, 0.8)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _controllerProducts.clear();
                                  _productsOnSearch!.clear();
                                  setState(() {});
                                },
                                icon: Icon(Icons.cancel_outlined,
                                    color: Color.fromRGBO(58, 67, 59, 0.8))),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                            ),
                            hintText: "Поиск"),
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: () {},
                      child: Card(
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: 2.10.w,
                                  right: 2.10.w,
                                  bottom: 2.h,
                                  top: 2.h),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Icon(Icons.filter_list,
                                      color: Color.fromRGBO(58, 67, 59, 0.8)),
                                  SizedBox(width: 3.75.w),
                                  Text("Фильтрация и сортировка",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(58, 67, 59, 0.8),
                                          fontSize: 12.sp)),
                                ],
                              ))),
                    )),
                if (_controllerProducts.text.isNotEmpty &&
                    _productsOnSearch!.length == 0)
                  Center(
                    child: Column(children: [
                      SizedBox(
                        height: 250,
                      ),
                      Text("Результаты не найдены",
                          style: TextStyle(
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'Merriweather-Regular',
                              fontSize: 12.sp)),
                    ]),
                  )
                else if (_products.isNotEmpty)
                  GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      //padding: EdgeInsets.symmetric(vertical: 15),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 1.25.h,
                          crossAxisCount: 2,
                          crossAxisSpacing: 2.25.w,
                          childAspectRatio: 5.w / 5.h),
                      itemCount: determineProductsLengthAndAdminStatus(),

                      //
                      itemBuilder: (BuildContext context, int index) {
                        if (_controllerProducts.text.isNotEmpty) {
                          // this is a for search list
                          if (index == _productsOnSearch!.length) {
                            return _buildAddNewProduct(
                                width: productCellWidth,
                                height: productCellHeight,
                                productsCubit: _productsCubit,
                                index: index);
                          }
                          return _buildWomanProductContainer(
                              width: 45.w,
                              height: 30.h,
                              discount: _products[index].discount,
                              productInfo: _productsOnSearch![index],
                              imagePath: _productsOnSearch![index].image,
                              clothProductName: _productsOnSearch![index].name,
                              clothPrice:
                                  _productsOnSearch![index].price.toString(),
                              isAdmin: widget.userData!.isAdmin,
                              index: index);
                        } else if (productsFilterOptionsSelectedList!
                            .isNotEmpty) {
                          if (index == _productsOnFilter!.length) {
                            return _buildAddNewProduct(
                                width: productCellWidth,
                                height: productCellHeight,
                                productsCubit: _productsCubit,
                                index: index);
                          }
                          return _buildWomanProductContainer(
                              width: 45.w,
                              height: 30.h,
                              productInfo: _productsOnFilter![index],
                              imagePath: _productsOnFilter![index].image,
                              clothProductName: _productsOnFilter![index].name,
                              discount: _products[index].discount,
                              clothPrice:
                                  _productsOnFilter![index].price.toString(),
                              isAdmin: widget.userData!.isAdmin,
                              index: index);
                        } else {
                          // this is for a typical list without search
                          if (index == _products.length) {
                            return _buildAddNewProduct(
                                width: productCellWidth,
                                height: productCellHeight,
                                productsCubit: _productsCubit,
                                index: index);
                          }

                          return _buildWomanProductContainer(
                              width: 45.w,
                              height: 30.h,
                              productInfo: _products[index],
                              imagePath: _products[index].image,
                              clothProductName: _products[index].name,
                              clothPrice: _products[index].price.toString(),
                              discount: _products[index].discount,
                              isAdmin: widget.userData!.isAdmin,
                              index: index);
                        }
                      }),
                (_products.isEmpty && widget.userData!.isAdmin == true)
                    ? _buildAddNewProduct(
                        width: productCellWidth,
                        height: productCellHeight,
                        productsCubit: _productsCubit,
                        index: 0)
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWomanProductContainer({
    required double width,
    required double height,
    required Product productInfo,
    required String imagePath,
    required String clothProductName,
    required String clothPrice,
    required bool isAdmin,
    required int index,
    required double discount,
  }) {
    return InkWell(
      onLongPress: () => (isAdmin == true)
          ? {
              displayDialogMenu(context, "Внести изменения", _productsCubit,
                  widget.token!, productInfo.id, index)
            }
          : {},
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                ProductDetailCubit(repository: widget.repository),
            child: WomenProductScreen(
                productInfo: productInfo,
                token: widget.token,
                userData: widget.userData,
                repository: widget.repository,
                cartOrderItemsCount: widget.cartOrderItemsCount),
          ),
        ));
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //alignment: WrapAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    color: Colors.transparent,
                    child: (productInfo.id != '')
                        ? CachedNetworkImage(
                            cacheManager: CacheManager(Config('customCacheKey',
                                stalePeriod: Duration(days: 7))),
                            key: UniqueKey(),
                            imageUrl: imagePath,
                            fit: BoxFit.cover,
                            height: height,
                            width: width,
                            placeholder: (context, url) => Container(
                                color: Color.fromRGBO(255, 250, 250, 0.5)),
                            memCacheHeight: 700,
                          )
                        : Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            height: height,
                            width: width,
                          )),
              ),
              /*
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: CircleAvatar(
                        backgroundColor: WHITE_COLOR,
                        radius: 20,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.favorite_outline,
                              size: 20, color: PRIMARY_DARK_COLOR),
                          onPressed: () => {
                            _productsCubit.postFavorite(
                                token: widget.token,
                                user: widget.userData,
                                products: [productInfo.id]).then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Сохранено'),
                                duration: const Duration(seconds: 1),
                              ));
                            }),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              */
              SizedBox(
                height: 1.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(clothProductName,
                          style: TextStyle(
                            color: Color.fromRGBO(58, 67, 59, 1),
                            fontFamily: 'Merriweather-Regular',
                          )),
                      InkWell(
                        onTap: () {
                          _productsCubit.postFavorite(
                              token: widget.token,
                              user: widget.userData,
                              products: [productInfo.id]).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 1),
                            ));
                          });
                        },
                        child: Icon(Icons.favorite_outline,
                            size: 5.5.w, color: PRIMARY_DARK_COLOR),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      (discount > 0)
                          ? Text(
                              (double.parse(clothPrice) -
                                          (double.parse(clothPrice) * discount))
                                      .toString() +
                                  " KZT",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'SolomonSans-SemiBold',
                                  fontSize: 11.sp))
                          : Container(),
                      SizedBox(
                        width: 1.w,
                      ),
                      Text(clothPrice.toString() + " KZT",
                          style: TextStyle(
                              decoration: (discount > 0)
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: (discount > 0)
                                  ? Color.fromRGBO(58, 67, 59, 0.5)
                                  : Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'SolomonSans-SemiBold',
                              fontSize: (discount > 0) ? 9.sp : 11.sp)),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Widget _buildAddNewProduct(
      {required double height,
      required double width,
      required ProductsCubit productsCubit,
      required int index}) {
    return InkWell(
      onTap: () => {displayDialogAdd(context, productsCubit, index)},
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: height,
            width: width,
            child: Icon(
              Icons.add,
              color: Color.fromRGBO(58, 67, 59, 0.8),
              size: 100,
            ),
          )
        ],
      ),
    );
  }

  void displayDialogAdd(
          BuildContext context, ProductsCubit productsCubit, int index) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 4.w),
            title: Text("Добавить продукт"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter _setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        padding: EdgeInsets.zero,
                        child: (imageFile == null)
                            ? Center(
                                child: InkWell(
                                  onTap: () {
                                    chooseImageAdd(ImageSource.gallery,
                                        productsCubit, index, true, _setState);
                                  },
                                  child: Icon(Icons.add_a_photo_outlined,
                                      size: 20.w, color: PRIMARY_DARK_COLOR),
                                ),
                              )
                            : Image.file(imageFile!),
                        width: 25.w,
                        height: 14.h),
                    OutlinedButton(
                      child: Text('Добавить фотографии',
                          style: TextStyle(
                              fontSize: 11.5.sp,
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'SolomonSans-SemiBold')),
                      onPressed: () {
                        chooseImageAdd(ImageSource.gallery, productsCubit,
                            index, false, _setState);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            width: 0.2.w, color: Color.fromRGBO(58, 67, 59, 1)),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 30.h,
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 1.25.w,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1.h),
                          itemCount: imageFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (imageFiles.length != 0)
                                ? Image.file(
                                    imageFiles[index],
                                    width: 1.w,
                                    height: 1.h,
                                    fit: BoxFit.cover,
                                  )
                                : Container();
                          }),
                    ),
                    Form(
                        key: _womenProductsFormKey,
                        child: Column(children: [
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Название продукта",
                              hint: "Название продукта",
                              controller: _controllerName,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Цена",
                              hint: "Цена",
                              controller: _controllerPrice,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Цвет",
                              hint: "Цвет",
                              controller: _controllerColor,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Размеры",
                              hint: "XS/S/M",
                              controller: _controllerSizes,
                              isInputEnabled: isInputEnabled,
                              validator:
                                  WomenProductsFormsValidator().validateSizes),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Описание",
                              hint: "Описание",
                              controller: _controllerDescription,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Материал",
                              hint: "Материал",
                              controller: _controllerMaterial,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Производитель",
                              hint: "Производитель",
                              controller: _controllerCountryProducer,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Фасон",
                              hint: "Фасон",
                              controller: _controllerStyle,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Характеристики",
                              hint: "180\n60\nM",
                              controller: _controllerModelCharacteristics,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateModelCharacteristics),
                          CustomTextFieldForm().buildTextFormField(
                            formName: "Категория",
                            hint: "Категория",
                            controller: TextEditingController(),
                            isInputEnabled: isInputEnabled,
                            validator: WomenProductsFormsValidator()
                                .validateFieldForEmptySpace,
                            savedContent:
                                categoriesMap[widget.category.id].toString(),
                          ),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Количество",
                              hint: "Количество",
                              controller: _controllerCountInStock,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          CustomTextFieldForm().buildTextFormField(
                              formName: "Скидка",
                              hint: "0.1 = 10%",
                              controller: _controllerDiscount,
                              isInputEnabled: isInputEnabled,
                              validator: WomenProductsFormsValidator()
                                  .validateFieldForEmptySpace),
                          StatefulBuilder(builder: (BuildContext context,
                              StateSetter setStateDropDown) {
                            return Column(
                              children: [
                                _buildDropDown(
                                    "Коллекция",
                                    "Коллекция",
                                    fashionCollection,
                                    fashionCollections,
                                    setStateDropDown),
                                _buildDropDown(
                                    "Новый товар",
                                    "Новый товар",
                                    newArrival,
                                    newArrivalOptions,
                                    setStateDropDown),
                                _buildDropDown(
                                    "Рекомендуемый",
                                    "Рекомендуемый",
                                    recommended,
                                    recommendedOptions,
                                    setStateDropDown),
                              ],
                            );
                          }),
                        ])),
                    OutlinedButton(
                      child: Text('Добавить продукт',
                          style: TextStyle(
                              fontSize: 11.5.sp,
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'SolomonSans-SemiBold')),
                      onPressed: () {
                        if (_womenProductsFormKey.currentState!.validate()) {
                          print(imageFiles);
                          print(imageFile);
                          productsCubit
                              .postProduct(
                            token: widget.token,
                            categoryId: widget.category.id,
                            name: _controllerName.text,
                            image: imageFile,
                            images: imageFiles,
                            price: _controllerPrice.text,
                            color: _controllerColor.text,
                            sizes: _controllerSizes.text,
                            description: _controllerDescription.text,
                            material: _controllerMaterial.text,
                            discount: double.parse(_controllerDiscount.text),
                            recommended: (recommended == "Да") ? true : false,
                            newArrival: (newArrival == "Да") ? true : false,
                            fashionCollection: fashionCollection,
                            countryProducer: _controllerCountryProducer.text,
                            style: _controllerStyle.text,
                            modelCharacteristics: parseToModelCharObject(
                                _controllerModelCharacteristics.text),
                            countInStock: _controllerCountInStock.text,
                          )
                              .then((_) {
                            Navigator.of(context).pop();

                            imageFiles.forEach((imageFileFromArray) => {
                                  print(imageFileFromArray),
                                  imageFilesPaths.add(imageFileFromArray.path)
                                });

                            print(imageFile!.path + " PRODUCTS SINGLE");
                            print(imageFilesPaths.toString() +
                                " PRODUCTS MULTIPLE");

                            _products.add(Product(
                              category: widget.category,
                              name: _controllerName.text,
                              image: imageFile!.path,
                              images: imageFilesPaths,
                              price: int.parse(_controllerPrice.text),
                              color: _controllerColor.text,
                              sizes: _controllerSizes.text,
                              description: _controllerDescription.text,
                              material: _controllerMaterial.text,
                              discount: double.parse(_controllerDiscount.text),
                              recommended: (recommended == "Да") ? true : false,
                              newArrival: (newArrival == "Да") ? true : false,
                              fashionCollection: fashionCollection,
                              countryProducer: _controllerCountryProducer.text,
                              style: _controllerStyle.text,
                              modelCharacteristics: parseToModelCharObject(
                                  _controllerModelCharacteristics.text),
                              countInStock:
                                  int.parse(_controllerCountInStock.text),
                              id: '',
                              isFeatured: false,
                            ));

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Продукт создан'),
                              duration: const Duration(seconds: 2),
                            ));

                            setState(() {
                              //_productsCubit.fetchProducts(widget.category.id);
                            });

                            imageFile = null;
                            imageFiles = [];
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

  Widget _buildDropDown(
      dropDownName, dropDownHint, changingValue, items, StateSetter _setState) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dropDownName,
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Regular',
                  fontSize: 11.sp)),
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            width: double.infinity,
            child: DropdownButton(
                isExpanded: true,
                value: changingValue,
                items: items.map<DropdownMenuItem<String>>((element) {
                  return DropdownMenuItem<String>(
                    value: element,
                    child: Text(element,
                        style: TextStyle(
                            fontSize: 11.5.sp,
                            color: Color.fromRGBO(58, 67, 59, 1),
                            fontFamily: 'SolomonSans-SemiBold')),
                  );
                }).toList(),
                hint: Text(dropDownHint,
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold')),
                onChanged: (element) {
                  _setState(() {
                    if (dropDownName == "Коллекция") {
                      fashionCollection = element as String;
                    } else if (dropDownName == "Новый товар") {
                      newArrival = element as String;
                    } else if (dropDownName == "Рекомендуемый") {
                      recommended = element as String;
                    }
                  });
                  print(newArrival);
                  print(fashionCollection);
                  print(recommended);
                }),
          ),
        ],
      ),
    );
  }

  void displayFilterDialog() {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  title: Text("Фильтр и сортировка"),
                  content: Container(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*
                        _buildExpansionTile( chosenValue: colorId, title: "Цвета", listOfItems: [
                          RadioItem(name: "Белый", index: 0),
                          RadioItem(name: "Черный", index: 1),
                          RadioItem(name: "Черный", index: 2),
                          RadioItem(name: "Черный", index: 3),
                          
                        
                       
                       ),
                        */
                      ],
                    ),
                  ));
            }));
  }

  Widget _buildExpansionTile({
    required String title,
    required List<RadioItem> listOfItems,
    required int chosenValue,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: StatefulBuilder(builder: (_context, _setState) {
        return InkWell(
          child: ExpansionTile(
              tilePadding: EdgeInsets.all(0),
              onExpansionChanged: (expanded) {
                _setState(() {
                  if (expanded) {
                    _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
                  } else {
                    _expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
                  }
                });
              },
              iconColor: _expansionTileTextColor,
              title: Text(
                title,
                style: TextStyle(
                    color: _expansionTileTextColor,
                    fontFamily: 'Merriweather-Bold',
                    fontSize: 11.5.sp),
              ),
              children: <Widget>[
                Container(
                    child: RadioGroup(
                        radioGroupList: listOfItems, chosenValue: chosenValue))
              ]),
        );
      }),
    );
  }

  void displayDialogMenu(BuildContext context, String title,
          ProductsCubit productsCubit, String token, String id, int index) =>
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
                          _products[index], productsCubit);
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
                  SizedBox(height: 2.h),
                  InkWell(
                    onLongPress: () {
                      productsCubit
                          .deleteProduct(id: id, token: token)
                          .then((_) {
                        Navigator.of(context).pop();
                        _products.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Продукт удален'),
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
          String token, Product product, ProductsCubit productsCubit) =>
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
                            width: 25.w,
                            height: 14.h,
                            padding: EdgeInsets.zero,
                            child: InkWell(
                              onTap: () {
                                chooseImageUpdate(
                                    ImageSource.gallery,
                                    productsCubit,
                                    index,
                                    token,
                                    product,
                                    id,
                                    _setState);
                              },
                              child: (imageFile == null)
                                  ? Center(
                                      child: CachedNetworkImage(
                                          imageUrl: product.image))
                                  : Image.file(imageFile!),
                            )),
                        Form(
                            key: _womenProductsFormKey,
                            child: Column(children: [
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Название продукта",
                                  hint: "Название продукта",
                                  controller: _controllerName,
                                  savedContent: product.name,
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Цена",
                                  hint: "Цена",
                                  controller: _controllerPrice,
                                  savedContent: product.price.toString(),
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Цвет",
                                  hint: "Цвет",
                                  controller: _controllerColor,
                                  savedContent: product.color,
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Размеры",
                                  hint: "XS/S/M",
                                  controller: _controllerSizes,
                                  savedContent: product.sizes,
                                  validator: WomenProductsFormsValidator()
                                      .validateSizes),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Описание",
                                  hint: "Описание",
                                  controller: _controllerDescription,
                                  savedContent: product.description,
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Материал",
                                  hint: "Материал",
                                  controller: _controllerMaterial,
                                  savedContent: product.material,
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Производитель",
                                  hint: "Производитель",
                                  controller: _controllerCountryProducer,
                                  savedContent: product.countryProducer,
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Фасон",
                                  hint: "Фасон",
                                  controller: _controllerStyle,
                                  savedContent: product.style,
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Характеристики",
                                  hint: "180\n60\nM",
                                  controller: _controllerModelCharacteristics,
                                  savedContent: _convertJsonToString(
                                      product.modelCharacteristics),
                                  validator: WomenProductsFormsValidator()
                                      .validateModelCharacteristics),
                              CustomTextFieldForm().buildTextFormField(
                                formName: "Категория",
                                hint: "Категория",
                                controller: TextEditingController(),
                                validator: WomenProductsFormsValidator()
                                    .validateFieldForEmptySpace,
                                savedContent: categoriesMap[widget.category.id]
                                    .toString(),
                              ),
                              CustomTextFieldForm().buildTextFormField(
                                  formName: "Количество",
                                  hint: "Количество",
                                  controller: _controllerCountInStock,
                                  savedContent: product.countInStock.toString(),
                                  validator: WomenProductsFormsValidator()
                                      .validateFieldForEmptySpace),
                            ])),
                        OutlinedButton(
                          child: Text('Обновить продукт',
                              style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: Color.fromRGBO(58, 67, 59, 1),
                                  fontFamily: 'SolomonSans-SemiBold')),
                          onPressed: () {
                            productsCubit
                                .updateProduct(
                              token: widget.token,
                              categoryId: widget.category.id,
                              name: _controllerNameUpdate.text,
                              image: imageFile,
                              price: _controllerPriceUpdate.text,
                              color: _controllerColorUpdate.text,
                              sizes: _controllerSizesUpdate.text,
                              description: _controllerDescriptionUpdate.text,
                              material: _controllerMaterialUpdate.text,
                              countryProducer:
                                  _controllerCountryProducerUpdate.text,
                              style: _controllerStyleUpdate.text,
                              modelCharacteristics: parseToModelCharObject(
                                  _controllerModelCharacteristicsUpdate.text),
                              countInStock: _controllerCountInStockUpdate.text,
                              id: product.id,
                            )
                                .then((_) {
                              Navigator.of(context).pop();
                              _products[index].category = widget.category;
                              _products[index].name =
                                  _controllerNameUpdate.text;
                              if (imageFile != null) {
                                _products[index].image = imageFile!.path;
                                _products[index].id = '';
                              } else {
                                _products[index].id = 'image is not loaded';
                              }

                              _products[index].price =
                                  int.parse(_controllerPriceUpdate.text);
                              _products[index].color =
                                  _controllerColorUpdate.text;
                              _products[index].sizes =
                                  _controllerSizesUpdate.text;
                              _products[index].description =
                                  _controllerDescriptionUpdate.text;
                              _products[index].material =
                                  _controllerMaterialUpdate.text;
                              _products[index].countryProducer =
                                  _controllerCountryProducerUpdate.text;
                              _products[index].style =
                                  _controllerStyleUpdate.text;
                              _products[index].modelCharacteristics =
                                  parseToModelCharObject(
                                      _controllerModelCharacteristicsUpdate
                                          .text);
                              _products[index].countInStock =
                                  int.parse(_controllerCountInStockUpdate.text);

                              _products[index].isFeatured = false;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Продукт обновлен'),
                                duration: const Duration(seconds: 2),
                              ));
                              setState(() {});
                            });
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
                }),
              ));

  Future chooseImageAdd(ImageSource source, ProductsCubit productsCubit,
      int index, bool singleFile, StateSetter _setState) async {
    if (singleFile == true) {
      final pickedFile = await picker.pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          imageFile = File(pickedFile.path);
          _setState(() {});
          //Navigator.of(context).pop();
          //displayDialogAdd(context, productsCubit, index);
        } else {
          print("No image is selected");
        }
      });
    } else {
      final pickedFile = await picker.pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          imageFiles.add(File(pickedFile.path));
          _setState(() {});
          //Navigator.of(context).pop();
          //displayDialogAdd(context, productsCubit, index);
        } else {
          print("No image is selected");
        }
      });
    }
  }

  Future chooseImageUpdate(
      ImageSource source,
      ProductsCubit categoriesCubit,
      int index,
      String token,
      Product product,
      String id,
      StateSetter _setState) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        _setState(() {});
        //Navigator.of(context).pop();
        //displayDialogUpdate(
        //context, id, index, token, product, categoriesCubit);
      } else {
        print("No image is selected");
      }
    });
  }

  ModelCharacteristics parseToModelCharObject(modelCharsString) {
    var modelCharsArr = modelCharsString.split('\n');
    print(modelCharsArr);
    var modelCharHeight = int.parse(modelCharsArr[0]);
    var modelCharWeight = int.parse(modelCharsArr[1]);
    var modelCharSize = modelCharsArr[2];

    return ModelCharacteristics(
        modelHeight: modelCharHeight,
        modelWeight: modelCharWeight,
        modelSize: modelCharSize);
  }

  _convertJsonToString(jsonObject) {
    return jsonObject.modelHeight.toString() +
        "\n" +
        jsonObject.modelWeight.toString() +
        "\n" +
        jsonObject.modelSize;
  }

  void updateAfterReturn() {
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        if (_productsOnFilter!.isEmpty) {
          _productsOnSearch = _products.where((element) {
            containsName =
                element.name.toLowerCase().contains(query.toLowerCase());
            containsPrice =
                element.price.toString().contains(query.toLowerCase());

            containsColor = element.color.contains(query);
            if (containsName) {
              //realIndexFromSearch = indexCounter;
              return containsName;
            } else if (containsPrice) {
              //realIndexFromSearch = indexCounter;

              return containsPrice;
            } else if (containsColor) {
              //realIndexFromSearch = indexCounter;

              return containsColor;
            } else
              return false;
          }).toList();
        } else {
          _productsOnSearch = _productsOnFilter!.where((element) {
            containsName =
                element.name.toLowerCase().contains(query.toLowerCase());
            containsPrice =
                element.price.toString().contains(query.toLowerCase());

            containsColor = element.color.contains(query);
            if (containsName) {
              //realIndexFromSearch = indexCounter;
              return containsName;
            } else if (containsPrice) {
              //realIndexFromSearch = indexCounter;

              return containsPrice;
            } else if (containsColor) {
              //realIndexFromSearch = indexCounter;

              return containsColor;
            } else
              return false;
          }).toList();
        }
      });
    });
  }

  int determineProductsLengthAndAdminStatus() {
    // if true admin status
    if (widget.userData!.isAdmin == true) {
      // if true we give + to add products
      if (_controllerProducts.text.isNotEmpty) {
        return _productsOnSearch!.length + 1;
      } else if (productsFilterOptionsSelectedList!.isNotEmpty) {
        return _productsOnFilter!.length + 1;
      } else {
        return _products.length + 1;
      }

      // else true admin status not
    } else {
      // else we do not give + to add products
      if (_controllerProducts.text.isNotEmpty) {
        return _productsOnSearch!.length;
      } else {
        return _products.length;
      }
    }
  }
}

// void _openFilterDialog() async {
//     counter = 0;
//     var productsFilterLists = [colorsList, materialList, countryList];
//     if (productsFilterOptionsList!.isEmpty)
//       productsFilterLists.forEach((list) {
//         list.forEach((listElement) {
//           productsFilterOptionsList!.add(listElement);
//         });
//       });

//     print(productsFilterOptionsList);

//     await FilterListDialog.display<String>(context,
//         listData: productsFilterOptionsList!,
//         selectedListData: productsFilterOptionsSelectedList,
//         height: 480,
//         hideCloseIcon: true,
//         hideSelectedTextCount: true,
//         headlineText: "Выберите цвет",
//         applyButtonText: "Применить",
//         resetButtonText: "Сброс",
//         allButtonText: "Все",
//         selectedItemsText: "Выбранные фильтры",
//         closeIconColor: PRIMARY_DARK_COLOR,
//         headerTextColor: PRIMARY_DARK_COLOR,
//         selectedTextBackgroundColor: PRIMARY_DARK_COLOR,
//         applyButonTextBackgroundColor: PRIMARY_DARK_COLOR,
//         applyButtonTextStyle:
//             TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
//         selectedChipTextStyle:
//             TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
//         unselectedChipTextStyle:
//             TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
//         controlButtonTextStyle:
//             TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
//         headerTextStyle:
//             TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
//         searchFieldTextStyle: TextStyle(
//             fontFamily: "SolomonSans-SemiBold", fontSize: 16, height: 1.5),
//         //backgroundColor: PRIMARY_DARK_COLOR,
//         //searchFieldBackgroundColor: PRIMARY_DARK_COLOR,

//         searchFieldHintText: "Искать цвет здесь", choiceChipLabel: (item) {
//       return item;
//     }, validateSelectedItem: (list, val) {
//       return list!.contains(val);
//     }, onItemSearch: (list, text) {
//       if (list!.any(
//           (element) => element.toLowerCase().contains(text.toLowerCase()))) {
//         return list
//             .where(
//                 (element) => element.toLowerCase().contains(text.toLowerCase()))
//             .toList();
//       } else {
//         return [];
//       }
//     }, onApplyButtonClick: (list) {
//       _productsOnFilter = [];
//       _controllerProducts.text = "";
//       if (list != null) {
//         setState(() {
//           // filtering for everything

//           var hashmapa = {
//             "Белый": 0,
//             "Черный": 1,
//             "Красный": 2,
//             "Кожа": 3,
//             "Ткань": 4,
//             "США": 5,
//             "ЮАР": 6,
//             "Турция": 7
//           };

//           var hashMapaFilteringCategories = {
//             "Белый": "Сolor",
//             "Черный": "Color",
//             "Красный": "Color",
//             "Кожа": "Material",
//             "Ткань": "Material",
//             "США": "Country",
//             "ЮАР": "Country",
//             "Турция": "Country"
//           };

//           var listColors = [];
//           var listMaterials = [];
//           var listCountries = [];

//           productsFilterOptionsSelectedList = List.from(list);

//           for (String filteringOption in productsFilterOptionsSelectedList!) {
//             if (hashmapa[filteringOption]! <= colorsEndPoint) {
//               listColors.add(hashMapaFilteringCategories[filteringOption]);
//             } else if (hashmapa[filteringOption]! > colorsEndPoint &&
//                 hashmapa[filteringOption]! <= materialEndPoint) {
//               listMaterials.add(hashMapaFilteringCategories[filteringOption]);
//             } else if (hashmapa[filteringOption]! > materialEndPoint &&
//                 hashmapa[filteringOption]! <= countryEndPoint) {
//               listMaterials.add(hashMapaFilteringCategories[filteringOption]);
//             }
//           }
//           if (productsFilterOptionsSelectedList!.isNotEmpty) {
//             _products
//                 .where((product) {
//                   List<bool> acceptedCombos = [];
//                   for (String filteringOption
//                       in productsFilterOptionsSelectedList!) {
//                     if (hashmapa[filteringOption]! <= colorsEndPoint) {
//                       containsColor = product.color.contains(filteringOption);

//                       if (containsColor) {
//                         acceptedCombos.add(containsColor);
//                       } else
//                         acceptedCombos.add(false);
//                     } else if (hashmapa[filteringOption]! > colorsEndPoint &&
//                         hashmapa[filteringOption]! <= materialEndPoint) {
//                       containsMaterial =
//                           product.material.contains(filteringOption);

//                       if (containsMaterial) {
//                         acceptedCombos.add(containsMaterial);
//                       } else
//                         acceptedCombos.add(false);
//                     } else if (hashmapa[filteringOption]! > materialEndPoint &&
//                         hashmapa[filteringOption]! <= countryEndPoint) {
//                       containsCountry =
//                           product.countryProducer.contains(filteringOption);

//                       if (containsCountry) {
//                         acceptedCombos.add(containsCountry);
//                       } else
//                         acceptedCombos.add(false);
//                     } else {}
//                   }

//                   print(listColors.length.toString() + " LENGTH LISTCOLORS");
//                   print(listMaterials.length.toString() +
//                       " LENGTH LISTMATERIALS");
//                   print(listCountries.length.toString() +
//                       " LENGTH LISTCOUNTRIES");

//                   print(acceptedCombos);

//                   List<bool> trueList = [];
//                   List<bool> falseList = [];

//                   for (int comboIndex = 0;
//                       comboIndex != acceptedCombos.length;
//                       comboIndex++) {
//                     print(" BLYAT");
//                     if (acceptedCombos[comboIndex] == true) {
//                       trueList.add(true);
//                     } else {
//                       falseList.add(false);
//                     }
//                   }

//                   print(trueList.toString() +
//                       " TRUE LISTI " +
//                       trueList.length.toString() +
//                       " DLINA ");
//                   print(falseList.toString() +
//                       " FALSE LISTI " +
//                       falseList.length.toString() +
//                       " DLINA ");

//                   if (trueList.isEmpty) {
//                     return false;
//                   } else {
//                     if (listColors.length == acceptedCombos.length ||
//                         listMaterials.length == acceptedCombos.length ||
//                         listCountries.length == acceptedCombos.length) {
//                       return true;
//                     }
//                     if (trueList.length >= falseList.length) {
//                       return true;
//                     } else {
//                       return false;
//                     }
//                   }

//                   // trueList.length >= falseList.length is good when there are 4 filtering categories
//                   // and they are 2 different types of them by 2
//                 })
//                 .toList()
//                 .forEach((element) {
//                   _productsOnFilter!.add(element);
//                 });
//             /*
//             for (String filteringOption in productsFilterOptionsSelectedList!) {
//               print(hashmapa[filteringOption]!);
//               print(materialEndPoint.toString() + " FKSd");
//               print(colorsEndPoint.toString() + " FFFFFKSd");

//               // finding all by each короче вводишь в фильтр красный и зеленый - он находит все красное и зеленое
//               // ставишь кожу и красное - он находит все кожанное и красное, но не красно-кожанное

// /*
//               if (hashmapa[filteringOption]! <= colorsEndPoint) {
//                 print("COLOR");
//                 _products
//                     .where((product) {
//                       containsColor = product.color.contains(filteringOption);
//                       if (containsColor) {
//                         //realIndexFromSearch = indexCounter;
//                         return containsColor;
//                       } else
//                         return false;
//                     })
//                     .toList()
//                     .forEach((element) {
//                       _productsOnFilter!.add(element);
//                     });
//               } else if (hashmapa[filteringOption]! > colorsEndPoint &&
//                   hashmapa[filteringOption]! <= materialEndPoint) {
//                 print("MATERIAL");
//                 _products
//                     .where((product) {
//                       containsMaterial =
//                           product.material.contains(filteringOption);
//                       if (containsMaterial) {
//                         //realIndexFromSearch = indexCounter;
//                         return containsMaterial;
//                       } else
//                         return false;
//                     })
//                     .toList()
//                     .forEach((element) {
//                       _productsOnFilter!.add(element);
//                     });
//               }
//               */

//               print(_productsOnFilter.toString() + " XNJ");
//             }
//             */
//           } else {}
//           // filtering for everything
//         });
//       }
//       Navigator.pop(context);
//     });
//   }
