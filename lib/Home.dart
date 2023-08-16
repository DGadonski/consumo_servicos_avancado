// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperarPreco() async{
    String url = 'https://blockchain.info/ticker';
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot){

        String resultado = '';  
        double valor = 0;      
        switch (snapshot.connectionState) {
          case ConnectionState.none:                                            
          case ConnectionState.waiting:
            print('conexão waiting');    
            resultado = 'Carregando...';        
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            print('conexão done');            
            resultado = 'Carregou!';   
                if (snapshot.hasError) {
                  resultado = 'Erro na conexão';      
                } else {

                  valor = snapshot.data!['BRL']['buy'];
                  resultado = 'O valor é R\$$valor';

                }            
        }   

        return Center(
          child: Text( resultado ),
        );               
        
      }
    );
  }
}

