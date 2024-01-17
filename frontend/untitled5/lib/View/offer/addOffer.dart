import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Model/offer/Category.dart';
import '../../Model/user.dart';
import '../../Services/Offer/OfferService.dart';
import '../../Services/user/UserService.dart';
import '../home/Home.dart';

class AddOfferScreen extends StatefulWidget {
  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nomServiceController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> listimage = [];
  Category? selectedCategory;

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories().then((result) {
      setState(() {
        categories = result;
      });
    }).catchError((error) {
      print('Error fetching categories: $error');
    });


  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int? maxLength,
    int? maxLines,
    bool isNumeric = false,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : null,
      inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      validator: validator,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<Category>(
      value: selectedCategory,
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
      decoration: InputDecoration(
        labelText: 'Categorie',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }

  Widget _buildImageList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: listimage.length + 1,
      itemBuilder: (context, index) {
        if (index == listimage.length) {
          return GestureDetector(
            onTap: () async {
              if (listimage.length < 4) {
                final pickedFiles = await ImagePicker().pickMultiImage(
                  imageQuality: 70,
                  maxWidth: 1440,
                );

                if (pickedFiles != null) {
                  setState(() {
                    listimage.addAll(
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
        } else {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: FileImage(listimage[index]),
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
                      listimage.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ajouter un service',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          backgroundColor: Colors.white60,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: nomServiceController,
                    labelText: 'Nom Service',
                    maxLength: 25,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom du service est requis';
                      } else if (value.length > 25) {
                        return 'Le nom ne doit pas dépasser 25 caractères';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: adresseController,
                    labelText: 'Adresse',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'adresse est requise';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: prixController,
                    labelText: 'Prix',
                    maxLines: 1,
                    isNumeric: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le prix est requis';
                      } else if (double.tryParse(value) == null) {
                        return 'Veuillez entrer un nombre valide pour le prix';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: descriptionController,
                    labelText: 'Description du Service',
                    maxLines: 5,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La description du service est requise';
                      } else if (value.length > 500) {
                        return 'La description ne doit pas dépasser 500 caractères';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildCategoryDropdown(),
                  SizedBox(height: 16.0),
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _buildImageList(),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        double? prixValue = double.tryParse(
                            prixController.text);
                        List<Category>? c = [];
                        c.add(selectedCategory!);
                        await addOffre(
                          nomServiceController.text,
                          adresseController.text,
                          prixValue!,
                          descriptionController.text,
                          listimage,
                          c,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    },
                    child: Text(
                      'Ajouter le Service',
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
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      );
    }

  }

