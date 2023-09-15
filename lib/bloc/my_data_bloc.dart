import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class MyDataState {}

class MyDataInitial extends MyDataState {}

class MyDataLoading extends MyDataState {}

class MyDataLoaded extends MyDataState {
  final List<dynamic> data;
  MyDataLoaded(this.data);
}

class MyDataError extends MyDataState {
  final String error;
  MyDataError(this.error);
}

abstract class MyDataEvent {}

class FetchMyData extends MyDataEvent {}

class FetchMyDataWithDelay extends MyDataEvent {}

class FetchMyDataWithError extends MyDataEvent {}

class MyDataBloc extends Bloc<MyDataEvent, MyDataState> {
  MyDataBloc() : super(MyDataInitial());

  @override
  Stream<MyDataState> mapEventToState(MyDataEvent event) async* {
    switch (event.runtimeType) {
      case FetchMyData:
      case FetchMyDataWithDelay:
        yield MyDataLoading();
        if (event is FetchMyDataWithDelay) {
          await Future.delayed(const Duration(seconds: 5));
        }
        final response = await _fetchData();
        if (response != null) {
          yield MyDataLoaded(response);
        }
      case FetchMyDataWithError:
        yield MyDataError('Error on Data Loading');
        break;
    }
  }

  Future<List<dynamic>?> _fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      // Error Handling
    }
    return null;
  }
}
