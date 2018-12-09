class Product {
  String id;
  String manufacturerName;
  String modelName;
  num price;
  String currency;
  int quantity;

  static const String ID_KEY = '_id';
  static const String MANUFACTURER_NAME_KEY = 'manufacturerName';
  static const String MODEL_NAME_KEY = 'productModelName';
  static const String PRICE_KEY = 'price';
  static const String CURRENCY_KEY = 'currency';
  static const String QUANTITY_KEY = 'quantity';

  Product(
      {this.id,
      this.manufacturerName,
      this.modelName,
      this.price,
      this.currency,
      this.quantity});

  static List<String> getParamKeys() {
    return [
      ID_KEY,
      MANUFACTURER_NAME_KEY,
      MODEL_NAME_KEY,
      PRICE_KEY,
      CURRENCY_KEY,
      QUANTITY_KEY
    ];
  }

  static String getTableCreateQuery() {
    return 'CREATE TABLE Product ($ID_KEY TEXT PRIMARY KEY,'
      ' $MANUFACTURER_NAME_KEY TEXT,'
      ' $MODEL_NAME_KEY TEXT,'
      ' $PRICE_KEY REAL,'
      ' $CURRENCY_KEY TEXT,'
      ' $QUANTITY_KEY INTEGER)';
  }

  Map<String, dynamic> toMap() {
    Map map = {
      ID_KEY: id,
      MANUFACTURER_NAME_KEY: manufacturerName,
      MODEL_NAME_KEY: modelName,
      PRICE_KEY: price,
      CURRENCY_KEY: currency,
      QUANTITY_KEY: quantity
    };

    return map.cast<String, dynamic>();
  }

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson.containsKey(ID_KEY) &&
        parsedJson.containsKey(MANUFACTURER_NAME_KEY) &&
        parsedJson.containsKey(MODEL_NAME_KEY) &&
        parsedJson.containsKey(PRICE_KEY) &&
        parsedJson.containsKey(CURRENCY_KEY) &&
        parsedJson.containsKey(QUANTITY_KEY)) {
      return Product(
          id: parsedJson[ID_KEY],
          manufacturerName: parsedJson[MANUFACTURER_NAME_KEY],
          modelName: parsedJson[MODEL_NAME_KEY],
          price: parsedJson[PRICE_KEY],
          currency: parsedJson[CURRENCY_KEY],
          quantity: parsedJson[QUANTITY_KEY]);
    } else {
      throw new Exception('Malformed product json');
    }
  }
}
