import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../services/api_service.dart';
import 'package:go_router/go_router.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Dog>> _dogsFuture;

  @override
  void initState() {
    super.initState();
    _dogsFuture = _apiService.getAllBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Breeds')),
      body: FutureBuilder<List<Dog>>(
        future: _dogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dogsFuture = _apiService.getAllBreeds();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final dog = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        dog.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 60,
                            height: 60,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 60,
                            height: 60,
                            child: Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      dog.breed.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      dog.subBreeds.isEmpty
                          ? 'No sub-breeds'
                          : '${dog.subBreeds.length} sub-breeds',
                    ),
                    onTap: () {
                      // Navegación a la pantalla de detalle
                      context.go('/detail/${dog.breed}');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
