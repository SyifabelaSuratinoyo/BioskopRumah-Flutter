import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'movie_detail_screen.dart';
import 'movie_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      final data = await ApiService.getPopularMovies();
      setState(() {
        movies = data;
      });
    } catch (e) {
      // Menangani error jika terjadi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load movies: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Popular Movies',
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orange),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: movies.isEmpty
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      )
          : movies.isEmpty
          ? const Center(
        child: Text(
          'No movies found',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie: movie);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget MovieCard untuk menampilkan informasi singkat tentang sebuah film.
class MovieCard extends StatelessWidget {
  final Map movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: movie['poster_path'] != null
              ? Image.network(
            'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, color: Colors.grey);
            },
          )
              : const Icon(Icons.broken_image, color: Colors.grey),
        ),
        title: Text(
          movie['title'] ?? 'Unknown Title',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Rating: ${movie['vote_average'] ?? 'N/A'}',
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movieId: movie['id']),
            ),
          );
        },
      ),
    );
  }
}
