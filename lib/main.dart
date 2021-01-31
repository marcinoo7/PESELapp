import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Sprawdzanie nr. PESEL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String PESEL = "";
  bool isCorrect = false;
  String isCorrectText = "";
  String birthDataText = "";
  String sexText = "";
  String controlSumText = "";
  var wages = [1,3,7,9];
  final myController = TextEditingController();
  final String regex = r'^[0-9]{11}$';


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  int calculateControlSum(){
    int sum = 0;

    for(int i = 0; i < 10; i++)
      {
        sum += wages[i%4] * int.parse(PESEL[i]);
      }
    return 10 - sum%10;
  }

  void checkPESEL(){
    setState(() {
      PESEL = myController.text;
      if(RegExp(regex).hasMatch(PESEL))
        {
          isCorrect = true;
          isCorrectText = "Nr. PESEL jest poprawny";
        }
      else {
        isCorrect = false;
        isCorrectText = "Nr. PESEL nie jest poprawny";
      }

      if(isCorrect){
        int year = int.parse(PESEL.substring(0,2)) + 1900;
        int month = int.parse(PESEL.substring(2,4));
        int day = int.parse(PESEL.substring(4,6));

        while(month > 20){
          month -= 20;
          year += 100;
        }
        birthDataText = "";

        if(day < 10)
          birthDataText = "0";
        birthDataText += day.toString() + ".";

        if(month < 10)
          birthDataText += "0";
        birthDataText += month.toString() + ".";

        birthDataText += year.toString();

        if(int.parse(PESEL[9]) % 2 == 0)
          sexText = "Kobieta";
        else sexText = "Mezczyzna";

        if(calculateControlSum() == int.parse(PESEL[10]))
          controlSumText = "Poprawna";
        else controlSumText = "Nie poprawna";
      }

      else{
        birthDataText = "";
        sexText = "";
        controlSumText = "";
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Wprowadz nr. PESEL',
            ),
            TextField(
              controller: myController,

            ),
            Text(
              '$PESEL',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
                '$isCorrectText'
            ),
            Text(
                'Data urodzenia: $birthDataText'
            ),
            Text(
                'Plec: $sexText'
            ),
            Text(
                'Suma kontrolna: $controlSumText'
            ),
            RaisedButton(
              onPressed: checkPESEL,
              child: Text("Sprawdz PESEL"),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
