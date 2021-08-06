import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/company_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../domain/repositories/local_repository.dart';
import '../../infrastructure/core/failure.dart';
import '../../infrastructure/core/localization/localizations.dart';

part 'add_card_page_event.dart';
part 'add_card_page_state.dart';

@injectable
class AddCardPageBloc extends Bloc<AddCardPageEvent, AddCardPageState> {
  AddCardPageBloc(this._service, this._repo)
      : super(AddCardPageInitial(null, '', false));
  final IsService _service;
  final LocalRepository _repo;

  @override
  Stream<AddCardPageState> mapEventToState(
    AddCardPageEvent event,
  ) async* {
    if (event is CompanyChanged) {
      yield AddCardPageInitial(event.company, '', false);
    }
    if (event is CardNumberChanged) {
      yield AddCardPageInitial(null, event.cardNumber, false);
    }
    if (event is SaveNewCard) {
      try {
        final user = _repo.getLocalUser();
        final map = <String, dynamic>{
          'CardCode': event.cardNumer,
          'CompanyID': event.company!.id.toString(),
          'ID': user.id,
          'RegisterMode': user.registerMode,
        };
        final resp = await _service.requestActivationCard(json: map);
        if (resp.statusCode == 0) {
          yield SavedCardForm(event.company, event.cardNumer, true);
        } else {
          yield CardError(
              event.company, event.cardNumer, false, resp.errorMessage);
        }
      } on NoInternetConection {
        yield CardError(event.company, event.cardNumer, false,
            AppLocalizations.of(event.context).translate('nothaveinet'));
      } catch (e) {
        yield CardError(event.company, event.cardNumer, false,
            AppLocalizations.of(event.context).translate('servererror'));
      }
    }
  }
}
