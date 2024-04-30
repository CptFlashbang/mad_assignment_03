class Pet {
  Pet(
    {
      required this.animalName,
      required this.animalPic,
      required this.animalAge,
      required this.animalType,
      required this.animalBreed
    }
  );

  final String animalName;
  final String animalPic;
  final String animalAge;
  final String animalType;
  final String animalBreed;
}

final List<Pet> pets = <Pet>[
    Pet(
    animalName: "Falcor",
    animalPic: "images/falcor.jpg",
    animalAge: "8",
    animalType: "dog",
    animalBreed: "Cross Breed Collie"
  ),
  Pet(
    animalName: "Jemima",
    animalPic: "images/jemima.jpg",
    animalAge: "6",
    animalType: "dog",
    animalBreed: "Cross Breed Sproodle"
  ),
  Pet(
    animalName: "Garnet",
    animalPic: "images/garnet.jpg",
    animalAge: "15",
    animalType: "cat",
    animalBreed: "tabby moggy"
  ),
  Pet(
    animalName: "Tabby",
    animalPic: "images/tabby.jpg",
    animalAge: "11",
    animalType: "cat",
    animalBreed: "tabby moggy"
  ),
  Pet(
    animalName: "Moonlight",
    animalPic: "images/moonlight.jpg",
    animalAge: "11",
    animalType: "cat",
    animalBreed: "Black and white moggy"
  ),
];
