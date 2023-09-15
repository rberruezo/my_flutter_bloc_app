import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/my_data_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc Demo',
      home: BlocProvider(
        create: (context) => MyDataBloc(),
        child: const MyDataPage(),
      ),
    );
  }
}

class MyDataPage extends StatelessWidget {
  const MyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bloc Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<MyDataBloc, MyDataState>(
              builder: (context, state) {
                if (state is MyDataLoading) {
                  return const CircularProgressIndicator();
                } else if (state is MyDataLoaded) {
                  return Text("Data: ${state.data}");
                } else if (state is MyDataError) {
                  return Text("Error: ${state.error}");
                } else {
                  return const Text("Press the buttons to load data.");
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<MyDataBloc>(context).add(FetchMyData());
              },
              child: const Text('Load Data'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<MyDataBloc>(context)
                    .add(FetchMyDataWithDelay());
              },
              child: const Text('Load Data after 5 seconds'),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<MyDataBloc>(context)
                    .add(FetchMyDataWithError());
              },
              child: const Text('Load Data with Error'),
            ),
          ],
        ),
      ),
    );
  }
}
