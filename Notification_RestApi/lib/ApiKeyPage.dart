import 'package:dynamicislandeneme/Homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'global.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({Key? key}) : super(key: key);
  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {

  final Uri _urll = Uri.parse('https://crudcrud.com');
  TextEditingController apiKeyController= TextEditingController();

  Future<void> _launchUrl() async {
    if (!await launchUrl(_urll)) {
      throw 'We have a problem $_urll';
    }
  }

  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(namekey, apiKeyController.text.toString());
  }
  Future<String?> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(namekey);
  }
  setData() {
    loadData().then((value) {
      data = value;
    });
  }

  @override
  void initState() {
   setState(() {
     setData();
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.8)])
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child:  TextField(
                    controller: apiKeyController,
                    decoration: const InputDecoration(
                      labelText: "Your api key",
                      border:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){
                        _launchUrl();
                      }, child: Text("create api key",style: TextStyle(color: Colors.black),)),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: (){
                        setState(() {
                          apiKeyController.text=data!;
                        });
                      }, child: Text("last api key call"), style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(5),
                          textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal)),),
                      ElevatedButton(onPressed: (){
                       setState(() {
                         saveData();
                         setData();
                        data!.isEmpty ? Text(""): Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => homePage(
                                )));
                       });
                      }, child: Text("save and go"), style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(5),
                          textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal)))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
