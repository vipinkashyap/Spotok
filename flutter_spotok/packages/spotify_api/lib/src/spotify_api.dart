import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:spotify_api/src/models/featured_playlists.dart';

class SpotifyApi {
  static final Uri _authUri = Uri.https('accounts.spotify.com', '/api/token', {
    'grant_type': 'client_credentials',
    'country': _defaultCountry,
    'limit': _defaultLimit,
  });
  static final Uri _featuredPlaylistsUri =
      Uri.parse('https://api.spotify.com/v1/browse/featured-playlists');
  static const String _defaultCountry = 'US';
  static const String _defaultLimit = '50';
  final http.Client _client;

  SpotifyApi({http.Client? client}) : _client = client ?? http.Client();

  Future<String> getAccessToken() async {
    var request = await http.post(_authUri, headers: {
      'Authorization': 'Basic ${base64Encode(
        utf8.encode(
            'd4683e5a7df74ffeb6faf7603a622b74:3357b807ab524527a37821d5f56fc170'),
      )}',
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    if (request.statusCode == 200) {
      var body = jsonDecode(request.body);
      return body['access_token'];
    }
    throw Exception();
  }

  Future<FeaturedPlaylists> getFeaturedPlaylists() async {
    var accessToken = await getAccessToken();
    var response = await http.get(_featuredPlaylistsUri, headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as Map<String, dynamic>;

      var featuredPlaylists = FeaturedPlaylists.fromJson(body);
      log('Body : ${featuredPlaylists.toString()}');
      return featuredPlaylists;
    } else {
      throw Exception();
    }
  }
}
