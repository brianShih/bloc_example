import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/counter_bloc.dart';
import 'bloc/counter_event.dart';
import 'bloc/counter_state.dart';

void main() {
  // 整個app的啟動點
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 使用Bloc Provider 包裝整個 bloc state的框架
      home: BlocProvider(
        // 由此建立bloc state與event的轉接機制
        create: (context) => CounterBloc(),
        child: const CounterPage(),
      ),
    );
  }
}

// 因透過Bloc 的機制，可將UI與後端商業邏輯，進行動態切割，因此只需要stateless就能完成大部分工作，
// 如果採用statefulwidget反而容易出現大量UI被更新導致而服務緩慢，需要謹慎使用
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter BLoC Example')),
      body: Center(
        // 第一個UI介面，需要先透過Builder建立初始參考資訊，並且後續將會利用blocbuilder傳入的
        // state，將即時資料回拋到UI上，因此BlocBuilder是十分重要與UI對接的一部分
        // 因此，當state.counterValue有更動時，會注入下面這行指令，連帶就會觸發BlocBuilder刷新
        // Bloc state，可以參考counter_bloc中，觸發Event後會對應到 Bloc state的動作
        // emit(CounterState(counterValue: state.counterValue - 1));
        // 因此，在BlocBuilder中，也可以加入一個state確認的動作，搭配不同state對應不同UI輸出
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text('Counter Value: ${state.counterValue}');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // 如同BlocBuilder，counterBloc.add則是觸發Increment的事件，
              // 觸發時，可以回到counter_bloc.dart中，看到如何將event對應到state
              counterBloc.add(Increment());
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              // 說明與 counterBloc.add(Increment());一至
              counterBloc.add(Decrement());
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}