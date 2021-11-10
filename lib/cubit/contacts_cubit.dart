import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/contact.dart';
import 'package:rosemary/data/repository.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final Repository repository;

  ContactsCubit({required this.repository}) : super(ContactsInitial());

  void fetchContacts() {
    repository.getContacts().then((contacts) {
      emit(ContactsLoaded(contacts: contacts));
    });
  }

  Future<void> updateContacts(String id, String phoneNumbers, String socialMedias,
      String workingSchedule, String? token) async {
    var phoneNumbersArr = phoneNumbers.split('\n');
    var socialMediasArr = socialMedias.split('\n');
  
    repository.putContacts(id, phoneNumbersArr, socialMediasArr, workingSchedule, token);
  }
}
