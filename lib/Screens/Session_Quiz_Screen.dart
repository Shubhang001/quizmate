import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/models/SessionModel.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/repository/session_repo.dart';
import 'package:quiz_app/repository/user_repo.dart';

class Session_Quiz_Screen extends StatefulWidget {
   Session_Quiz_Screen({super.key,required this.Session_Id,required this.Session_user_Id});
  String Session_Id;
  String Session_user_Id;

  @override
  State<Session_Quiz_Screen> createState() => __Session_Quiz_ScreenState();
}

class __Session_Quiz_ScreenState extends State<Session_Quiz_Screen> {
  Session_Model response = new Session_Model();
  int index=0;
  int toggle = 0;
  @override
  void initState() {
    // TODO: implement initState
    callfunction();
    super.initState();
  }
  void callfunction()async {
   print('session fetched');
   Session_Repository repo1 = new Session_Repository();
   UserRepository repo2 = new UserRepository();
   user_model token = new user_model();
   token  = await repo2.fetchUserDetails();
   response= await repo1.fetchsession(token.token.toString(),widget.Session_Id);
   setState(() {
     
   });
  }
    void optionchoose1() {
    setState(() {
      toggle = 1;

    });
  }

  void optionchoose2() {
    setState(() {
      toggle = 2;

    });
  }

  void optionchoose3() {
    setState(() {
      toggle = 3;
    });
  }

  void optionchoose4() {
    setState(() {
      toggle = 4;
    });
  }

  void nextQuestion() {
    if (index != response.sessionQuestionList!.length-1) {
      setState(() {
        index++;
        toggle = 0;
      });
    }
  }

  void prevQuestion() {
    if (index != 0) {
      setState(() {
        index--;
        toggle = 0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
            child: Text(
          "All the Best",
          style:
              GoogleFonts.rye(color: Colors.black, fontWeight: FontWeight.bold),
        )),
      ),
      body:  response.sessionQuestionList==null?const Center(
        child: SpinKitChasingDots(color: Colors.blueAccent),
      ):Column(
        children: [
          response==null?
          const Center(child: CircularProgressIndicator()):
          SizedBox(
            height: height * 0.3,
            width: width * 0.95,
            child: Card(
              elevation: 5,
              child: Center(
                  child: Text(
                    response.sessionQuestionList!.elementAt(index).question.toString(),
                style: GoogleFonts.merriweather(
                    fontSize: 20, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: optionchoose1,
                child: SizedBox(
                  height: height * 0.08,
                  width: width * 0.95,
                  child: Card(
                    color: toggle == 1 ? Colors.green : Colors.white70,
                    elevation: toggle == 1 ? 30 : 5,
                    child: Center(
                      child: Text(  response.sessionQuestionList!.elementAt(index).options1.toString(),
                              style: GoogleFonts.merriweather(
                                fontSize: 15,
                              )),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: optionchoose2,
                child: SizedBox(
                  height: height * 0.08,
                  width: width * 0.95,
                  child: Card(
                    color: toggle == 2 ? Colors.green : Colors.white70,
                    elevation: toggle == 2 ? 30 : 5,
                    child: Center(
                        child: Text( response.sessionQuestionList!.elementAt(index).options2.toString(),
                            style: GoogleFonts.merriweather(
                              fontSize: 15,
                            ))),
                  ),
                ),
              ),
              InkWell(
                onTap: optionchoose3,
                child: SizedBox(
                  height: height * 0.08,
                  width: width * 0.95,
                  child: Card(
                    color: toggle == 3 ? Colors.green : Colors.white70,
                    elevation: toggle == 3 ? 30 : 5,
                    child: Center(
                        child: Text(response.sessionQuestionList!.elementAt(index).options3.toString(),
                            style: GoogleFonts.merriweather(
                              fontSize: 15,
                            ))),
                  ),
                ),
              ),
              InkWell(
                onTap: optionchoose4,
                child: SizedBox(
                  height: height * 0.08,
                  width: width * 0.95,
                  child: Card(
                    color: toggle == 4 ? Colors.green : Colors.white70,
                    elevation: toggle == 4 ? 30 : 5,
                    child: Center(
                        child: Text(response.sessionQuestionList!.elementAt(index).options4.toString(),
                            style: GoogleFonts.merriweather(
                              fontSize: 15,
                            ))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: prevQuestion,
                icon: const Icon(Icons.arrow_circle_left_sharp),
                iconSize: 60,
              ),
              IconButton(
                onPressed: nextQuestion,
                icon: const Icon(Icons.arrow_circle_right_sharp),
                iconSize: 60,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: (){}, child: const Text("Submit")),
              ElevatedButton(
                  onPressed: (){}, child: const Text("Finish Quiz")),
            ],
          )
        ],
      ),
    );
  }
}