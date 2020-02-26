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

const apiKey = 'F4ABBF37-E72E-44FD-9AB6-B8F48515C7DD';
const baseUrl = 'https://rest.coinapi.io/v1/exchangerate';

String getCoinDataUrl(String base, String quote) {
  String url =  '$baseUrl/$base/$quote?apikey=$apiKey';
  print(url);
  return url;
}

class CoinData {
  String base;
  String quote;
  double rate;

  CoinData(var response) {
    base = response['asset_id_base'];
    quote = response['asset_id_quote'];
    rate = response['rate'];
  }
}
