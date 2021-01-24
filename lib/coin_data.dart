import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final String apiBaseUrl =
      "https://apiv2.bitcoinaverage.com/indices/global/ticker/";

  Future<double> getCurrencyData(
      {@required String fromCurrency, @required String toCurrency}) async {
    try {
      http.Response response =
          await http.get("$apiBaseUrl$fromCurrency$toCurrency");
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['last'];
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }
}
