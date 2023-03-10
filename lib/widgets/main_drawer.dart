import 'package:flutter/material.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/screens/filters_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 23,
            fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: TextButton(
              onLongPress: () {
                showLoveDialog(context, "Ich liebe dich ❤️",
                    "Bebi, du bist der wundervollste Mensch, den ich kenne.\nIch bin so froh, dich in meinem Leben zu haben\nIch liebe dich für immer❤️");
              },
              onPressed: () {},
              child: Text(
                'Essen macht glücklich!',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    color: Colors.green),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          buildListTile(
            'Alle Rezepte',
            Icons.restaurant_menu,
            () {
              Navigator.of(context).pushReplacementNamed("/all-meals");
            },
          ),
          buildListTile(
            'Neues Rezept',
            Icons.add,
            () {
              Navigator.of(context).pushReplacementNamed("/add-meal");
            },
          ),
          buildListTile(
            'Kategorien',
            Icons.restaurant,
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          buildListTile(
            'Online Rezept',
            Icons.import_export,
            () {
              Navigator.of(context).pushReplacementNamed('/online-meal');
            },
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
            ),
          ),
          buildListTile(
            'Importieren',
            Icons.upload,
            () {
              Navigator.of(context).pushReplacementNamed('/import-meals');
            },
          ),
          buildListTile(
            'Exportieren',
            Icons.save_alt_outlined,
            () {
              Navigator.of(context).pushReplacementNamed('/export-meals');
            },
          ),
          buildListTile(
            'Filter',
            Icons.settings,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(FiltersScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
