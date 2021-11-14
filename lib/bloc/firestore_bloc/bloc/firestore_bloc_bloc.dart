import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'firestore_bloc_event.dart';
part 'firestore_bloc_state.dart';

class FirestoreBlocBloc extends Bloc<FirestoreBlocEvent, FirestoreBlocState> {
  FirestoreBlocBloc() : super(FirestoreBlocInitial()) {
    on<FirestoreBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
