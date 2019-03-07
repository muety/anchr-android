import 'package:anchr_android/models/link_collection.dart';

class AppState {
  bool isLoading;
  String user;
  List<LinkCollection> collections;
  LinkCollection activeCollection;

  AppState({this.collections = const [], this.activeCollection, this.isLoading = false, this.user});

  factory AppState.loading() => AppState(isLoading: true);

  String get title => this.activeCollection?.name ?? 'Collections';

  bool get hasData => this.collections != null && this.collections.length > 0 && this.activeCollection != null;

  AppState copyWith({List<LinkCollection> collections, LinkCollection activeCollection, String user, bool isLoading}) {
    return AppState(
      collections: collections ?? this.collections,
      activeCollection: activeCollection ?? this.activeCollection,
      user: user ?? this.user,
      isLoading: isLoading ?? (collections == null && activeCollection == null),
    );
  }
}
