import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 콜백함수 : 부모->자식 (사용할 함수 주기) , 자식->부모 (InkWell 이벤트 처리)
void main() {
  runApp(const MyApp());
}

  //MyApp
  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: ParentView(),
      );
    }
  } // end of MyApp


class ParentView extends StatefulWidget {
  const ParentView({super.key});

  @override
  State<ParentView> createState() => _ParentViewState();
}

class _ParentViewState extends State<ParentView> {

  String childMsgContent = "여기는 부모 위젯 영역";
  
  // B자식 위젯한테 전달 할 함수를 설계, 자식에게 온 데이터 전달 받기
  void onCallbackPressed(String msg){ // 메서드 선언()
    print("자식 위젯한테 이벤트가 발생함!");
    setState(() { // build메서드 재실행
      childMsgContent = msg;
    });
  }

  // A자식 위젯한테 전달 할 함수를 설계
  void onCallbackPressedA(){
    print("자식 위젯한테 이벤트가 발생함!");
    setState(() { // build메서드 재실행
      childMsgContent = "A연락 왔어";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1 ,child: Center(child: Text(childMsgContent))),
            Expanded(flex: 1 ,child: ChildA(callbackA: onCallbackPressedA)),
            Expanded(flex: 1 ,child: ChildB(onCallback: onCallbackPressed)), // 메서드 호출
          ],
        ),
      ),
    );
  }
}

class ChildA extends StatelessWidget {

  // 함수 타입
  final VoidCallback callbackA;

  // 생성자
  const ChildA({required this.callbackA ,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: callbackA,
        child: Container(
          color: Colors.deepOrange,
        ),
      ),
    );
  }
}

class ChildB extends StatelessWidget {
  
  // 함수 타입
  // final VoidCallback callback; //dart VoidCallback 단순 콜백, 데이터 못받고

  // 함수 모양 설계 변경
  final Function(String msg) onCallback;
  
  // 생성자
  const ChildB({required this.onCallback,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell( // 자식 위젯에 이벤트등이 발생했을 때 어떻게 처리할 지 처리
        onTap: () {
          onCallback("자식B가 연산해서 데이터 전달"); // 원래 onTap의 모양은 익명 함수인데(onTap: callback) 내가 설정한 콜백 함수 모양으로 바꿔줘야 함
        }
        , // 부모 위젯과 연결된 상태
        child: Container(
          width: double.infinity, // Container는 child만큼 크기가 줄어들어 width 설정 해줘야 함
          color: Colors.red,
          child: Center(child: Text("CHILD B")),
        ),
      ),
    );
  }
}