import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'global.dart';

class dataListPage extends StatefulWidget {
  @override
  State<dataListPage> createState() => _dataListPageState();
}

class _dataListPageState extends State<dataListPage> {
  List? data1;

  @override
  void initState() {
    getDio();
    super.initState();
  }
  Future Refresh()async {
    getDio();
  }
  void getDio()async{
    try{
      var response = await Dio().get("https://crudcrud.com/api/$data/arda");
        setState(() {
          data1 = response.data as List? ;
        });

    }catch(e){
      print(e);
    }
  }
  Future Delete(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('https://crudcrud.com/api/$data/arda/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
    } else {

      throw Exception('Failed to delete album.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.8)])
        ),
        child: Center(
            child:RefreshIndicator(
                onRefresh: Refresh,
                child: ListView.builder(
                    itemCount: data1?.length,
                    itemBuilder: (BuildContext context, int id) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                                height: (MediaQuery.of(context).size.height / 1),
                                width: 600,
                                child: RefreshIndicator(
                                  onRefresh: Refresh,
                                  child: ListView.builder(
                                    itemCount: data1 == null ? 0 : data1?.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        width: 300,
                                        height: 150,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(

                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Container(
                                                height: 100,
                                                width: 150,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin:EdgeInsets.all(15),
                                                          child: Text(data1?[index]["title"],style: TextStyle(fontSize:(MediaQuery.of(context).size.width / 30),)),
                                                        ),
                                                        Container(
                                                          margin:EdgeInsets.all(15),
                                                          child: Text(data1?[index]["packageName"],style: TextStyle(fontSize:(MediaQuery.of(context).size.width / 45), ),),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 15,left: 15,bottom: 15,top: 15),
                                                          width: 300,
                                                          height: 65,
                                                          child:
                                                              SingleChildScrollView(
                                                                scrollDirection: Axis.vertical,
                                                                child: Column(
                                                                  children: [
                                                                    Text(data1?[index]["text"]),
                                                                  ],
                                                                )
                                                              )
                                                        ),
                                                        Container(
                                                          child: IconButton(onPressed: () {
                                                              setState(() {
                                                                Delete(data1?[index]["_id"]);
                                                                getDio();
                                                              });
                                                          },icon: Icon(Icons.delete),),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                            )),

                                      );
                                    },
                                  ),
                                )
                            ),
                          ],
                        ),

                      );
                    }))),
      )
    );
  }
}

