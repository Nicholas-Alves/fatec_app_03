import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {
  // http.Response response = await http.get(Uri.parse(request));
  // print(json.decode(response.body)["results"]["currencies"]["USD"]);
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.green[500],
        primaryColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          hintStyle: TextStyle(color: Colors.green[500]),
        ),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String texto) {
    double real = double.parse(texto != "" ? texto : "0");
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String texto) {
    double _dolar = double.parse(texto != "" ? texto : "0");
    realController.text = (_dolar * dolar).toStringAsFixed(2);
    euroController.text = (_dolar * dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String texto) {
    double _euro = double.parse(texto != "" ? texto : "0");
    realController.text = (_euro * euro).toStringAsFixed(2);
    dolarController.text = (_euro * euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.green[500],
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: pegarDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                "Carregando dados...",
                style: TextStyle(
                  color: Colors.green[500],
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Erro ao carregar os dados",
                  style: TextStyle(
                    color: Colors.green[500],
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.green[500],
                      ),
                      construirTextField(
                          "Reais", "R\$ ", realController, _realChanged),
                      Divider(),
                      construirTextField(
                          "Dólares", "US\$ ", dolarController, _dolarChanged),
                      Divider(),
                      construirTextField(
                          "Euros", "€ ", euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> pegarDados() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

Widget construirTextField(
    String texto, String prefixo, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: texto,
      labelStyle: TextStyle(color: Colors.green[500]),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    style: TextStyle(
      color: Colors.black,
      fontSize: 25,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
