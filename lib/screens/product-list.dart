import 'dart:async';

import 'package:warehouse_mobile/data/db_client.dart';
import 'package:warehouse_mobile/data/rest_ds.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_mobile/screens/product-details.dart';
import 'package:warehouse_mobile/screens/product-new.dart';
import 'package:warehouse_mobile/services/navigation_service.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class ProductListState extends State<ProductList> {
  List<Product> _products = <Product>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  RestDatasource api = new RestDatasource();
	DatabaseClient dbClient = new DatabaseClient();

  BuildContext _ctx;

  Future<List<Product>> _getProducts() async {
    return SharedPreferencesUtil.getInitFlag().then((bool initialized) async{
      if (initialized) {
        // App initialized previously, get data from DB
        print('app initialized previously');
        this._products = await dbClient.getProducts();
        print('products downloaded from mobile db');
      } else {
        // First app init, get data from backend and store in db
        print('first app init');
				this._products = await api.getProducts();
				print('products downloaded from backend');
				await dbClient.insertProducts(this._products);
				print('products inserted into mobile db');

				await SharedPreferencesUtil.setInitFlag();
      }

			return this._products;
    });
  }

  Future<void> _synchronize() async {
    //TODO: synchronization using own subtotal of products
  }

  void _productDetails(Product product) {
    new NavigationService().materialNavigateTo(
        new MaterialPageRoute(
            builder: (context) => ProductDetails(product: product)),
        context);
  }

  @override
  Widget build(BuildContext context) {
    this._ctx = context;

    var futureBuilder = new FutureBuilder(
      future: _getProducts(),
      initialData: "Loading data...",
      builder: (BuildContext context, AsyncSnapshot<dynamic> products) {
        if (products.hasData) {
          return _buildProducts();
        } else {
          return new CircularProgressIndicator();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
          title: Text('Tracked products'),
          leading: IconButton(
              icon: const Icon(Icons.refresh), onPressed: _synchronize),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.power_settings_new), onPressed: _logout)
        ],
          ),
      body: futureBuilder,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildProducts() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2; // i by 2 with int result

          if (index >= _products.length) {
            return null;
          }

          return _buildRow(_products[index]);
        });
  }

  Widget _buildRow(Product product) {
    return ListTile(
        title: Text(
          product.modelName,
          style: _biggerFont,
        ),
        subtitle: Text(product.manufacturerName),
        trailing: new Icon(Icons.arrow_forward),
        onTap: () {
          _productDetails(product);
        });
  }

  Widget _buildFAB() {
    return new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.add),
        backgroundColor: new Color(0xFF4CAF50),
        onPressed: _newProduct);
  }

  void _newProduct() {
    new NavigationService().materialNavigateTo(
        new MaterialPageRoute(builder: (context) => NewProduct()), context);
  }

  void _logout() {
    var dbClient = new DatabaseClient();
		dbClient.deleteUsers();

    new NavigationService().popToLogin(this._ctx);
  }
}

class ProductList extends StatefulWidget {
  @override
  ProductListState createState() => new ProductListState();
}
