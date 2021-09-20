import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/company_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../infrastructure/core/failure.dart';

part 'companylist_event.dart';
part 'companylist_state.dart';

@injectable
class CompanylistBloc extends Bloc<CompanylistEvent, CompanylistState> {
  CompanylistBloc(this._service) : super(CompanylistInitial(<Company>[]));
  final IsService _service;
  @override
  Stream<CompanylistState> mapEventToState(
    CompanylistEvent event,
  ) async* {
    if (event is FetchCompanyList) {
      yield CompanylistLoading(<Company>[]);
      try {
        final list = await _service.getCompanyList();
        yield CompanylistLoaded(list);
      } on EmptyList {
        yield EmptyCompanyList(<Company>[]);
      } catch (e) {
        yield CompanylistError(<Company>[]);
      }
    }
  }
}
