part of 'frequently_asked_questions_cubit.dart';

@immutable
abstract class FrequentlyAskedQuestionsState {}

class FrequentlyAskedQuestionsInitial extends FrequentlyAskedQuestionsState {}

class FrequentlyAskedQuestionsPostLoaded extends FrequentlyAskedQuestionsState{}

class FrequentlyAskedQuestionsLoaded extends FrequentlyAskedQuestionsState {
  final List<AskedQuestion>?  askedQuestions;

  FrequentlyAskedQuestionsLoaded({required this.askedQuestions});
}
