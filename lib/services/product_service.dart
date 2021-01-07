
import 'package:SoftrigFlutter/config/config.dart';
import 'package:SoftrigFlutter/model/product_model.dart';
import 'package:SoftrigFlutter/model/token_model.dart';
import 'package:http/http.dart' show Client;


class ProductApiService {
  ServerUrls su = new ServerUrls();
  RealSecret rs = new RealSecret();
  Client client = Client();

  Future<List<Product>> getProducts(Token token) async {
    final response = await client.get(
      "${su.baseUrl}/api/biz/products",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.access}',
        'CompanyKey': '${rs.comId}'
      },
    );
    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createProduct(Token token, Product data) async {

    print(productToJson(data));
    final response = await client.post(
      "${su.baseUrl}/api/biz/products",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.access}',
        'CompanyKey': '${rs.comId}'
      },
      body: productToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProduct(Token token, Product data) async {
    final response = await client.put(
      "${su.baseUrl}/api/biz/products/${data.id}",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.access}',
        'CompanyKey': '${rs.comId}'
      },
      body: productToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(Token token, int id) async {
    final response = await client.delete(
      "${su.baseUrl}/api/biz/products/$id",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.access}',
        'CompanyKey': '${rs.comId}'
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
