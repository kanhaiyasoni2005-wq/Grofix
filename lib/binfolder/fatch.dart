import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class showData extends StatefulWidget{
  const showData({super.key});

  @override
  State<showData> createState() => _showDataState();
}

class _showDataState extends State<showData> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("firebase data"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(), 
        builder: (context,snapshots) {
          if( snapshots.connectionState == ConnectionState.waiting){
              return Center(child:CircularProgressIndicator(),); }
            if(snapshots.hasData){
              return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index){
                return ListTile(
                  leading: Text("${index+1}"),
                  title: Text("${snapshots.data!.docs[index]["name"]}"),
                  subtitle: Text("${snapshots.data!.docs[index]["Email"]}"),
                );
              });

            }else if(snapshots.hasError){
              return Center(child: Text("Error - ${snapshots.error.toString()}")
              );


            }

          
          else{
            return Center(child: CircularProgressIndicator(),);

          }
        })
    );
  }
}

