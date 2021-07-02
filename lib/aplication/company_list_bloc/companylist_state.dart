part of 'companylist_bloc.dart';

abstract class CompanylistState extends Equatable {
  const CompanylistState(this.list);
  final List<Company> list;
  @override
  List<Object> get props => [list];
}

class CompanylistInitial extends CompanylistState {
  CompanylistInitial(List<Company> list) : super(list);
}

class CompanylistLoading extends CompanylistState {
  CompanylistLoading(List<Company> list) : super(list);
}

class CompanylistLoaded extends CompanylistState {
  CompanylistLoaded(List<Company> list) : super(list);
}
class EmptyCompanyList extends CompanylistState {
  EmptyCompanyList(List<Company> list) : super(list);
}
class CompanylistError extends CompanylistState {
  CompanylistError(List<Company> list) : super(list);
}
