import 'dart:io';
import 'dart:typed_data';

import 'package:biblioteca_virtual/app/utils/database.dart';
import 'package:biblioteca_virtual/app/utils/messages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NovoLivroScreen extends StatelessWidget {
  NovoLivroScreen({Key? key}) : super(key: key);
  final controllerNome = TextEditingController(text: "");
  final controllerLink = TextEditingController(text: "");
  ValueNotifier<Uint8List?> imageNotifier = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        color: Colors.transparent,
        child: SingleChildScrollView(
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
                    "CADASTRAR LIVRO",
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
                height: 20,
              ),
              ValueListenableBuilder<Uint8List?>(
                valueListenable: imageNotifier,
                builder: (context, image, child) => image != null
                    ? Image.memory(
                        image,
                        height: 200,
                      )
                    : Container(
                        height: 200,
                        width: 170,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.grey,
                        )),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', "jpeg", "png"],
                        );
                        if (result != null) {
                          var imageBytes = await File(result.files.single.path!)
                              .readAsBytes();
                          imageNotifier.value = imageBytes;
                        }
                      },
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
                        child: Center(
                          child: Text(
                            "Escolha a capa do livro",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      "Nome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
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
                      child: TextField(
                        controller: controllerNome,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Digite o nome do livro",
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      "Link",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
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
                      child: TextField(
                        controller: controllerLink,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Informe o link do livro",
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: InkWell(
                  onTap: () async {
                    if (controllerLink.text.isEmpty ||
                        controllerNome.text.isEmpty ||
                        imageNotifier.value == null) {
                      return Message.showError(
                          context, 'Os campos são obrigatórios');
                    }
                    var result = await saveLivro(
                        context: context,
                        name: controllerNome.text,
                        link: controllerLink.text,
                        photo: imageNotifier.value!);
                    if (result) Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 2,
                        color: Colors.blueAccent,
                      ),
                    ),
                    child: Center(
                        child: Text(
                      "CADASTRAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
