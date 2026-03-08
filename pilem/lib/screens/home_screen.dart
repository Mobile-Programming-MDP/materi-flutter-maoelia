import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:pilem/services/api_service.dart';
import 'package:pilem/screens/favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  // List untuk menyimpan data movies yang diambil dari API (method)
  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> allMoviesData = await _apiService
        .getAllMovies();
    final List<Map<String, dynamic>> trendingMoviesData = await _apiService
        .getTrendingMovies();
    final List<Map<String, dynamic>> popularMoviesData = await _apiService
        .getPopularMovies();

    setState(() {
      //map() mengubah setiap item JSON menjadi objek Movie menggunakan fromJson, lalu toList() mengubah hasilnya menjadi List<Movie>
      _allMovies = allMoviesData.map((json) => Movie.fromJson(json)).toList();
      _trendingMovies = trendingMoviesData
          .map((json) => Movie.fromJson(json))
          .toList();
      _popularMovies = popularMoviesData
          .map((json) => Movie.fromJson(json))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  // Widget untuk menampilkan UI HomeScreen
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilem")),
      // digunakan agar halaman bisa scroll ke bawah
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment.start untuk menyusun widget secara vertikal dari kiri ke kanan
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviesList("All Movies", _allMovies),
            _buildMoviesList("Trending Movies", _trendingMovies),
            _buildMoviesList("Popular Movies", _popularMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Menampilkan Title Kategori Movies
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title, //judul kategori
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        //Menapilkan thumnail dan judul movies
        SizedBox(
          height: 200,
          // bisa digeser ke samping
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext build, int index) {
              final Movie movie = movies[index];
              // agar film bisa di klik dan masuk ke detail screen
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(movie: movie),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.network(
                        "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        movie.title.length > 14
                            ? '${movie.title.substring(0, 10)}...'
                            : movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
