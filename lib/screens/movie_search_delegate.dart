import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'movie_detail_screen.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: ApiService.searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        } else {
          final movies = snapshot.data as List;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: movie['poster_path'] != null
                    ? Image.network(
                  'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                  fit: BoxFit.cover,
                )
                    : null,
                title: Text(movie['title']),
                subtitle: Text('Rating: ${movie['vote_average']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie['id']),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Saran pencarian
    return Center(
      child: Text('Search for movies...'),
    );
  }
}
