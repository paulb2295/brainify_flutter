abstract class DataState<T, E>{
  final T? data;
  final E? exception;
  final int? code;

  const DataState({this.data, this.exception, this.code});
}

class DataSuccess<T> extends DataState<T, dynamic>{
  const DataSuccess({super.data, super.code});
}

class DataFailure<E> extends DataState<dynamic, E>{
  const DataFailure({super.exception, super.code});
}
