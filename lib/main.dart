import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'light level',
      theme: ThemeData(primarySwatch: Colors.red,),
      home: const Task(),
    );
  }
}

class Task extends StatefulWidget
{
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task>
{
  int dwValue = 0;
  late Light light;
  late StreamSubscription subscription;

  void onData(int dw) async
  {
    debugPrint("dw value: $dwValue");
    setState(()
    {
      dwValue = dw;
    });
  }

  void stopListening()
  {
    subscription.cancel();
  }

  void startListening()
  {
    light = Light();

    try
    {
      subscription = light.lightSensorStream.listen(onData);
    } on LightException catch (exception)
    {
      debugPrint(exception.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async
  {
    startListening();
  }

  @override
  Widget build(BuildContext context)
  {
    Color backgroundColor;
    Color textColor;


    if (dwValue < 20)
    {
      backgroundColor = Colors.black;
      textColor = Colors.white;
    }

    else if (dwValue > 20 && dwValue < 160)
    {
      backgroundColor = Colors.red;
      textColor = Colors.green;
    }

    else
    {
      backgroundColor = Colors.white;
      textColor = Colors.black;
    }


    return SafeArea(

      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(child:
        Text('Hossam', style: TextStyle(color: textColor, fontSize: 50,),),
        ),
      ),
    );
  }
}