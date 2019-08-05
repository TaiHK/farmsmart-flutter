import 'package:farmsmart_flutter/model/model/EntityCollectionInterface.dart';

abstract class BasicRepositoryInterface<T> {
  Future<List<T>> getCollection(EntityCollection<T> collection);
  Future<T> getSingle(String uri);
  Stream<T> observe(String uri);
}