abstract class FormValidator {
  String? validateFieldForEmptySpace(value) {
    if (value.length == 0)
      return "Заполните поле";
    else
      return null;
  }
}