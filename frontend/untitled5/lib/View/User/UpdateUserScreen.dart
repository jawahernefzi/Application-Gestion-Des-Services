import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../Model/images.dart';
import '../../Model/offer/Category.dart';
import '../../Model/user.dart';
import '../../Services/user/UserService.dart';
import '../home/Home.dart';

class UpdateUserScreen extends StatefulWidget {
  final User user;
  UpdateUserScreen({required this.user});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController diplomaController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController adreeseDomicileController = TextEditingController();
  File profil = File("");
  List<Images>? listImages;
  Uint8List? profileImage;
  Category? selectedCategory;
  List<Category> categories = [];
  List<File> listFile = [];
  List<Images> list = [];

  @override
  void initState() {
    fetchCategories().then((result) {
      setState(() {
        categories = result;
      });
    }).catchError((error) {
      print('Error fetching categories: $error');
    });

    super.initState();
    listImages = widget.user.images;
    for (Images image in listImages!) {
      if (image.name!.startsWith("profile")) {
        profileImage = image.url;
      } else {
        list.add(image);
      }
    }

    firstNameController.text = widget.user.firstName ?? '';
    lastNameController.text = widget.user.lastName ?? '';
    addressController.text = widget.user.adresseTravail ?? '';
    diplomaController.text = widget.user.diplome ?? '';
    telephoneController.text = widget.user.tel?.toString() ?? '';
    print("categoryyy");
    print(categories.length);
    if(widget.user.category!.isNotEmpty)
      {
        selectedCategory = widget.user.category?[0];

      }
    else
      {
        selectedCategory=null;
      }

    adreeseDomicileController.text = widget.user.adresseDomicile ?? '';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Éditer mon profil',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo de profil
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.teal),

                      image:  DecorationImage(
                        image: profileImage != null
                            ? MemoryImage(profileImage ?? Uint8List(0))
                            : AssetImage('assets/inconnu.png') as ImageProvider, // Provide a placeholder image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                SizedBox(height: 16.0),
                // Détails de l'utilisateur
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le prénom est requis';
                    }
                    if (value.length > 10) {
                      return 'Le prénom ne peut pas dépasser 10 caractères';
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le nom est requis';
                    }
                    if (value.length > 10) {
                      return 'Le nom ne peut pas dépasser 10 caractères';
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Adresse de travail'),
                  validator: (value) {
                    if (value != null && value.length > 20) {
                      return 'L\'adresse ne peut pas dépasser 20 caractères';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: adreeseDomicileController,
                  decoration: InputDecoration(labelText: 'Adresse domicile'),
                ),
                TextFormField(
                  controller: diplomaController,
                  decoration: InputDecoration(labelText: 'Diplôme'),
                ),
                TextFormField(
                  controller: telephoneController,
                  decoration: InputDecoration(labelText: 'Téléphone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.length != 8) {
                      return 'Le numéro de téléphone doit contenir 8 chiffres';
                    }
                    return null;
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
                SizedBox(height: 16.0),
                // Catégorie
                _buildCategoryDropdown(),

                SizedBox(height: 16.0),
                // Photos de travail
                Text('Photos de travail:',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _buildWorkImage(),
                ),
                SizedBox(height: 16.0),
                // Bouton pour sauvegarder les modifications
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                        await updateUserAndNavigate();


                    }
                  },




                  child: Text(
                    'Modifier mon profil',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[400],
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkImage() {

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: list.length + listFile.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length + listFile.length) {
          return GestureDetector(
            onTap: () async {
              if (listFile.length < 4) {
                final pickedFiles = await ImagePicker().pickMultiImage(
                  imageQuality: 70,
                  maxWidth: 1440,
                );

                if (pickedFiles != null) {
                  setState(() {
                    listFile.addAll(
                      pickedFiles.map((pickedFile) => File(pickedFile.path)),
                    );
                  });
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.add, size: 50.0, color: Colors.grey),
            ),
          );
        } else if (index < list.length) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: MemoryImage(list[index].url!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    color: Colors.grey,
                    child: Icon(Icons.close, color: Colors.white, size: 20.0),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: FileImage(listFile[index - list.length]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      listFile.removeAt(index - list.length);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    color: Colors.grey,
                    child: Icon(Icons.close, color: Colors.white, size: 20.0),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButton<Category>(
      value: selectedCategory ?? categories[0],
      onChanged: (Category? value) {
        setState(() {
          selectedCategory = value;
        });
      },
      items: categories.map<DropdownMenuItem<Category>>((Category category) {
        return DropdownMenuItem<Category>(
          value: category,
          child: Text(category.name ?? ''),
        );
      }).toList(),
      hint: Text('Select Category'),
      isExpanded: true,
    );
  }

  Future<void> updateUserAndNavigate(
  ) async  {
    setState(() {
      widget.user.firstName = firstNameController.text;
      widget.user.lastName = lastNameController.text;
      widget.user.adresseDomicile = adreeseDomicileController.text;
      widget.user.adresseTravail = addressController.text;
      widget.user.category = [selectedCategory!];
      widget.user.diplome = diplomaController.text;
      widget.user.tel = telephoneController.text;
    });

    List<File> remainingImages = [];
    for (File file in listFile) {
      if (list.any((image) => image.url == file.path)) {
        remainingImages.add(file);
      }
    }

    await updateUser(widget.user, listFile, profil);



  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profil = File(pickedFile.path);
      final fileBytes = File(pickedFile.path).readAsBytesSync();
      setState(() {
        profileImage = Uint8List.fromList(fileBytes);
      });
    }
  }
}