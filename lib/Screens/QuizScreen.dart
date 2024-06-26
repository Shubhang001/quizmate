import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/Screens/ScoreCard.dart';

import 'package:quiz_app/models/Question_Paper_model.dart';
import 'package:quiz_app/models/Score_Card_Model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/repository/Qestion_repo.dart';
import 'package:quiz_app/repository/user_repo.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key,required this.category1,required this.e,required this.m,required this.h});
  String category1;

  int e;
  int m;
  int h;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
   List <Map<String,dynamic>> responseList=[];
  int toggle = 0;
  int maximumMarks=0;
   
Question_Paper_Model response = new Question_Paper_Model();
user_model token = new user_model();
Score_Card_Model scorecard = new Score_Card_Model();

  @override
  void initState() {
    callfunction();
    super.initState();
  }

  void callfunction() async {
 
    print('questions called');
    QuestionRepository repo1 = QuestionRepository();
    int totalmarks=0;
    response = await repo1.fetchquestion(widget.category1,widget.e,widget.m,widget.h);

    for(int i =0;i<response.questionList!.length;i++)
    {
      totalmarks= totalmarks+ int.parse(response.questionList!.elementAt(i).marks.toString());
    }
    maximumMarks=totalmarks;
    print(response.questionList!.length);
    setState(() {
      
    });
  }

  int index = 0;
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
    if (index != response.questionList!.length-1) {
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
  void submit()
  {
 responseList.add({
  "id":response.questionList!.elementAt(index).id,
  "rightOption":toggle
 });
  }
   void Finish()
  async {
    print(responseList);
    UserRepository userrepo = new UserRepository();
    token = await userrepo.fetchUserDetails();
    print(token.token);
    scorecard= await userrepo.responsesunbmit(token.token.toString(), response.questionList!.length, maximumMarks, responseList, widget.category1);
    print(scorecard.responseList!.elementAt(0).question);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ScoreCardScreen( scorecard: scorecard,)));
    
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
    
        title: Center(
            child: Text(
          "All the Best",
          style:
              GoogleFonts.rye( fontWeight: FontWeight.bold),
        )),
      ),
      body: response.questionList==null?const Center(
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
                    response.questionList!.elementAt(index).question.toString(),
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
                      child: Text(  response.questionList!.elementAt(index).options1.toString(),
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
                        child: Text( response.questionList!.elementAt(index).options2.toString(),
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
                        child: Text(response.questionList!.elementAt(index).options3.toString(),
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
                        child: Text(response.questionList!.elementAt(index).options4.toString(),
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
              ElevatedButton(onPressed: submit, child: const Text("Submit")),
              ElevatedButton(
                  onPressed: Finish, child: const Text("Finish Quiz")),
            ],
          )
        ],
      ),
    );
  }
}
