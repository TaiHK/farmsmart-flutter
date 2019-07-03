import 'package:farmsmart_flutter/data/model/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/loading_status.dart';
import 'package:farmsmart_flutter/ui/discover/viewModel/ArticleListItemViewModel.dart';

typedef GetList<T> = Future<List<T>> Function();

class ArticleDetailViewModel {
  final LoadingStatus loadingStatus;
  final String title;
  final String subtitle;
  final ImageURLProvider image;
  final String body;
  Function shareAction;
  GetList<ArticleListItemViewModel> getRelated;
  /*
          String deepLink = await buildArticleDeeplink(articleID);
          var response = await FlutterShareMe().shareToSystem(msg: Strings.shareArticleText + deepLink);
  */

  ArticleDetailViewModel(this.loadingStatus, this.title, this.subtitle,
      this.image, this.body, this.shareAction);
}