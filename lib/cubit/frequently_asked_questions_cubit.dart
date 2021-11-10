import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/askedQuestion.dart';
import 'package:rosemary/data/repository.dart';

part 'frequently_asked_questions_state.dart';

class FrequentlyAskedQuestionsCubit
    extends Cubit<FrequentlyAskedQuestionsState> {
  final Repository repository;

  FrequentlyAskedQuestionsCubit({required this.repository})
      : super(FrequentlyAskedQuestionsInitial());

  void fetchAskedQuestions() {
    repository.getAskedQuestions().then((askedQuestions) {
      emit(FrequentlyAskedQuestionsLoaded(askedQuestions: askedQuestions));
    });
  }

  Future<void> postAskedQuestion(
      String title, String description, String? token) async {
    repository.postAskedQuestion(title, description, token);
  }

  Future<void> deleteAskedQuestion(id, token) async {
    repository.deleteAskedQuestion(id, token);
  }

  Future<void> updateAskedQuestion(
      String id, String? token, String title, String description) async {
    repository.putAskedQuestion(id, token, title, description);
  }
}
