class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  bool isFavorite; // properti untuk menyimpan status favorit

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    this.isFavorite = false, // nilai default false untuk isFavorite
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      isFavorite: false, // default false saat membuat objek dari JSON
    );
  }

  Map<String, dynamic> toJson() {
    // Metode baru untuk mengonversi/menyimpan objek ke sharedpreferences sebagai JSON
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'isFavorite': isFavorite,
    };
  }
}
