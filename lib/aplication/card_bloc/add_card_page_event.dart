part of 'add_card_page_bloc.dart';

abstract class AddCardPageEvent extends Equatable {
  const AddCardPageEvent();

  @override
  List<Object> get props => [];
}

class CompanyChanged extends AddCardPageEvent {
  final Company company;

  CompanyChanged(this.company);
}

class CardNumberChanged extends AddCardPageEvent {
  final String cardNumber;

  CardNumberChanged(this.cardNumber);
}

class SaveNewCard extends AddCardPageEvent {
  final BuildContext context;
  final Company company;
  final String cardNumer;

  SaveNewCard(this.company, this.cardNumer, this.context);
}
