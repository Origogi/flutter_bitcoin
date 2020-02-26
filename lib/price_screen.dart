import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform; //at the top

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  List<String> rateList = ['?', '?', '?'];

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      items: dropdownItems,
      value: selectedCurrency,
      onChanged: (value) async {
        setState(() {
          selectedCurrency = value;

          for (int i = 0; i < 3; i++) {
            rateList[i] = '?';
          }
        });

        for (int i = 0; i < 3; i++) {
          NetworkHelper networkHelper =
              NetworkHelper(getCoinDataUrl(cryptoList[i], selectedCurrency));
          var responseData = await networkHelper.getData();
          print(responseData);

          if (responseData != null) {
            CoinData coinData = CoinData(responseData);
            rateList[i] = coinData.rate.toInt().toString();
          } else {
            rateList[i] = '?';
          }
        }

        setState(() {
        });
      },

      
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: pickerItems);
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 3; i++) {
      getCoinData(cryptoList[i], selectedCurrency).then((result) {
        print("result: $result");
        updateUI(i, result);
      });
    }
  }

  Future<CoinData> getCoinData(String base, String quote) async {
    NetworkHelper networkHelper = NetworkHelper(getCoinDataUrl(base, quote));
    var responseData = await networkHelper.getData();
    CoinData coinData = CoinData(responseData);
    return coinData;
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
            children: getCryptoCurrenciesWidget(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          )
        ],
      ),
    );
  }

  void updateUI(int index, CoinData coinData) {
    setState(() {
      selectedCurrency = coinData.quote;
      rateList[index] = coinData.rate.round().toString();
    });
  }

  List<Widget> getCryptoCurrenciesWidget() {
    List<Widget> wigets = [];

    for (int i = 0; i < 3; i++) {
      wigets.add(Padding(
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
              '1 ${cryptoList[i]} = ${rateList[i]} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    return wigets;
  }
}
