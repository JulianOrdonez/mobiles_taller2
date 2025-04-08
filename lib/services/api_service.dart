import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog.dart';

class ApiService {
  static const String baseUrl = 'https://dog.ceo/api';

  Future<List<Dog>> getAllBreeds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/breeds/list/all'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> breeds = data['message'];
        List<Dog> dogs = [];
        
        for (var entry in breeds.entries) {
          final imageResponse = await http.get(Uri.parse('$baseUrl/breed/${entry.key}/images/random'));
          if (imageResponse.statusCode == 200) {
            final imageData = json.decode(imageResponse.body);
            dogs.add(Dog.fromJson(
              entry.key, 
              entry.value, 
              imageData['message']
            ));
          }
        }
        
        return dogs;
      } else {
        throw Exception('Failed to load breeds');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<List<String>> getBreedImages(String breed) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/breed/$breed/images'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['message']);
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}