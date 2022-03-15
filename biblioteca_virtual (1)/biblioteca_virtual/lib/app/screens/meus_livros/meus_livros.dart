import 'dart:developer';

import 'package:biblioteca_virtual/app/screens/novo_livro/novo_livro.dart';
import 'package:biblioteca_virtual/app/utils/database.dart';
import 'package:biblioteca_virtual/app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MeusLivrosScreen extends StatefulWidget {
  const MeusLivrosScreen({Key? key}) : super(key: key);

  @override
  State<MeusLivrosScreen> createState() => _MeusLivrosScreenState();
}

class _MeusLivrosScreenState extends State<MeusLivrosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NovoLivroScreen(),
          ));
          setState(() {});
        },
        child: Icon(
          CupertinoIcons.add,
          size: 30,
        ),
      ),
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
                  "MEUS LIVROS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Colors.grey,
                    fontSize: 22,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  splashRadius: 25,
                  alignment: Alignment.center,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 35,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getMeusLivros(),
                builder:
                    (context, AsyncSnapshot<List<QueryDocumentSnapshot>> docs) {
                  if (docs.hasData && docs.data!.length > 0) {
                    return Expanded(
                      child: MasonryGridView.count(
                        controller: ScrollController(),
                        itemCount: docs.data!.length,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () async {
                              bool? confirmRemove = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          "Deseja remover?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: Text("Cancelar"),
                                          ),
                                          MaterialButton(
                                            color: Colors.blueAccent,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      ));

                              if (confirmRemove ?? false) {
                                var result = await removerLivro(
                                    "${docs.data![index].id}");
                                if (result) setState(() {});
                              }
                            },
                            onTap: () async {
                              launchURL("${docs.data![index]["link"] ?? ""}");
                            },
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Image.network(
                                    "${docs.data![index]["photo"] ?? ""}",
                                    height: 150,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${docs.data![index]["name"] ?? ""}",
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
                      ),
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Text(
                        "Você não tem livros cadastrados...",
                        style: TextStyle(
                          fontSize: 18,
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
