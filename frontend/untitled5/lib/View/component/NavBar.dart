import 'package:flutter/material.dart';
import '../../Model/user.dart';
import '../../Services/user/UserService.dart';
import '../User/Login.dart';
import '../User/UpdateUserScreen.dart';
import '../offer/OfferListWidget.dart';
import '../offer/addOffer.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}
class _NavBarState extends State<NavBar> {
  bool isPrestataire=false;

  Future<void> _onItemTapped(int index, BuildContext context) async {
    User currentUser= await getUserByEmail();

    isPrestataire = currentUser.role?.roleName == 'prestataire';
    print("navbar");
    print(currentUser.role?.roleName);
    try {

       if (index == 1) {
        // Show the navigation menu for "Profil" options
        showNavigationMenu(context);
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error, e.g., show a toast or navigate to an error page.
    }
  }



  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),

      ],
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.teal,
      onTap: (index) => _onItemTapped(index, context),
    );
  }

  void showNavigationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person,color:Colors.teal),
              title: Text('Éditer mon profil'),

              onTap: () async {
                User user = await getUserByEmail();
print(user.diplome);
                Navigator.pop(context); // Close the menu

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserScreen(user:user),
                  ),
                );
              },
            ),

            if (isPrestataire)
              ListTile(
                leading: Icon(Icons.list,color:Colors.teal),
                title: Text('Mes services'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OfferListWidget(),
                    ),
                  );
                },
              ),

            ListTile(
              leading: Icon(Icons.add,color:Colors.teal),
              title: Text('Ajouter un service'),
              onTap: () async {
                // Assuming this code is inside an async function (e.g., initState or a onPressed callback)


                 if(isPrestataire)
                   {
                Navigator.pop(context); // Close the menu
                // Navigate to Ajouter Offre page

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOfferScreen(),
                  ),
                );
                }else {
                   showDialog(
                     context: context,
                     builder: (BuildContext context) {
                       return AlertDialog(
                         title: Text(
                           'Devenir Prestataire',
                           style: TextStyle(
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                             color: Colors.teal,
                           ),
                           textAlign: TextAlign.center,

                         ),
                         content: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Text(
                               'Pour profiter pleinement de nos services,  vous devez  compléter votre profil.',
                               style: TextStyle(
                                 fontSize: 16.0,
                               ),
                               textAlign: TextAlign.center,
                             ),
                             SizedBox(height: 16.0),
                             ElevatedButton(
                               onPressed: () async {
                                 User user = await getUserByEmail();
                                 print(user.email);
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => UpdateUserScreen(user: user)),
                                 );
                               },
                               child: Text(
                                 'allez  sur mon  profil',
                                 style: TextStyle(fontSize: 16.0,color:Colors.white ),
                               ),
                               style: ElevatedButton.styleFrom(
                                 primary: Colors.teal, // Button color
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(8.0),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       );
                     },
                   );
                 }

              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,color:Colors.teal),
              title: Text('déconnexion'),
              onTap: () {

                Navigator.pop(context); // Close the menu
                logout();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),


          ],
        );
      },
    );
  }
}
