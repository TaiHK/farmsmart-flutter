import 'dart:async';

import 'package:farmsmart_flutter/data/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/data/bloc/plot/PlotDetailProvider.dart';
import 'package:farmsmart_flutter/data/bloc/recommendations/RecommendationListProvider.dart';
import 'package:farmsmart_flutter/data/model/PlotEntity.dart';
import 'package:farmsmart_flutter/data/repositories/crop/CropRepositoryInterface.dart';
import 'package:farmsmart_flutter/data/repositories/plot/PlotRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/loading_status.dart';
import 'package:farmsmart_flutter/ui/myplot/PlotList.dart';
import 'package:farmsmart_flutter/ui/myplot/PlotListItem.dart';
import 'package:intl/intl.dart';

import 'PlotToPlotListItemViewModel.dart';

/*
       [Model]    ->               [Bloc]             -> [View]  
   [repo , model] -> [ViewModelProvider, Transformer] -> [viewModel, widget]
*/

class _Strings {
  static final recommendations = "Recommendations";
  static final addCrop = "Add Another Crop";
}

class _Constants {
  static const inputScale = 10.0;
}

class PlotListProvider implements ViewModelProvider<PlotListViewModel> {
  final PlotRepositoryInterface _plotRepo;
  final CropRepositoryInterface _cropRepo;
  final String _title;
  PlotListViewModel _snapshot;
  PlotListProvider({
    String title,
    PlotRepositoryInterface plotRepository,
    CropRepositoryInterface cropRepository,
  })  : this._title = title,
        this._plotRepo = plotRepository,
        this._cropRepo = cropRepository;

  final StreamController<PlotListViewModel> _controller =
      StreamController<PlotListViewModel>.broadcast();

  @override
  StreamController<PlotListViewModel> observe() {
    return _controller;
  }

  @override
  PlotListViewModel snapshot() {
    return _snapshot;
  }

  void dispose() {
    _controller.sink.close();
    _controller.close();
  }

  @override
  PlotListViewModel initial() {
    if (_snapshot == null) {
      _snapshot = _viewModel(status: LoadingStatus.LOADING);
      _snapshot.refresh();
    }
    return _snapshot;
  }

  PlotListViewModel _modelFromPlots(
      StreamController controller, List<PlotEntity> plots) {
    final items = plots.map((plot) {
      final transformer =
          PlotToPlotListItemViewModel(PlotDetailProvider(plot, _plotRepo));
      return transformer.transform(from: plot);
    }).toList();
    return _viewModel(
      status: LoadingStatus.SUCCESS,
      items: items,
    );
  }

  void _update(StreamController controller) {
    _signalLoading(controller);
    _plotRepo.getFarm(null).then((articles) {
      _snapshot = _modelFromPlots(controller, articles);
      controller.sink.add(_snapshot);
    }).catchError((error) {
      _signalError(controller);
    });
  }

  void _signalLoading(StreamController controller) {
    controller.sink.add(_viewModel(status: LoadingStatus.LOADING));
  }

  void _signalError(StreamController controller) {
    controller.sink.add(_viewModel(status: LoadingStatus.ERROR));
  }

  PlotListViewModel _viewModel(
      {LoadingStatus status, List<PlotListItemViewModel> items = const []}) {
    final recommendationsProvider = RecommendationListProvider(
      title: _Strings.recommendations,
      inputScale: _Constants.inputScale,
      cropRepo: _cropRepo,
      plotRepo: _plotRepo,
    );
    return PlotListViewModel(
      title: _title,
      buttonTitle: Intl.message(_Strings.addCrop),
      loadingStatus: status,
      items: items,
      refresh: () => _update(_controller),
      recommendationsProvider: recommendationsProvider,
    );
  }
}
