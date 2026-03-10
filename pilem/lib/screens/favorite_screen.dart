import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilem/screens/detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _Favoritescreenstate;
}

  class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Movie> _favoriteMovies = [];

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();
    List<Movie> favorites = [];
    for (String key in keys) {
      if (key.startsWith('movie_')) {
        final String? movieJson = prefs.getString(key);
        if (movieJson != null) {
          Movie movie = Movie.fromJson(json.decode(movieJson));
          favorites.add(movie);
        }
      }
    }
    setState(() {
      _favoriteMovies = favorites;
    });
  }

    final movies = <Movie>[];
    for (final id in ids) {
      final m = _movieById[id];
      if (m != null) movies.add(m);
    }
    return movies;
  }

  Future<void> _removeFavorite(String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList('favorite_movie_ids') ?? []).toList();

    ids.remove(movieId);
    await prefs.setStringList('favorite_movie_ids', ids);

    favoriteChanged.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: ValueListenableBuilder<int>(
        valueListenable: favoriteChanged,
        builder: (context, _, __) {
          return FutureBuilder<List<Hotel>>(
            future: _loadFavorites(),
            builder: (context, snap) {
              final loading = snap.connectionState == ConnectionState.waiting;
              final hotels = snap.data ?? const <Hotel>[];
              final count = hotels.length;

              final subtitle = loading ? "Loading..." : "$count results";

              return Column(
                children: [
                  GreenTopHeader(
                    title: "Favorite",
                    subtitle: subtitle,
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : (count == 0)
                            ? FavoriteEmptyCard(
                                onExplore: () => mainTabIndex.value = 0,
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                itemCount: hotels.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 16),
                                itemBuilder: (_, i) {
                                  final h = hotels[i];
                                  final extra = HotelDetailExtra.byId(h.id);

                                  return FavoriteHotelCard(
                                    image: h.image,
                                    name: h.name,
                                    address: extra.address,
                                    rating: h.rating,
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DetailScreen(hotel: h),
                                        ),
                                      );
                                      // setelah balik dari detail, refresh juga
                                      favoriteChanged.value++;
                                    },
                                    onToggleFavorite: () => _removeFavorite(h.id),
                                  );
                                },
                              ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
