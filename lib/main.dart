import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:udx_playhub_model/udx_playhub_model.dart';

import 'bloc/my_data_bloc.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

final getIt = GetIt.instance;

import 'package:udx_storage/udx_storage.dart';

class StorageImplementation implements Storage {
  StorageImplementation() {
    _map = <String, String>{};
  }

  Map<String, String>? _map;

  @override
  Future<void> clear() async {
    _map = null;
  }

  @override
  Future<void> delete(String key) async {
    _map?.remove(key);
  }

  @override
  Future<String> read(String key) {
    return Future<String>.value(_map?[key] ?? '');
  }

  @override
  Future<void> write(String key, value) async {
    _map?[key] = value;
  }
}

  IpbApiConfiguration getIpbApiConfiguration() {
    return IpbApiConfiguration(
        authToken:
            'qxfeBs0rMzq2NBH5GeBc5TZCrwolXS2BEexq27QFiD5hMOGzOwuuZN4eBud2lOE',
        baseURL: 'https://devapi.p331.valtech-tes.com/ipb/v1/',
        park: 'USF',
        resort: 'UOR',
        land: 'VILLAIN-CON',
        publisher: 'MA');
  }

  PlayhubModel getPlayhub() {
    return PlayhubModel(
        configuration:
            PlayhubConfiguration(ipbApiConfiguration: getIpbApiConfiguration()),
        storage: StorageImplementation(),
        storageKey: 'playhub_test_storage_key');
  }

void setupDependencies() {
  // Register the MyApiClient class without using a singleton.
  getIt.registerFactory(() => PlayhubModel(configuration: configuration, storage: storage, storageKey: storageKey));
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
