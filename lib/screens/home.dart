import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'jokes.dart';
import 'random_joke.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService().getJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat_on),
            onPressed: () async {
              final randomJoke = await ApiService().getRandomJoke();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RandomJokeScreen(joke: randomJoke)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final types = snapshot.data!;
            return GridView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 100),
                    child: ListTile(
                      leading: const Icon(Icons.tag),
                      title: Text(
                        types[index],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  JokesScreen(type: types[index])),
                        );
                      },
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            );
          }
        },
      ),
    );
  }
}
