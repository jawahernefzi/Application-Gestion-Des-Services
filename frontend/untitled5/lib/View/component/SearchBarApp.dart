import 'package:flutter/material.dart';
import '../../Model/offer/Category.dart';
import '../home/Home.dart';

class SearchBarApp extends StatefulWidget {
  void Function(String) setCategoryCallBack;
  VoidCallback clearSearchCallBack;

  SearchBarApp({required this.setCategoryCallBack, required this.clearSearchCallBack});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  bool _isLoading = true;
  List<Category> categories = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchCategories().then((List<Category> result) {
      setState(() {
        categories = result;
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() => _isLoading = false);
    });
  }

  void clearSearch() {
    setState(() {
      selectedCategory = '';
    });
    widget.clearSearchCallBack();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
      backgroundColor: Colors.white, // Set the background color of the entire page

      body: Container(

          padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),

      ),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Rechercher...',
              hintStyle: TextStyle(color: Colors.black),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: clearSearch,
              ),
            ),
            onTap: () {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
          List<Widget> suggestionList = [];
          for (int i = 1; i < categories.length; i++) {
            Category item = categories[i];
            IconData iconData;
            switch (item.name) {
              case 'ménage':
                iconData = Icons.home;
                break;
              case 'Plomberie':
                iconData = Icons.build;
                break;
              case 'Jardinage':
                iconData = Icons.eco;
                break;
              case 'électricité':
                iconData = Icons.flash_on;
                break;
              default:
                iconData = Icons.category;
            }

            suggestionList.add(
              Container(
                child: ListTile(
                  leading: Icon(iconData, color: Colors.teal), // Set the icon color to gray
                  title: Text(
                    item.name!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedCategory = item.name!;
                      controller.closeView(item.name!);
                      widget.setCategoryCallBack(item.name!);
                    });
                  },
                ),
              ),
            );
          }
          return suggestionList;
        },

      ),
    ),
    );
  }
}
