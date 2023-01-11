import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_app_flutter/alert_dialog.dart';
import 'package:meal_app_flutter/main.dart';
import 'package:meal_app_flutter/widgets/main_drawer.dart';
import 'package:meal_app_flutter/dummy_data.dart';
import 'package:meal_app_flutter/models/category.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';
import 'category_screen.dart';

class AddMealsScreen extends StatefulWidget {
  static const routeName = '/add-meal';
  final List<Meal> availableMeals;

  AddMealsScreen(this.availableMeals);

  @override
  State<AddMealsScreen> createState() => AddMealsState();
}

class AddMealsState extends State<AddMealsScreen> {
  var finalsteps = <TextEditingController>[];
  var id = "test";
  var title = TextEditingController();
  var imageUrl = TextEditingController();
  var duration = TextEditingController();
  var complexity = Complexity.simple;
  var affordability = Affordability.affordable;
  var ingredients = TextEditingController();
  var steps = TextEditingController();
  var cards = <Card>[];
  List<String> stepsText = [];
  List<String> ingredientsText = [];
  var finalIngredients = <TextEditingController>[];
  var categories = DUMMY_CATEGORIES;
  List<String> selectedCategories = [];
  List<String> allFilters = [
    "Glutenfrei",
    "Laktosefrei",
    "Vegetarisch",
    "Vegan"
  ];
  List<String> selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Füge ein Rezept hinzu'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "createMeal",
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
            duration: Duration(milliseconds: 800),
            content: Text("Erstelle Rezept..."),
          ));

          var creation;
          try {
            Meal meal = Meal(
              id: imageUrl.text.hashCode.toString(),
              title: title.text,
              imageUrl:
                  "https://images.pexels.com/photos/1565982/pexels-photo-1565982.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1", //imageUrl.text,
              duration: int.parse(duration.text),
              complexity: complexity,
              affordability: affordability,
              ingredients: ingredientsText,
              steps: stepsText,
              isGlutenFree:
                  selectedFilters.contains("Glutenfrei") ? true : false,
              isLactoseFree:
                  selectedFilters.contains("Laktosefrei") ? true : false,
              isVegan: selectedFilters.contains("Vegan") ? true : false,
              isVegetarian:
                  selectedFilters.contains("Vegetarisch") ? true : false,
              categories: selectedCategories,
            );
            creation = await addMeals(meal);
          } catch (e) {
            creation = false;
          }

          debugPrint(creation.toString());
          if (creation) {
            setState(() {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
                duration: Duration(milliseconds: 800),
                content: Text("Rezept erstellt!"),
              ));
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoriesScreen();
              }));
            });
          } else {
            showAlertDialog(context, "Fehler",
                "Rezept konnte nicht erstellt werden\Überprüfe deine Angaben und versuche es erneut");
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.check,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                ),
              ),
            ),
            Text("Zubereitung",
                style: GoogleFonts.roboto(
                    fontSize: 23, fontWeight: FontWeight.normal)),
            ElevatedButton(
              child: stepsText.length > 0
                  ? const Text('Ändere oder lösche Schritte')
                  : const Text('Füge deinem Rezept die nötigen Schritte hinzu'),
              onPressed: () async {
                stepsText = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SOF(stepsText),
                  ),
                );
                if (stepsText != null) stepsText.forEach(print);
                setState(() {});
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: 400,
              height: stepsText.length * 50.0 >= 250
                  ? 250
                  : stepsText.length * 50.0,
              margin: const EdgeInsets.all(10),
              child: stepsText != []
                  ? ListView.builder(
                      itemCount: stepsText.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '${(index + 1)}.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              stepsText[index],
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    )
                  : const Text("Noch keine Schritte hinzugefügt"),
            ),
            Text("Zutaten",
                style: GoogleFonts.roboto(
                    fontSize: 23, fontWeight: FontWeight.normal)),
            ElevatedButton(
              child: ingredientsText.length > 0
                  ? const Text('Ändere oder lösche Zutaten')
                  : const Text('Füge deinem Rezept die nötigen Zutaten hinzu'),
              onPressed: () async {
                ingredientsText = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SOF2(ingredientsText),
                  ),
                );
                if (ingredientsText != null) ingredientsText.forEach(print);
                setState(() {});
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: 400,
              height: ingredientsText.length * 50.0 >= 250
                  ? 250
                  : ingredientsText.length * 50.0,
              margin: const EdgeInsets.all(10),
              child: ingredientsText != []
                  ? ListView.builder(
                      itemCount: ingredientsText.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                '${(index + 1)}.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              ingredientsText[index],
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    )
                  : const Text("Noch keine Zutaten hinzugefügt"),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: duration,
                decoration: const InputDecoration(
                  labelText: 'Dauer',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: imageUrl,
                decoration: const InputDecoration(
                  labelText: 'imageURL',
                ),
              ),
            ),
            // A DropdownButton for the complexity
            Row(
              children: [
                Text(
                  "Schwierigkeite des Rezepts:",
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal)),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton<Complexity>(
                  value: complexity,
                  onChanged: (Complexity? newValue) {
                    setState(() {
                      complexity = newValue!;
                    });
                  },
                  items: Complexity.values
                      .map<DropdownMenuItem<Complexity>>((Complexity value) {
                    return DropdownMenuItem<Complexity>(
                      value: value,
                      child: Text(getMealComplexity(value)),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Preis des Rezepts:",
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.normal)),
                ),
                const SizedBox(
                  width: 100,
                ),
                DropdownButton<Affordability>(
                  value: affordability,
                  onChanged: (Affordability? newValue) {
                    setState(() {
                      affordability = newValue!;
                    });
                  },
                  items: Affordability.values
                      .map<DropdownMenuItem<Affordability>>(
                          (Affordability value) {
                    return DropdownMenuItem<Affordability>(
                      value: value,
                      child: Text(getMealAffordability(value)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Wähle die passenden Kategorien aus:",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: 360,
              height: 300,
              child: Card(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final Category category = categories[index];
                    final color = category.color;
                    return CheckboxListTile(
                      tileColor: color,
                      activeColor: Colors.black87,
                      title: Text(
                        category.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value:
                          selectedCategories.contains(category.id.toString()),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedCategories.add(category.id.toString());
                          } else {
                            selectedCategories.remove(category.id.toString());
                          }
                        });
                      },
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Wähle die passenden Filter aus:",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              width: 360,
              height: 220,
              child: Card(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final filter = allFilters[index];
                    return CheckboxListTile(
                      tileColor: Colors.black12,
                      title: Text(
                        filter,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value: selectedFilters.contains(filter),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedFilters.add(filter);
                          } else {
                            selectedFilters.remove(filter);
                          }
                        });
                      },
                    );
                  },
                  itemCount: allFilters.length,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // A DropdownButton for the affordability
          ],
        ),
      ),
      drawer: MainDrawer(),
    );
  }

  getMealComplexity(Complexity complexity) {
    switch (complexity) {
      case Complexity.simple:
        return 'Einfach';
        // ignore: dead_code
        break;
      case Complexity.challenging:
        return 'Herausfordernd';
        // ignore: dead_code
        break;
      case Complexity.hard:
        return 'Hart';
        // ignore: dead_code
        break;
      default:
        return 'Unbekannt';
    }
  }

  getMealAffordability(Affordability affordability) {
    switch (affordability) {
      case Affordability.affordable:
        return 'Günstig';
        // ignore: dead_code
        break;
      case Affordability.pricey:
        return 'Teuer';
        // ignore: dead_code
        break;
      case Affordability.luxurious:
        return 'Luxuriös';
        // ignore: dead_code
        break;
      default:
        return 'Unbekannt';
    }
  }
}

class SOF extends StatefulWidget {
  List? steps = [];
  SOF(this.steps);
  @override
  _SOFState createState() => _SOFState();
}

class _SOFState extends State<SOF> {
  var finalsteps = <TextEditingController>[];
  var cards = <Card>[];

  Card createCard(String? text) {
    var step = TextEditingController();
    step.text = text ?? "";
    finalsteps.add(step);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Schritt ${cards.length + 1}'),
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: step,
                    decoration: const InputDecoration(
                        labelText: 'Beschreibe den Zubereitungsschritt')),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    int index = finalsteps.indexOf(step);
                    cards.removeAt(index);
                    finalsteps.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.steps != []) {
      widget.steps?.forEach((element) {
        cards.add(createCard(element.toString()));
      });
    } else {
      cards.add(createCard(null));
    }
  }

  _onDone() {
    List<String> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = finalsteps[i].text;
      if (name != "") {
        entries.add(name);
      }
      print(name);
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _onDone();
        },
      )),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return cards[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Icon(Icons.add),
              onPressed: () => setState(() => cards.add(createCard(null))),
            ),
          )
        ],
      ),
      //floatingActionButton:
      //    FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}

class SOF2 extends StatefulWidget {
  List? finalIngredients = [];
  SOF2(this.finalIngredients);
  @override
  _SOF2State createState() => _SOF2State();
}

class _SOF2State extends State<SOF2> {
  var finalIngredients = <TextEditingController>[];
  var cards = <Card>[];

  Card createCard(String? text) {
    var step = TextEditingController();
    step.text = text ?? "";
    finalIngredients.add(step);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Zutat ${cards.length + 1}'),
          Row(
            children: [
              Expanded(
                child: TextField(
                    controller: step,
                    decoration: const InputDecoration(
                        labelText: 'Beschreibe die Zutat')),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  setState(() {
                    int index = finalIngredients.indexOf(step);
                    cards.removeAt(index);
                    finalIngredients.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.finalIngredients != []) {
      widget.finalIngredients?.forEach((element) {
        cards.add(createCard(element.toString()));
      });
    } else {
      cards.add(createCard(null));
    }
  }

  _onDone() {
    List<String> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var name = finalIngredients[i].text;
      if (name != "") {
        entries.add(name);
      }
      print(name);
    }
    Navigator.pop(context, entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _onDone();
        },
      )),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return cards[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Icon(Icons.add),
              onPressed: () => setState(() => cards.add(createCard(null))),
            ),
          )
        ],
      ),
      //floatingActionButton:
      //    FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
    );
  }
}
