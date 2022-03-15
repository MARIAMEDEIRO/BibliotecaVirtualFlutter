import 'package:biblioteca_virtual/app/utils/authentication.dart';
import 'package:biblioteca_virtual/app/utils/messages.dart';
import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  CadastroScreen({Key? key}) : super(key: key);
  final controllerNome = TextEditingController(text: "");
  final controllerEmail = TextEditingController(text: "");
  final controllerSenha = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                ),
                SizedBox(
                  height: 100,
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
                            hintText: "Digite seu nome",
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
                        "Email",
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
                          controller: controllerEmail,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Digite seu email",
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
                        "Senha",
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
                          controller: controllerSenha,
                          style: TextStyle(fontSize: 18),
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Digite uma senha",
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
                    onTap: () {
                      if (controllerSenha.text.isEmpty ||
                          controllerEmail.text.isEmpty ||
                          controllerNome.text.isEmpty) {
                        return Message.showError(
                            context, 'Os campos são obrigatórios');
                      }
                      var user = Authentication.signUp(
                          context: context,
                          name: controllerNome.text,
                          email: controllerEmail.text,
                          password: controllerSenha.text);

                      if (user != null) Navigator.pop(context);
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
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
                        child: Text(
                      "VOLTAR",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
