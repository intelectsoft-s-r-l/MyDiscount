part of 'companylist_bloc.dart';

abstract class CompanylistEvent extends Equatable {
  const CompanylistEvent();

  @override
  List<Object> get props => [];
}

class FetchCompanyList extends CompanylistEvent {}
