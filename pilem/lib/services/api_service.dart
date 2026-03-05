import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  //ganti dg api key masing masing
  static const String apiKey = '';
  // 1.mengambil list movie populer saat ini
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // 2.mengambil list movie yang sedang trending minggu ini
  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/trending?api_key=$apiKey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // 3.mengambil list movie populer movie
  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  // 4.mengambil list movie melalui pencarian
  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
    );
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}
