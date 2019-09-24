import 'dart:async';
import 'dart:ui';

import 'package:farmsmart_flutter/model/bloc/chatFlow/CreateAccountFlow.dart';
import 'package:farmsmart_flutter/model/bloc/chatFlow/FlowCoordinator.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:farmsmart_flutter/model/entities/loading_status.dart';
import 'package:farmsmart_flutter/model/repositories/account/AccountRepositoryInterface.dart';
import 'package:farmsmart_flutter/ui/LandingPage.dart';
import 'package:farmsmart_flutter/ui/startup/viewmodel/startupViewModel.dart';
import 'package:intl/intl.dart';

import '../../../farmsmart_localizations.dart';
import '../ViewModelProvider.dart';

class _LocalisedStrings {
  static String detailText() =>
      Intl.message('A network and knowledge source for farmers in Kenya');

  static String actionText() => Intl.message('Get Started');

  static String footerText() =>
      Intl.message('Switch Langauge – Badilisha Lugha');
}

class _Assets {
  static const headerImage = "assets/raw/illustration_welcome.png";
  static const logoImage = "assets/raw/logo_default.png";
}

class StartupViewModelProvider implements ViewModelProviderInterface<StartupViewModel> {
  final AccountRepositoryInterface _accountRepository;
  StartupViewModel _snapshot;
  final StreamController<StartupViewModel> _controller =
      StreamController<StartupViewModel>.broadcast();

  StartupViewModelProvider(this._accountRepository);

  NewAccountFlowCoordinator _accountFlow;

  @override
  StartupViewModel initial() {
    if (_snapshot == null) {
      _accountFlow = NewAccountFlowCoordinator(
        _accountRepository,
        _accountFlowStatusChanged,
      );
      _accountFlow.init();
      _accountRepository.observeAuthorized().listen((account) {
        if (account != null) {
          account.profileRepository.observeCurrent().listen((currentProfile) {
            _updateState(currentProfile);
          });
          account.profileRepository.getCurrent().then((currentProfile) {
            _updateState(currentProfile);
          });
        } else {
          _updateState(null);
        }
      });
      _setState(false, loading: true);
      _refresh();
    }
    return _snapshot;
  }

  void _accountFlowStatusChanged(FlowCoordinator coordinator) {}

  void _updateState(ProfileEntity currentProfile) {
    _setState(
      (currentProfile != null),
      loading: false,
    );
  }

  @override
  StartupViewModel snapshot() {
    return _snapshot;
  }

  @override
  Stream<StartupViewModel> stream() {
    return _controller.stream;
  }

  void _setState(
    bool authorized, {
    bool loading = false,
  }) {
    _snapshot = StartupViewModel(
      loading ? LoadingStatus.LOADING : LoadingStatus.SUCCESS,
      _refresh,
      authorized,
      _landingViewModel(),
    );
    _controller.sink.add(_snapshot);
  }

  LandingPageViewModel _landingViewModel() {
    return LandingPageViewModel(
      detailText: _LocalisedStrings.detailText(),
      actionText: _LocalisedStrings.actionText(),
      footerText: _LocalisedStrings.footerText(),
      headerImage: _Assets.headerImage,
      subtitleImage: _Assets.logoImage,
      newAccountFlow: _accountFlow,
      switchLanguageTapped: (language) => _switchLanguage(language),
    );
  }

  _switchLanguage(String language) async {
    FarmsmartLocalizations.persistLocale(Locale(language));
    await FarmsmartLocalizations.load(Locale(language)).then((_) {
      _setState(false);
    });
  }

  void _refresh() {
    _accountRepository.authorized();
  }

  void dispose() {
    _controller.sink.close();
    _controller.close();
  }
}
