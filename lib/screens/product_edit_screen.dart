import 'package:flutter/material.dart';
import 'package:online_shop/providers/product.dart';
import 'package:online_shop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductEditScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _priceFocusNode = FocusNode();

  final _descriptionFocusNode = FocusNode();

  final _imageFocusNode = FocusNode();

  final _imageController = TextEditingController();

  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  Product _newProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );

  bool isInit = true;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id == null) {
        return;
      }

      print('id $id');
      final product =
          Provider.of<Products>(context, listen: false).findById(id);
      print('find id ${product.id}');
      _newProduct = Product(
        id: product.id,
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        isFavorite: product.isFavorite,
      );
      _imageController.text = product.imageUrl;
    }
    isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_newProduct.id != null) {
        try {
          await Provider.of<Products>(context, listen: false)
              .editProduct(_newProduct.id, _newProduct);
          Navigator.of(context).pop();
        } catch (error) {
          showDialog(
            context: context,
            builder: (bctx) => AlertDialog(
              title: Text("An error occured."),
              content: Text("SOmething bad happens"),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ),
          );
        } finally {
          this.setState(() {
            _isLoading = false;
          });
        }
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_newProduct);
          Navigator.of(context).pop();
        } catch (error) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("An error occured."),
              content: Text("SOmething bad happens"),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _newProduct.title,
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: value,
                          description: _newProduct.description,
                          imageUrl: _newProduct.imageUrl,
                          price: _newProduct.price,
                          isFavorite: _newProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _newProduct.price.toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        print('price $value');
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: _newProduct.description,
                          imageUrl: _newProduct.imageUrl,
                          price: double.parse(value),
                          isFavorite: _newProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "This field is required";
                        }

                        if (double.tryParse(value) == null) {
                          return "Please enter the number";
                        }

                        if (double.parse(value) <= 0) {
                          return "Value must be greater than 0";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _newProduct.description,
                      decoration: InputDecoration(labelText: "Description"),
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageFocusNode);
                      },
                      onSaved: (value) {
                        _newProduct = Product(
                          id: _newProduct.id,
                          title: _newProduct.title,
                          description: value,
                          imageUrl: _newProduct.imageUrl,
                          price: _newProduct.price,
                          isFavorite: _newProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          child: _imageController.text.isNotEmpty
                              ? Container(
                                  child: Image.network(
                                  _imageController.text,
                                  fit: BoxFit.cover,
                                ))
                              : Text("No image"),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageController,
                            decoration: InputDecoration(labelText: "Image"),
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _newProduct = Product(
                                id: _newProduct.id,
                                title: _newProduct.title,
                                description: _newProduct.description,
                                imageUrl: value,
                                price: _newProduct.price,
                                isFavorite: _newProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
