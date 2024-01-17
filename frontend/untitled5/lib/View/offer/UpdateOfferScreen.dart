import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Model/offer/Category.dart';
import '../../Model/offer/offer.dart';
import '../../Services/Offer/OfferService.dart';
import '../home/Home.dart';

class UpdateOfferScreen extends StatefulWidget {
  final Offer offer;

  UpdateOfferScreen({required this.offer});

  @override
  _UpdateOfferScreenState createState() => _UpdateOfferScreenState();
}

class _UpdateOfferScreenState extends State<UpdateOfferScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nomServiceController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

 List<File> listFile = [];
  Category? selectedCategory;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    nomServiceController.text = widget.offer.titre!;
    adresseController.text = widget.offer.adresse!;
    prixController.text = widget.offer.price!.toString();
    descriptionController.text = widget.offer.description!;
    selectedCategory = widget.offer.category?[0];
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
  Widget _buildImageList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: widget.offer.images!.length + listFile.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.offer.images!.length + listFile.length) {
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
        } else if (index < widget.offer.images!.length) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: MemoryImage(widget.offer.images![index].url!),
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
                      widget.offer.images!.removeAt(index);
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
                    image: FileImage(listFile[index - widget.offer.images!.length]),
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
                      listFile.removeAt(index - widget.offer.images!.length);
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
  void updateOfferAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      double? prixValue = double.tryParse(prixController.text);
      // Remove deleted images from the offer's images list
      List<File> remainingImages = [];
      for (File file in listFile) {
        if (!widget.offer.images!.any((image) => image.url == file.path)) {
          remainingImages.add(file);
        }
      }
      // Update the state with the modified values
      setState(() {
        widget.offer.titre = nomServiceController.text;
        widget.offer.adresse = adresseController.text;
        widget.offer.price = prixValue;
        widget.offer.description = descriptionController.text;
        widget.offer.category = [selectedCategory!];
      });
      // Wait for the updateOffer function to complete
      await updateOffer(widget.offer,listFile);





      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier le service',
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
                    // Add your validation logic here
                  },
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: adresseController,
                  labelText: 'Adresse',
                  validator: (value) {
                    // Add your validation logic here
                  },
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: prixController,
                  labelText: 'Prix',
                  maxLines: 1,
                  isNumeric: true,
                  validator: (value) {
                    // Add your validation logic here
                  },
                ),
                SizedBox(height: 16.0),
                _buildTextField(
                  controller: descriptionController,
                  labelText: 'Description du Service',
                  maxLines: 5,
                  maxLength: 500,
                  validator: (value) {
                    // Add your validation logic here
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
                  onPressed: updateOfferAndNavigate,
                  child: Text(
                    'Modifier le Service',
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
