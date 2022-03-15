import 'dart:developer';

import 'package:biblioteca_virtual/app/screens/login/login.dart';
import 'package:biblioteca_virtual/app/screens/meus_livros/meus_livros.dart';
import 'package:biblioteca_virtual/app/utils/authentication.dart';
import 'package:biblioteca_virtual/app/utils/database.dart';
import 'package:biblioteca_virtual/app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final searchNotifier = ValueNotifier<String>("");

void search(String search) {
  searchNotifier.value = search;
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  "O QUE DESEJA LER?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.grey,
                    fontSize: 22,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Authentication.logOut(context: context);
                  },
                  splashRadius: 25,
                  alignment: Alignment.center,
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    size: 30,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 2,
                        color: Colors.blueAccent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: search,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Buscar",
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MeusLivrosScreen(),
                    ));
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.book,
                          size: 25,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Meus Livros",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: getAllLivros(),
                builder:
                    (context, AsyncSnapshot<List<QueryDocumentSnapshot>> docs) {
                  if (docs.hasData && docs.data!.length > 0) {
                    return Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: searchNotifier,
                          builder: (context, String search, _) {
                            List<QueryDocumentSnapshot<Object?>> docsData =
                                docs.data!;

                            docsData = docsData.where((element) {
                              if (search.isEmpty) {
                                return true;
                              }
                              if ("${element["name"] ?? ""}"
                                  .toLowerCase()
                                  .contains("${search.toLowerCase()}")) {
                                return true;
                              }
                              return false;
                            }).toList();
                            return MasonryGridView.count(
                              controller: ScrollController(),
                              itemCount: docsData.length,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    launchURL(
                                        "${docsData[index]["link"] ?? ""}");
                                  },
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          "${docsData[index]["photo"] ?? ""}",
                                          height: 150,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${docsData[index]["name"] ?? ""}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Text(
                        "Não livros cadastrados...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
