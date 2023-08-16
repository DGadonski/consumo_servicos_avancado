// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, file_names

import 'package:consumo_servicos_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> _recuperarPostagens() async {
    
    http.Response response = await http.get(Uri.parse(_urlBase));
    var dadosJson = json.decode( response.body );

    List<Post> postagens = [];

    for( var post in dadosJson ){
            
      Post p = Post(
        userId: post["userId"], 
        id: post["id"], 
        title: post["title"], 
        body: post["body"]);

      postagens.add( p );
    
    }
    return postagens;    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot){

          // return  
          switch( snapshot.connectionState ){
            case ConnectionState.none :
            case ConnectionState.waiting :
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active :
            case ConnectionState.done :
              if( snapshot.hasError ){
                return Center(
                child: Text('Deu problema.'),
              );
              }else {
                
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                    itemBuilder: (context, index){

                      List<Post> lista = snapshot.data!;
                      Post post = lista[index];
                      
                      return ListTile(
                        title: Text( post.title ),
                        subtitle: Text( post.id.toString() ),
                      );
                    
                    }
                );

              }
          }
        },
      ),
    );
  }
}
