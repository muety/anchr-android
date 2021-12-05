import 'package:anchr_android/models/link.dart';
import 'package:anchr_android/models/link_collection.dart';
import 'package:anchr_android/pages/about_page.dart';
import 'package:anchr_android/pages/add_link_page.dart';
import 'package:anchr_android/pages/logs_page.dart';
import 'package:anchr_android/resources/strings.dart';
import 'package:anchr_android/state/anchr_actions.dart';
import 'package:anchr_android/state/app_state.dart';
import 'package:anchr_android/widgets/collection_drawer.dart';
import 'package:anchr_android/widgets/link_list.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionsPage extends StatefulWidget {
  static const String routeName = '/collection';
  final AppState appState;

  const CollectionsPage(this.appState, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CollectionsPageState(appState);
}

class _CollectionsPageState extends AnchrState<CollectionsPage> with AnchrActions {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  String searchVal = "";
  bool searching = false;
  bool refreshing = false;

  _CollectionsPageState(AppState appState) : super(appState);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _initData);

    _searchFocus.addListener(() => setState(() {
          searching = _searchFocus.hasFocus;
          _searchController.clear();
        }));
    _searchController.addListener(() => setState(() => searchVal = _searchController.text));
  }

  List<Link> getFilteredLinks() {
    return appState.activeCollection != null
        ? appState.activeCollection.links
            .where((Link l) => searchVal.isEmpty || l.description.toLowerCase().contains(searchVal.toLowerCase()) || l.url.toLowerCase().contains(searchVal))
            .toList(growable: false)
        : [];
  }

  List<Widget> _getAppBarActions() {
    List<Widget> widgetList = [
      PopupMenuButton(
        onSelected: (int val) => _onOptionSelected(val, context),
        itemBuilder: (ctx) => [
          PopupMenuItem(value: 0, child: const Text(Strings.labelRefreshButton)),
          PopupMenuItem(value: 1, child: const Text(Strings.labelLogsButton)),
          PopupMenuItem(value: 2, child: const Text(Strings.labelAboutButton)),
          PopupMenuItem(value: 3, child: const Text(Strings.labelLicensesButton))
        ],
      )
    ];

    if (searching) {
      widgetList.insert(
          0,
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _searchFocus.unfocus();
            },
          ));
    } else {
      widgetList.insert(
          0,
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => FocusScope.of(context).requestFocus(_searchFocus),
          ));
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    appState.currentContext = _scaffoldKey.currentContext;
    appState.currentState = _scaffoldKey.currentState;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CollectionDrawer(
        key: GlobalKey(),
        appState: appState,
        onCollectionSelect: (id) => loadCollection(id).catchError((e) {
          FLog.error(text: Strings.errorLoadCollection, exception: e);
          showSnackbar(Strings.errorLoadCollection);
        }),
        onAddCollection: (name) => addCollection(LinkCollection(name: name, links: [])).catchError((e) {
          FLog.error(text: Strings.errorAddCollection, exception: e);
          showSnackbar(Strings.errorAddCollection);
        }),
        onDeleteCollection: deleteCollection,
        onLogout: logout,
      ),
      appBar: AppBar(
        title: Builder(
          builder: (BuildContext context) {
            if (searching) {
              return TextField(
                  focusNode: _searchFocus,
                  autofocus: true,
                  showCursor: true,
                  controller: _searchController,
                  textInputAction: TextInputAction.unspecified,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.white)),
                    hintText: "Filter ...",
                    hintStyle: TextStyle(color: Colors.white),
                  ));
            } else {
              return Text(appState.title);
            }
          },
        ),
        actions: _getAppBarActions(),
      ),
      body: Center(
        child: () {
          if (appState.isLoading && !refreshing) {
            return CircularProgressIndicator();
          }
          return RefreshIndicator(
            child: LinkList(
              links: getFilteredLinks(),
              deleteLink: (link) => deleteLink(link).catchError((e) {
                FLog.error(text: Strings.errorDeleteLink, exception: e);
                showSnackbar(Strings.errorDeleteLink);
              }),
            ),
            onRefresh: () async { _refresh(); },
          );
        }(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddLinkPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _refresh() async {
    refreshing = true;
    try {
      await loadCollection(appState.activeCollection.id, force: true);
    } catch (e) {
      FLog.error(text: Strings.errorLoadCollection, exception: e);
      showSnackbar(Strings.errorLoadCollection);
    } finally {
      refreshing = false;
    }
  }

  _initData() async {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments as Map<String, String>;

    final prefs = await SharedPreferences.getInstance();
    try {
      await loadCollections();
      if (appState.collections != null && appState.collections.isNotEmpty) {
        var activeId = args != null ? args['collectionId'] : prefs.getString(Strings.keyLastActiveCollectionPref);
        var loadId = appState.collections.any((c) => c.id == activeId) ? activeId : appState.collections.first.id;
        await loadCollection(loadId);
      }
    } catch (e) {
      FLog.error(text: Strings.errorLoadCollections, exception: e);
      showSnackbar(Strings.errorLoadCollections);
    }
  }

  _onOptionSelected(int val, BuildContext ctx) {
    switch (val) {
      case 0:
        _refresh();
        break;
      case 1:
        Navigator.of(ctx).pushNamed(LogsPage.routeName);
        break;
      case 2:
        Navigator.of(ctx).pushNamed(AboutPage.routeName);
        break;
      case 3:
        showLicensePage(context: ctx);
        break;
    }
  }
}
