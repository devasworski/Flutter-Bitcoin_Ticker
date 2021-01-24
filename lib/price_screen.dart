import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "AUD";
  CoinData coinData = CoinData();
  bool isLoading = true;
  double BTC = 0;
  double ETH = 0;
  double LTC = 0;

  getData() async {
    isLoading = true;
    try {
      double BTCv = await coinData.getCurrencyData(
          fromCurrency: "BTC", toCurrency: selectedCurrency);
      double ETHv = await coinData.getCurrencyData(
          fromCurrency: "ETH", toCurrency: selectedCurrency);
      double LTCv = await coinData.getCurrencyData(
          fromCurrency: "LTC", toCurrency: selectedCurrency);
      isLoading = false;
      setState(() {
        BTC = BTCv;
        ETH = ETHv;
        LTC = LTCv;
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> getDropDownButton(List<String> stringList) {
    List<DropdownMenuItem<String>> dropDownMenuItemList = [];
    for (String s in stringList) {
      dropDownMenuItemList.add(DropdownMenuItem(
        child: Text(s),
        value: s,
      ));
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownMenuItemList,
      onChanged: (selcetion) {
        setState(() {
          selectedCurrency = selcetion;
          getData();
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker(List<String> stringList) {
    List<Text> pickerItemList = [];
    for (String s in stringList) {
      pickerItemList.add(Text(s));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 35,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = stringList[index];
          getData();
        });
      },
      children: pickerItemList,
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCardWidget(
                currency: "BTC",
                currencyConvert: BTC,
                toCurrency: selectedCurrency,
                isLoading: isLoading,
              ),
              CryptoCardWidget(
                currency: "ETH",
                currencyConvert: ETH,
                toCurrency: selectedCurrency,
                isLoading: isLoading,
              ),
              CryptoCardWidget(
                currency: "LTC",
                currencyConvert: LTC,
                toCurrency: selectedCurrency,
                isLoading: isLoading,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: NotificationListener(
              child: Platform.isIOS
                  ? getCupertinoPicker(currenciesList)
                  : getDropDownButton(currenciesList),
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoCardWidget extends StatelessWidget {
  CryptoCardWidget(
      {@required this.currencyConvert,
      @required this.currency,
      @required this.toCurrency,
      @required this.isLoading});
  final double currencyConvert;
  final String currency;
  final String toCurrency;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            isLoading
                ? '1 $currency = ? $toCurrency'
                : '1 $currency = ${currencyConvert.toStringAsFixed(2)} $toCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
