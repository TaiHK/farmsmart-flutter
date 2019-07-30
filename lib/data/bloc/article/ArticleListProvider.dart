import 'dart:async';

import 'package:farmsmart_flutter/data/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/data/bloc/article/ArticleDetailTransformer.dart';
import 'package:farmsmart_flutter/data/bloc/article/ArticleListItemViewModelTransformer.dart';
import 'package:farmsmart_flutter/data/model/article_entity.dart';
import 'package:farmsmart_flutter/data/repositories/article/ArticleRepositoryInterface.dart';
import 'package:farmsmart_flutter/model/loading_status.dart';
import 'package:farmsmart_flutter/ui/discover/viewModel/ArticleListItemViewModel.dart';
import 'package:farmsmart_flutter/ui/discover/viewModel/ArticleListViewModel.dart';


/*
       [Model]    ->               [Bloc]             -> [View]  
   [repo , model] -> [ViewModelProvider, Transformer] -> [viewModel, widget]
*/

class ArticleListProvider implements ViewModelProvider<ArticleListViewModel> {
  final ArticleRepositoryInterface _repo;
  final ArticleCollectionGroup _group;
  final String _title;
  final String _relatedTitle;
  final String _contentLinkTitle;
  ArticleListViewModel _snapshot;
  ArticleListProvider(
      {String title, String relatedTitle, String contentLinkTitle, ArticleRepositoryInterface repository,
      ArticleCollectionGroup group = ArticleCollectionGroup.all})
      : this._title = title, 
        this._relatedTitle = relatedTitle,
        this._contentLinkTitle = contentLinkTitle,
        this._repo = repository,
        this._group = group;

  final StreamController<ArticleListViewModel> _controller =
      StreamController<ArticleListViewModel>.broadcast();

  ArticleListViewModel _modelFromArticles(
      StreamController controller, List<ArticleEntity> articles) {
    final transformer = ArticleListItemViewModelTransformer.buildWithDetail(ArticleDetailViewModelTransformer(relatedTitle: _relatedTitle, contentLinkTitle: _contentLinkTitle));
    final items = articles.map((article) {
      return transformer.transform(from: article);
    }).toList();
    return _viewModel(status: LoadingStatus.SUCCESS, items: items);
  }

  void _update(StreamController controller) {
    _repo.get(group: _group).then((articles) {
      _snapshot = _modelFromArticles(controller, articles);
      controller.sink.add(_snapshot);
    });
  }

  ArticleListViewModel _viewModel({ LoadingStatus status , List<ArticleListItemViewModel> items }) {
    return ArticleListViewModel(
        title: _title,
        status: status,
        articleListItemViewModels: items,
        refresh: () => _update(_controller));
  }

  void dispose() {
    _controller.sink.close();
    _controller.close();
  }

  @override
  ArticleListViewModel initial() {
    if (_snapshot == null) {
      _snapshot = _viewModel(status: LoadingStatus.LOADING, items: []);
      _snapshot.refresh();
    }
    return _snapshot;
  }

  @override
  StreamController<ArticleListViewModel> observe() {
     return _controller;
  }

  @override
  ArticleListViewModel snapshot() {
    return _snapshot;
  }
}
