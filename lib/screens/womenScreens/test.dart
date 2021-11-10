/*
mport 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/cubit/product_detail_cubit.dart';
import 'package:rosemary/cubit/products_cubit.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/modelCharacteristics.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/radioItem.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';
import 'package:rosemary/screens/singleScreens/shopping_cart_screen.dart';
import 'package:rosemary/screens/womenScreens/women_product_screen.dart';
import 'package:rosemary/utils/custom_app_bar.dart';
import 'package:rosemary/utils/custom_drop_down.dart';
import 'package:rosemary/utils/radio_group.dart';
import 'package:rosemary/utils/singleton_callbacks.dart';
import 'package:rosemary/utils/singleton_order_count.dart';
import 'package:rosemary/utils/text_form_field_post.dart';
import '../../navigation_drawer_widget.dart';
import '../singleScreens/favorites_screen.dart';

class Test extends StatefulWidget {
  final Category category;
  final String? token;
  final User? userData;
  final Repository repository;

  final int? cartOrderItemsCount;

  const Test(
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

class _WomenProductsState extends State<Test> {
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

  List<String> colorsList = [];
  List<String>? selectedColorsList = [];

  int colorId = 0;

  late bool containsName;
  late bool containsPrice;
  late bool containsColor;

  Timer? _debounce;

  var _controllerName = TextEditingController();
  var _controllerPrice = TextEditingController();
  var _controllerColor = TextEditingController();
  var _controllerSizes = TextEditingController();
  var _controllerDescription = TextEditingController();
  var _controllerMaterial = TextEditingController();
  var _controllerCountryProducer = TextEditingController();
  var _controllerStyle = TextEditingController();
  var _controllerModelCharacteristics = TextEditingController();

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

  @override
  void initState() {
    super.initState();

    _productsCubit = BlocProvider.of<ProductsCubit>(context);
    _productsCubit.fetchProducts(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
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
            return Center(child: CircularProgressIndicator());
          }
          _products = (state as ProductsLoaded).products!;

          return ListView(
            shrinkWrap: true,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                child: Container(
                  width: double.maxFinite,
                  child: Card(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      controller: _controllerProducts,
                      cursorColor: PRIMARY_DARK_COLOR,
                      style: TextStyle(color: PRIMARY_DARK_COLOR),
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
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
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
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: InkWell(
                    onTap: () {
                      _openFilterDialog();
                    },
                    child: Card(
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 15, top: 15),
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                Icon(Icons.filter_list,
                                    color: Color.fromRGBO(58, 67, 59, 0.8)),
                                SizedBox(width: 15),
                                Text("Фильтрация и сортировка",
                                    style: TextStyle(
                                        color: Color.fromRGBO(58, 67, 59, 0.8),
                                        fontSize: 16)),
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
                            fontSize: 16)),
                  ]),
                )
              else if (_products.isNotEmpty)
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    //padding: EdgeInsets.symmetric(vertical: 15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.5),
                    ),
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
                            width: productCellWidth,
                            height: productCellHeight,
                            productInfo: _productsOnSearch![index],
                            imagePath: _productsOnSearch![index].image,
                            clothProductName: _productsOnSearch![index].name,
                            clothPrice:
                                _productsOnSearch![index].price.toString(),
                            isAdmin: widget.userData!.isAdmin,
                            index: index);
                      } else if (selectedColorsList!.isNotEmpty) {
                        if (index == _productsOnFilter!.length) {
                          return _buildAddNewProduct(
                              width: productCellWidth,
                              height: productCellHeight,
                              productsCubit: _productsCubit,
                              index: index);
                        }
                        return _buildWomanProductContainer(
                            width: productCellWidth,
                            height: productCellHeight,
                            productInfo: _productsOnFilter![index],
                            imagePath: _productsOnFilter![index].image,
                            clothProductName: _productsOnFilter![index].name,
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
                            width: productCellWidth,
                            height: productCellHeight,
                            productInfo: _products[index],
                            imagePath: _products[index].image,
                            clothProductName: _products[index].name,
                            clothPrice: _products[index].price.toString(),
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
          );
        },
      ),
    );
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
      } else if (selectedColorsList!.isNotEmpty) {
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

  void _openFilterDialog() async {
    colorsList = ["Белый", "Черный", "Красный", "Желтый"];
    await FilterListDialog.display<String>(context,
        listData: colorsList,
        selectedListData: selectedColorsList,
        height: 480,
        hideCloseIcon: true,
        hideSelectedTextCount: true,
        headlineText: "Выберите цвет",
        applyButtonText: "Применить",
        resetButtonText: "Сброс",
        allButtonText: "Все",
        selectedItemsText: "Выбранные фильтры",
        closeIconColor: PRIMARY_DARK_COLOR,
        headerTextColor: PRIMARY_DARK_COLOR,
        selectedTextBackgroundColor: PRIMARY_DARK_COLOR,
        applyButonTextBackgroundColor: PRIMARY_DARK_COLOR,
        applyButtonTextStyle:
            TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
        selectedChipTextStyle:
            TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
        unselectedChipTextStyle:
            TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
        controlButtonTextStyle:
            TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
        headerTextStyle:
            TextStyle(fontFamily: "SolomonSans-SemiBold", fontSize: 16),
        searchFieldTextStyle: TextStyle(
            fontFamily: "SolomonSans-SemiBold", fontSize: 16, height: 1.5),
        //backgroundColor: PRIMARY_DARK_COLOR,
        //searchFieldBackgroundColor: PRIMARY_DARK_COLOR,

        searchFieldHintText: "Искать цвет здесь", choiceChipLabel: (item) {
      return item;
    }, validateSelectedItem: (list, val) {
      return list!.contains(val);
    }, onItemSearch: (list, text) {
      if (list!.any(
          (element) => element.toLowerCase().contains(text.toLowerCase()))) {
        return list
            .where(
                (element) => element.toLowerCase().contains(text.toLowerCase()))
            .toList();
      } else {
        return [];
      }
    }, onApplyButtonClick: (list) {
      _productsOnFilter = [];
      _controllerProducts.text = "";
      if (list != null) {
        setState(() {
          //print(selectedColorsList);

          // filtering
          selectedColorsList = List.from(list);
          if (selectedColorsList!.isNotEmpty) {
            for (String selectedColor in selectedColorsList!) {
              _products
                  .where((product) {
                    containsColor = product.color.contains(selectedColor);
                    if (containsColor) {
                      //realIndexFromSearch = indexCounter;
                      return containsColor;
                    } else
                      return false;
                  })
                  .toList()
                  .forEach((element) {
                    _productsOnFilter!.add(element);
                  });

              print(_productsOnFilter);
            }
          } else {}
        });
      }
      Navigator.pop(context);
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //alignment: WrapAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    Container(
                        color: Colors.transparent,
                        child: (productInfo.id != '')
                            ? CachedNetworkImage(
                                cacheManager: CacheManager(Config(
                                    'customCacheKey',
                                    stalePeriod: Duration(days: 7))),
                                key: UniqueKey(),
                                imageUrl: imagePath,
                                fit: BoxFit.cover,
                                height: height,
                                width: width,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey),
                                memCacheHeight: 250,
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                height: height,
                                width: width,
                              )),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Сохранено'),
                              duration: const Duration(seconds: 2),
                            ))
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(clothProductName,
                  style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                  )),
              OutlinedButton(
                child: Text(clothPrice,
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold')),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
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
                )),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
                ),
              ),
            ],
          )),
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
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
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
                                        productsCubit, index, true);
                                  },
                                  child: Icon(Icons.add_a_photo_outlined,
                                      size: 80, color: PRIMARY_DARK_COLOR),
                                ),
                              )
                            : Image.file(imageFile!),
                        width: 200,
                        height: 100),
                    OutlinedButton(
                      child: Text('Добавить фотографии',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'SolomonSans-SemiBold')),
                      onPressed: () {
                        chooseImageAdd(
                            ImageSource.gallery, productsCubit, index, false);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 250,
                      child: GridView.builder(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10),
                          itemCount: imageFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (imageFiles.length != 0)
                                ? Image.file(
                                    imageFiles[index],
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  )
                                : Container();
                          }),
                    ),
                    AppTextFormFieldPost(
                        formName: "Название продукта",
                        controller: _controllerName,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Цена",
                        controller: _controllerPrice,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Цвет",
                        controller: _controllerColor,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Размеры",
                        controller: _controllerSizes,
                        minLin: 1,
                        maxLin: 10,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Описание",
                        controller: _controllerDescription,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Материал",
                        controller: _controllerMaterial,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Страна производитель",
                        controller: _controllerCountryProducer,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Фасон",
                        controller: _controllerStyle,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Характеристики модели",
                        controller: _controllerModelCharacteristics,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    AppTextFormFieldPost(
                        formName: "Категория",
                        controller: TextEditingController(),
                        minLin: 1,
                        maxLin: 2,
                        content: categoriesMap[widget.category.id].toString()),
                    AppTextFormFieldPost(
                        formName: "Количество",
                        controller: _controllerCountInStock,
                        minLin: 1,
                        maxLin: 6,
                        content: ""),
                    OutlinedButton(
                      child: Text('Добавить продукт',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(58, 67, 59, 1),
                              fontFamily: 'SolomonSans-SemiBold')),
                      onPressed: () {
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
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
                      ),
                    )
                  ],
                ),
              );
            })),
      );

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
                    fontSize: 16),
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
                          size: 24,
                          color: Color.fromRGBO(58, 67, 59, 1),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text("Изменить",
                            style: TextStyle(
                                color: Color.fromRGBO(58, 67, 59, 1),
                                fontFamily: 'Merriweather-Regular',
                                fontSize: 14))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                          size: 24,
                          color: Color.fromRGBO(58, 67, 59, 1),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text("Удалить",
                            style: TextStyle(
                                color: Color.fromRGBO(58, 67, 59, 1),
                                fontFamily: 'Merriweather-Regular',
                                fontSize: 14))
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
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.zero,
                      child: InkWell(
                        onTap: () {
                          chooseImageUpdate(ImageSource.gallery, productsCubit,
                              index, token, product, id);
                        },
                        child: (imageFile == null)
                            ? Center(
                                child:
                                    CachedNetworkImage(imageUrl: product.image))
                            : Image.file(imageFile!),
                      )),
                  AppTextFormFieldPost(
                      formName: "Название продукта",
                      controller: _controllerNameUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.name),
                  AppTextFormFieldPost(
                      formName: "Цена",
                      controller: _controllerPriceUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.price.toString()),
                  AppTextFormFieldPost(
                      formName: "Цвет",
                      controller: _controllerColorUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.color),
                  AppTextFormFieldPost(
                      formName: "Размеры",
                      controller: _controllerSizesUpdate,
                      minLin: 1,
                      maxLin: 10,
                      content: product.sizes),
                  AppTextFormFieldPost(
                      formName: "Описание",
                      controller: _controllerDescriptionUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.description),
                  AppTextFormFieldPost(
                      formName: "Материал",
                      controller: _controllerMaterialUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.material),
                  AppTextFormFieldPost(
                      formName: "Страна производитель",
                      controller: _controllerCountryProducerUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.countryProducer),
                  AppTextFormFieldPost(
                      formName: "Фасон",
                      controller: _controllerStyleUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.style),
                  AppTextFormFieldPost(
                      formName: "Характеристики модели",
                      controller: _controllerModelCharacteristicsUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content:
                          _convertJsonToString(product.modelCharacteristics)),
                  AppTextFormFieldPost(
                      formName: "Категория",
                      controller: TextEditingController(),
                      minLin: 1,
                      maxLin: 2,
                      content: categoriesMap[widget.category.id].toString()),
                  AppTextFormFieldPost(
                      formName: "Количество",
                      controller: _controllerCountInStockUpdate,
                      minLin: 1,
                      maxLin: 6,
                      content: product.countInStock.toString()),
                  OutlinedButton(
                    child: Text('Обновить продукт',
                        style: TextStyle(
                            fontSize: 16,
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
                        countryProducer: _controllerCountryProducerUpdate.text,
                        style: _controllerStyleUpdate.text,
                        modelCharacteristics: parseToModelCharObject(
                            _controllerModelCharacteristicsUpdate.text),
                        countInStock: _controllerCountInStockUpdate.text,
                        id: product.id,
                      )
                          .then((_) {
                        Navigator.of(context).pop();
                        _products[index].category = widget.category;
                        _products[index].name = _controllerNameUpdate.text;
                        if (imageFile != null) {
                          _products[index].image = imageFile!.path;
                          _products[index].id = '';
                        } else {
                          _products[index].id = 'image is not loaded';
                        }

                        _products[index].price =
                            int.parse(_controllerPriceUpdate.text);
                        _products[index].color = _controllerColorUpdate.text;
                        _products[index].sizes = _controllerSizesUpdate.text;
                        _products[index].description =
                            _controllerDescriptionUpdate.text;
                        _products[index].material =
                            _controllerMaterialUpdate.text;
                        _products[index].countryProducer =
                            _controllerCountryProducerUpdate.text;
                        _products[index].style = _controllerStyleUpdate.text;
                        _products[index].modelCharacteristics =
                            parseToModelCharObject(
                                _controllerModelCharacteristicsUpdate.text);
                        _products[index].countInStock =
                            int.parse(_controllerCountInStockUpdate.text);

                        _products[index].isFeatured = false;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Продукт обновлен'),
                          duration: const Duration(seconds: 2),
                        ));
                        setState(() {});
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          width: 1.0, color: Color.fromRGBO(58, 67, 59, 1)),
                    ),
                  )
                ],
              ),
            )),
      );

  Future chooseImageAdd(ImageSource source, ProductsCubit productsCubit,
      int index, bool singleFile) async {
    if (singleFile == true) {
      final pickedFile = await picker.pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          imageFile = File(pickedFile.path);
          Navigator.of(context).pop();
          displayDialogAdd(context, productsCubit, index);
        } else {
          print("No image is selected");
        }
      });
    } else {
      final pickedFile = await picker.pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          imageFiles.add(File(pickedFile.path));
          Navigator.of(context).pop();
          displayDialogAdd(context, productsCubit, index);
        } else {
          print("No image is selected");
        }
      });
    }
  }

  Future chooseImageUpdate(ImageSource source, ProductsCubit categoriesCubit,
      int index, String token, Product product, String id) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        Navigator.of(context).pop();
        displayDialogUpdate(
            context, id, index, token, product, categoriesCubit);
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
}

/*
_products.where((product) {
                if (true) {
                  print("RUN BOY RUN");
                }
                if (counter != colorsEndPoint.toInt()) {
                  print("PROBIV?1");
                  containsColor = product.color.contains(filteringOption);
                  if (containsColor) {
                    //realIndexFromSearch = indexCounter;
                    return containsColor;
                  } else {}
                  return false;
                } else if (counter > colorsEndPoint.toInt() &&
                    counter < materialEndPoint.toInt()) {
                  print("PROBIV?2");

                  containsMaterial = product.material.contains(filteringOption);
                  if (containsMaterial) {
                    //realIndexFromSearch = indexCounter;
                    return containsMaterial;
                  } else
                    return false;
                } else {
                  print("SDJSPJDASDASSDL");
                  return false;
                }
              });
              */
*/
