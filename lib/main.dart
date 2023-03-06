import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:http/http.dart" as http;
import "dart:convert";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputcontroller = TextEditingController();
  String word = '';
  String final_word = '';
  final _resultcontroller = TextEditingController();

  void clearText() {
    _inputcontroller.clear();
    _resultcontroller.clear();
  }
  Future<void> fetchapi(String text) async{
    var url = Uri.parse("http://localhost:8080/text");
    var body = {"text":text};
    final response = await http.post(url,body:jsonEncode(body),headers: {"Content-Type":"application/json"});
    if(response.statusCode==200){
      if(response.body!=null){
        Map<String,dynamic> jsonbody = json.decode(response.body);
        print(jsonbody);
        setState(() {
          _resultcontroller.text = jsonbody["text"];
        });
      }else{
        throw "Error";
      }
    }else{
      throw "Error";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCRThaiEdited'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepOrange.shade100,
              border: Border.all(width: 5.0, color: Colors.black),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: const Offset(2.0, 5.0),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                ),
              ]),
          //alignment: Alignment.center,
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'กรอกข้อความที่ได้จากการรู้จำอักขระ',
                        style: TextStyle(
                            fontSize: 30.0, color: Colors.brown.shade500),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _inputcontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(),
                    hintText: 'ใส่ข้อความจากการรู้จำอักขระของคุณที่นี่',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    child: Text('แก้ไข'),
                    onPressed: ()  {
                       fetchapi(_inputcontroller.text);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _resultcontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(),
                    hintText: 'ผลลัพธ์จะปรากฎที่นี่',
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      child: Text('คัดลอก'),
                      onPressed: () {
                        final answer = ClipboardData(text: _resultcontroller.text);
                        Clipboard.setData(answer);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      child: Text('รีเซ็ต'),
                      onPressed: clearText
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}