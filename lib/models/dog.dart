class Dog {
  final String breed;
  final List<String> subBreeds;
  final String imageUrl;

  Dog({
    required this.breed,
    required this.subBreeds,
    required this.imageUrl,
  });

  factory Dog.fromJson(String breed, List<dynamic> subBreeds, String imageUrl) {
    return Dog(
      breed: breed,
      subBreeds: List<String>.from(subBreeds),
      imageUrl: imageUrl,
    );
  }
}