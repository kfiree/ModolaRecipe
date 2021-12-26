import 'package:flutter/material.dart';

import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Views/main_screen.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modolar_recipe/Widgets/loading.dart';

class ProfileScreen extends StatelessWidget {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("user_data");
  ProfileScreen({Key? key}) : super(key: key);

  static const String idScreen = "profile";

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map;
    final UID = routeArgs['UID'];
    var userData = _firebaseFirestore.doc(UID).get();

    return FutureBuilder<DocumentSnapshot>(
      future: _firebaseFirestore.doc(UID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 248, 191, 176),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleNetworkImage(
                              radius: 130,
                              imageURL: data['image'],
                              // 'https://scontent.ftlv1-1.fna.fbcdn.net/v/t1.18169-9/10151952_10203690787413476_8739758980547261236_n.jpg?_nc_cat=111&ccb=1-5&_nc_sid=cdbe9c&_nc_ohc=GgT6-iP6Wc0AX_cd0Ip&_nc_ht=scontent.ftlv1-1.fna&oh=00_AT9em3xvGi6HMFAVAUGCUglWYydbeWu_zbyM0JhK6wM7wg&oe=61E1E285',
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              data['name'],
                              // "Hen",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 22.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Posts",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            data['posts'],
                                            // "1200",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Votes",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "21.2K",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Rate",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "+1200",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About me:",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontStyle: FontStyle.normal,
                              fontSize: 28.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          data['about_me'],
                          // 'My name is Hen and when i\'ll grow up i want to be a computer\'s Doctor.\nI am the founder of this AMAZING app.\n'
                          // 'Have fun using it. Let\'s start cocking!',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: 300.00,
                  child: RaisedButton(
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    elevation: 0.0,
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Color.fromARGB(255, 248, 191, 176),
                              Color.fromARGB(255, 248, 137, 99),
                              // Colors.white,
                            ]),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Contact me",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.0,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  right: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleButton(
                        color: Colors.black,
                        icon: Icons.arrow_back,
                        callback: () => {
                              Navigator.of(context).pushNamed(
                                MainScreen.idScreen,
                                arguments: {'UID': UID},)
                            }),
                  ),
                ),
              ],
            ),
          );
        }

        return Loading();
      },
    );
  }
  // getUserData(String uid) {
  //   return _firebaseFirestore.doc(uid).get();
  // }
}

// class GetUserName extends StatelessWidget {
//   final String documentId;

//   GetUserName(this.documentId);

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users = FirebaseFirestore.instance.collection('user_data');

//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }

//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//           return Text("Full Name: ${data['name']}");
//         }

//         return Text("loading");
//       },
//     );
//   }
// }


