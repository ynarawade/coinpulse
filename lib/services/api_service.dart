import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// CoinGecko API Service
///
/// Base URL : https://api.coingecko.com/api/v3
/// Rate limit: 30 requests / minute (free tier)
///
/// Usage:
///   final api = ApiService();
///   final coins = await api.getMarkets();
///   final detail = await api.getCoinDetail('bitcoin');
class ApiService {
  ApiService._(); // prevent instantiation

  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  /// Optional: paste your free Demo API key from coingecko.com
  /// Leave empty string if you don't have one yet.

  static final String _apiKey = dotenv.env['coingecko_api_key']!;

  // ─── Timeout ────────────────────────────────────────────────────────────
  static const Duration _timeout = Duration(seconds: 15);

  // ─── Shared Headers ──────────────────────────────────────────────────────
  static Map<String, String> get _headers => {
    'Accept': 'application/json',
    if (_apiKey.isNotEmpty) 'x-cg-demo-api-key': _apiKey,
  };

  // =========================================================================
  // CORE HTTP METHODS
  // =========================================================================

  /// Generic GET — returns decoded JSON (Map or List).
  /// [endpoint] should start with '/', e.g. '/coins/markets'
  /// [queryParams] are appended as ?key=value&...
  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection.');
    } on HttpException {
      throw ApiException('Network error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  /// Generic POST — sends [body] as JSON, returns decoded JSON.
  /// CoinGecko free API is read-only, but this is here for completeness
  /// (useful if you later add a Pro endpoint or your own backend).
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);

      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection.');
    } on HttpException {
      throw ApiException('Network error. Please try again.');
    } catch (e) {
      rethrow;
    }
  }

  // =========================================================================
  // COINGECKO ENDPOINTS
  // =========================================================================

  // ─── 1. Markets list ──────────────────────────────────────────────────────
  /// Returns top [perPage] coins with price, market cap, volume,
  /// 24h change, and sparkline data.
  ///
  /// Example response field: id, symbol, name, current_price,
  /// market_cap, total_volume, price_change_percentage_24h, sparkline_in_7d
  static Future<List<dynamic>> getMarkets({
    String currency = 'usd',
    String order = 'market_cap_desc',
    int perPage = 100,
    int page = 1,
    bool sparkline = true,
  }) async {
    final data = await get(
      '/coins/markets',
      queryParams: {
        'vs_currency': currency,
        'order': order,
        'per_page': perPage.toString(),
        'page': page.toString(),
        'sparkline': sparkline.toString(),
        'price_change_percentage': '24h',
      },
    );
    return data as List<dynamic>;
  }

  // ─── 2. Single coin detail ────────────────────────────────────────────────
  /// Returns full detail for a coin: description, links, market data,
  /// ATH, ATL, genesis date, etc.
  ///
  /// [coinId] is CoinGecko's ID, e.g. 'bitcoin', 'ethereum', 'solana'
  static Future<Map<String, dynamic>> getCoinDetail(String coinId) async {
    final data = await get(
      '/coins/$coinId',
      queryParams: {
        'localization': 'false',
        'tickers': 'false',
        'market_data': 'true',
        'community_data': 'false',
        'developer_data': 'false',
      },
    );
    return data as Map<String, dynamic>;
  }

  // ─── 3. Price chart ───────────────────────────────────────────────────────
  /// Returns list of [timestamp, price] pairs for a chart.
  ///
  /// [days] can be: 1 | 7 | 14 | 30 | 90 | 365 | 'max'
  static Future<Map<String, dynamic>> getCoinChart(
    String coinId, {
    String currency = 'usd',
    String days = '7',
  }) async {
    final data = await get(
      '/coins/$coinId/market_chart',
      queryParams: {'vs_currency': currency, 'days': days},
    );
    return data as Map<String, dynamic>;
  }

  // ─── 4. Search ────────────────────────────────────────────────────────────
  /// Search coins by name or symbol.
  /// Returns list of matching coins with id, name, symbol, thumb image.
  static Future<Map<String, dynamic>> search(String query) async {
    final data = await get('/search', queryParams: {'query': query});
    return data as Map<String, dynamic>;
  }

  // ─── 5. Global market stats ───────────────────────────────────────────────
  /// Returns total market cap, 24h volume, BTC & ETH dominance %,
  /// and active cryptocurrencies count.
  static Future<Map<String, dynamic>> getGlobalStats() async {
    final data = await get('/global');
    return data as Map<String, dynamic>;
  }

  // ─── 6. Trending coins ────────────────────────────────────────────────────
  /// Returns top 7 trending coins searched in the last 24 hours.
  static Future<Map<String, dynamic>> getTrending() async {
    final data = await get('/search/trending');
    return data as Map<String, dynamic>;
  }

  // ─── 7. Simple price ──────────────────────────────────────────────────────
  /// Lightweight price lookup for multiple coins at once.
  /// Great for a watchlist — much cheaper on rate limits than /markets.
  ///
  /// [coinIds] e.g. ['bitcoin', 'ethereum', 'solana']
  static Future<Map<String, dynamic>> getSimplePrices(
    List<String> coinIds, {
    String currency = 'usd',
    bool include24hChange = true,
  }) async {
    final data = await get(
      '/simple/price',
      queryParams: {
        'ids': coinIds.join(','),
        'vs_currencies': currency,
        'include_24hr_change': include24hChange.toString(),
      },
    );
    return data as Map<String, dynamic>;
  }

  // ───  OHLC chart ───────────────────────────────────────────────────────
  /// Returns list of [timestamp, open, high, low, close] arrays.
  ///
  /// [days]: 1 | 7 | 14 | 30 | 90 | 365 | 'max'
  /// Candle interval is auto-selected by CoinGecko based on days:
  ///   1-2 days → 30 min | 3-30 days → 4 hours | 31+ days → 4 days
  static Future<List<dynamic>> getCoinOhlc(
    String coinId, {
    String currency = 'usd',
    String days = '30',
  }) async {
    final data = await get(
      '/coins/$coinId/ohlc',
      queryParams: {'vs_currency': currency, 'days': days},
    );
    return data as List<dynamic>;
  }

  // =========================================================================
  // RESPONSE HANDLER
  // =========================================================================

  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw ApiException('Bad request. Check your parameters.');
      case 401:
        throw ApiException('Invalid API key.');
      case 404:
        throw ApiException('Coin not found.');
      case 429:
        throw ApiException('Rate limit exceeded. Please wait a moment.');
      case 500:
      case 502:
      case 503:
        throw ApiException('CoinGecko server error. Try again later.');
      default:
        throw ApiException('Unexpected error (${response.statusCode}).');
    }
  }
}

// =============================================================================
// CUSTOM EXCEPTION
// =============================================================================

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
