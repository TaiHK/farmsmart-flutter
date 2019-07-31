import 'package:farmsmart_flutter/data/model/ImageEntity.dart';
import 'package:farmsmart_flutter/data/model/ImageURLProvider.dart';
import 'package:farmsmart_flutter/model/enums.dart';
import 'EntityCollectionInterface.dart';

class ArticleEntity {
  String id;
  String content;
  EntityCollection<ImageEntity> images;
  EntityCollection<ArticleEntity> related;
  Status status;
  String summary;
  String title;
  DateTime published;
  String externalLink;

  ArticleEntity(
      {this.id,
      this.content,
      this.status,
      this.summary,
      this.title,
      this.published,
      this.externalLink});
}


// LH this is to make getting the main article image easier
// if we want to get more images from an article, we can get the image entities
// and use their ImageEntityURLProvider 
class ArticleImageProvider implements ImageURLProvider {
  final ArticleEntity _article;
  ArticleImageProvider(ArticleEntity article) : _article = article;
  @override
  Future<String> urlToFit({double width, double height}) {
    if ( _article.images == null)
    {
      return Future.value(null);
    }
    return _article.images.getEntities(limit: 1).then((imageEntities) {
      // NB: we assume the first image is the hero
      return imageEntities.first.urlProvider.urlToFit(width: width,height: height);
    });
  }
}
