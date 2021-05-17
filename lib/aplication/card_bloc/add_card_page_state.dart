part of 'add_card_page_bloc.dart';

abstract class AddCardPageState extends Equatable {
  const AddCardPageState(this.company, this.cardNumber, this.isSaved);
  final Company? company;
  final String cardNumber;
  final bool isSaved;
  @override
  List<Object> get props => [];
}

class AddCardPageInitial extends AddCardPageState {
  AddCardPageInitial(Company? company, String cardNumber, bool isSaved)
      : super(company, cardNumber, isSaved);
}

class SavedCardForm extends AddCardPageState {
  SavedCardForm(Company? company, String cardNumber, bool isSaved)
      : super(company, cardNumber, isSaved);
}

class CardError extends AddCardPageState {
  CardError(Company? company, String cardNumber, bool isSaved,this.error)
      : super(company, cardNumber, isSaved);
  final String? error;
}
