import 'package:SoftrigFlutter/model/product_model.dart';
import 'package:SoftrigFlutter/model/token_model.dart' as sr;
import 'package:SoftrigFlutter/screens/product/product_form.dart';
import 'package:SoftrigFlutter/services/product_service.dart';
import 'package:flutter/material.dart';



class ProductsPage extends StatefulWidget {
  ProductsPage({Key key, this.title, this.softrigToken}) : super(key: key);

  final String title;
  final sr.Token softrigToken;

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  BuildContext context;
  ProductApiService apiService;
  sr.Token token;

  List<Product> produkt;
  @override
  void initState() {
    super.initState();
    apiService = ProductApiService();
    token = widget.softrigToken;
  }


  @override
  Widget build(BuildContext context) {
    
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Produkter",
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new FormProductScreen(
                                product: null,
                                token: token,
                              )));
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: apiService.getProducts(token),
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Feilmelding: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Product> products = snapshot.data;
              return _buildListView(products);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Product product = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(product.description),
                    Text(product.priceIncVat.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Warning"),
                                    content: Text(
                                        "Er du sikker du vil slette dette produktet ${product.name}?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Ja"),
                                        onPressed: () {
                                          setState((){

                                          });
                                          Navigator.pop(context);
                                          apiService
                                              .deleteProduct(token, product.id)
                                              .then((isSuccess) {
                                            if (isSuccess) {
                                              setState(() {});
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Produktet er slettet")));
                                            } else {
                                              Scaffold.of(this.context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Sletting feilet")));
                                            }
                                          });
                                          
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Nei"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Slette",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            var result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return FormProductScreen(
                                  product: product, token: token);
                            }));
                            if (result != null) {
                              setState(() {});
                            }
                          },
                          child: Text(
                            "Endre",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: products.length,
      ),
    );
  }
}
