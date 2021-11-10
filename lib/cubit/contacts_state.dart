part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final Contact? contacts;

  ContactsLoaded({required this.contacts});
}
