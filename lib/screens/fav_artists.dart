import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/database/database.dart';
import 'package:transmusicales/models/dataset.dart';
import 'package:transmusicales/utils/data_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/navigation_utils.dart';
import 'artist.dart';

class FavArtistsSreen extends StatefulWidget {
  final String title;
  final SharedPreferences sharedPreferences;

  @override
  _FavArtistsSreen createState() => _FavArtistsSreen();

  const FavArtistsSreen({Key? key, required this.title, required this.sharedPreferences}) : super(key: key);
}

class _FavArtistsSreen extends State<FavArtistsSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController editingController = TextEditingController();
  late String email;
  String searchString = "";
  String? genreSearchString = "artist";
  late Future<List<Dataset>> datasets;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Artist"), value: "artist"),
      const DropdownMenuItem(child: Text("Pays"), value: "pays"),
      const DropdownMenuItem(child: Text("Annee"), value: "annee"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    setState(() {
      datasets = readJson('assets/data/out.json');
      email = widget.sharedPreferences.getString('email')!;

      initNotes();
    });
    super.initState();
  }

  void initNotes() {

  }

  Widget _favArtistScreen(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)), //bo
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton(
                      //dropdown background color
                      underline: Container(), //remove underline
                      items: dropdownItems,
                      value: genreSearchString,
                      onChanged: (String? newValue) {
                        setState(() {
                          genreSearchString = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
                  },
                  controller: editingController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Rechercher",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: getFavStream(email),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      Dataset dataset = Dataset(
                        id: snapshot.data!.docs[index]['id'],
                        artistes: snapshot.data!.docs[index]['artists'],
                        note: snapshot.data!.docs[index]['note'],
                        myNote: snapshot.data!.docs[index]['myNote'],
                        origine_pays1: snapshot.data!.docs[index]['pays'],
                      );
                      switch (genreSearchString) {
                        case 'annee':
                          return dataset.annee
                              .toLowerCase()
                              .contains(searchString.toLowerCase())
                              ? _artist(dataset, context)
                              : Container();

                        case 'pays':
                          return dataset.origine_pays1
                              .toLowerCase()
                              .contains(searchString.toLowerCase())
                              ? _artist(dataset, context)
                              : Container();
                        default:
                          return dataset.artistes
                              .toLowerCase()
                              .contains(searchString.toLowerCase())
                              ? _artist(dataset, context)
                              : Container();
                      }
                    });
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      body: _favArtistScreen(context),
    );
  }

  InkWell _artist(Dataset dataset, BuildContext context) {
    return InkWell(
      onTap: (){
        NavigationUtils.push(context, ArtistSreen(dataset: dataset, title: 'Les Transmusicales', sharedPreferences: widget.sharedPreferences,));
      },
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                Text(dataset.artistes),
                Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: RatingBar.builder(
                            initialRating: dataset.myNote,
                            minRating: 1,
                            direction: Axis.horizontal,
                            itemSize: MediaQuery.of(context).size.width / 25,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              addNotesArtist(
                                  dataset.id, email, rating);
                              setState(() {
                                initNotes();
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 15,
                          height: MediaQuery.of(context).size.width / 15,
                          decoration: const BoxDecoration(
                              color: Colors.amber, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(
                            dataset.note.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ],
                    )),
                Visibility(
                  visible: dataset.spotify.isNotEmpty,
                  child: IconButton(
                    onPressed: () async {
                      if (await canLaunch(dataset.spotify)) {
                        // Launch the url which will open Spotify
                        launch(dataset.spotify);
                      }
                    },
                    icon: Image.asset('assets/icons/spotify.png'),
                    iconSize: MediaQuery.of(context).size.width / 15,
                  ),
                ),
                IconButton(
                    onPressed: () =>
                        addOrRemoveFavArtist(dataset, email),
                    icon: const Icon(Icons.favorite),
                    iconSize: MediaQuery.of(context).size.width / 15
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

