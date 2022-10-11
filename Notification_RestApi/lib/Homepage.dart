import 'dart:isolate';
import 'dart:ui';
import 'package:dynamicislandeneme/Model.dart';
import 'package:dynamicislandeneme/dataListPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'global.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String Title1="";
  String Title2 = "";
  String? Title3;
  bool started = false;
  bool _loading = false;
  double islandHeight= 36;
  double islandWidth = 100;
  double islandX = 10;
  ReceivePort port = ReceivePort();
  double? lastWidth;
  double? lastHeight;
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  static void _callback(NotificationEvent evt) {
    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
    if (send == null) print("can't find the sender");
    send?.send(evt);
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize(callbackHandle: _callback);
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
    port.listen((message) => onData(message));
    bool? isR = await NotificationsListener.isRunning;
    print("""Service is ${isR == false ? "not " : ""}aleary running""");

    setState(() {
      started = isR!;
    });
  }

  void onData(NotificationEvent event) {
    setState(() {
      if(event.title!.isNotEmpty){
        Services.createUser(event.title.toString(), event.text.toString(), event.packageName.toString());
      }else{

      }
    });
    if (!event.packageName!.contains("example")) {
      // TODO: fix bug
    }
  }

  void startListening() async {
    print("start listening");
    setState(() {
      _loading = true;
    });
    bool? hasPermission = await NotificationsListener.hasPermission;
    if (hasPermission == false) {
      print("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    bool? isR = await NotificationsListener.isRunning;
    if (isR == false) {
      await NotificationsListener.startService(
          title: "Dynamic island working");
    }

    setState(() {
      started = true;
      _loading = false;
    });
  }

  void stopListening() async {
    print("stop listening");

    setState(() {
      _loading = true;
    });

    await NotificationsListener.stopService();

    setState(() {
      started = false;
      _loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF39C12),
      body: Center(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.8)])
            ),
            child: Stack(
              children: [
               Container(
                 margin: EdgeInsets.only(top: 70),
                 child:  Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("1- Enter the api key and make sure you are connected."),
                       ],
                     ),
                     SizedBox(height: 5,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("2- Activate the button to listen for notifications."),
                       ],
                     ),
                     SizedBox(height: 5,),
                     Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("3- All notifications you receive will be on the archive page."),
                       ],
                     ),
                     SizedBox(height: 35,),
                     Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.warning),
                         Text(" You cannot record when the button is not active."),
                       ],
                     ),
                   ],
                 ),
               ),
                Center(
                    child: GestureDetector(
                      onTap: started ? stopListening : startListening,
                      child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Center(
                            child:
                            _loading
                                ? Icon(Icons.close)
                                : (started ? Icon(Icons.stop,color: Colors.purple.withOpacity(0.8),size: 50,) : Icon(Icons.play_arrow,color: Colors.blue.withOpacity(0.8),size: 50,)),
                          )
                      ),
                    )
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [  ElevatedButton(onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => dataListPage(
                                )));
                      }, child: Text("Go archive",style: TextStyle(fontSize: 15),), style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal)),),
                      ],
                    ),
                    SizedBox(height: 50,)
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}