
import 'package:SoftrigFlutter/model/product_model.dart';
import 'package:SoftrigFlutter/model/token_model.dart';
import 'package:SoftrigFlutter/screens/login/login_form.dart';
import 'package:SoftrigFlutter/services/product_service.dart';
import 'package:flutter/material.dart';


final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormProductScreen extends StatefulWidget {
  final Product product;
  final Token token;

  FormProductScreen({this.product, this.token});

  @override
  _FormProductScreenState createState() => _FormProductScreenState();
}

class _FormProductScreenState extends State<FormProductScreen> {
  bool _isLoading = false;
  ProductApiService _apiService = ProductApiService();
  bool _isFieldNameValid;
  bool _isFieldDescriptionValid;
  bool _isFieldPriceIncValid;
  bool _isFieldPriceExValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerIncPrice = TextEditingController();
  TextEditingController _controllerExPrice = TextEditingController();

  @override
  void initState() {
    if (widget.product != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.product.name;
      _isFieldDescriptionValid = true;
      _controllerDescription.text = widget.product.description;
      _isFieldPriceIncValid = true;
      _controllerIncPrice.text = widget.product.priceIncVat.toString();
      _isFieldPriceExValid = true;
      _controllerExPrice.text = widget.product.priceExVat.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.product == null ? "Nytt produkt" : "Endre product",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldDescriptiotn(),
                _buildTextFieldPriceInc(),
                _buildTextFieldPriceEx(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.product == null
                          ? "Registrer".toUpperCase()
                          : "Oppdater".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          _isFieldDescriptionValid == null ||
                          _isFieldPriceIncValid == null ||
                          _isFieldPriceExValid == null ||
                          !_isFieldNameValid ||
                          !_isFieldDescriptionValid ||
                          !_isFieldPriceIncValid ||
                          !_isFieldPriceExValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Vennligst fyll ut alle felt"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      String description =
                          _controllerDescription.text.toString();
                      double priceInc =
                          double.parse(_controllerIncPrice.text.toString());
                      double priceEx =
                          double.parse(_controllerExPrice.text.toString());
                      Product product = Product(
                          name: name,
                          description: description,
                          priceIncVat: priceInc,
                          priceExVat: priceEx);
                      if (widget.product == null) {
                        _apiService
                            .createProduct(token, product)
                            .then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(
                                _scaffoldState.currentState.context, true);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Registrering feilet"),
                            ));
                          }
                        });
                      } else {
                        product.id = widget.product.id;
                        _apiService
                            .updateProduct(token, product)
                            .then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(
                                _scaffoldState.currentState.context, true);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Oppdatering feilet"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.blue[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Produkt",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Produkt navn kreves",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldDescriptiotn() {
    return TextField(
      controller: _controllerDescription,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Beskrivelse",
        errorText: _isFieldDescriptionValid == null || _isFieldDescriptionValid
            ? null
            : "Beskrivelse kreves",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldDescriptionValid) {
          setState(() => _isFieldDescriptionValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPriceInc() {
    return TextField(
      controller: _controllerIncPrice,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Pris inkl mvs",
        errorText: _isFieldPriceIncValid == null || _isFieldPriceIncValid
            ? null
            : "Pris er obligatorisk",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPriceIncValid) {
          setState(() => _isFieldPriceIncValid = isFieldValid);
        }
      },
    );
  }
  
  Widget _buildTextFieldPriceEx() {
    return TextField(
      controller: _controllerExPrice,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Pris uten mvs",
        errorText: _isFieldPriceExValid == null || _isFieldPriceExValid
            ? null
            : "Pris er obligatorisk",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPriceExValid) {
          setState(() => _isFieldPriceExValid = isFieldValid);
        }
      },
    );
  }
}
