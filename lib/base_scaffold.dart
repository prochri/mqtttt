import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';

class BaseScaffoldPage {
  final String title;
  final IconData icon;
  final Widget body;
  BaseScaffoldPage(this.title, this.icon, this.body);
}

class BaseScaffold extends StatefulWidget {
  final List<BaseScaffoldPage> pages;
  final List<AdaptiveScaffoldDestination> _destinations;
  final int startIndex;

  get destinations {
    return _destinations;
  }

  BaseScaffold({Key? key, required this.pages, this.startIndex = 0})
      : _destinations = pages
            .map((p) =>
                AdaptiveScaffoldDestination(title: p.title, icon: p.icon))
            .toList(),
        super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState(startIndex);
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int _currentIndex;
  bool _hasDrawer = false;

  _BaseScaffoldState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    var selectedPage = widget.pages[_currentIndex];
    return AdaptiveNavigationScaffold(
      appBar: AppBar(title: Text(selectedPage.title)),
      body: selectedPage.body,
      destinations: widget.destinations,
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (_hasDrawer) {
          Navigator.pop(context);
        }
      },
      navigationTypeResolver: (context) {
        _hasDrawer = false;
        if (MediaQuery.of(context).size.width > 600) {
          return NavigationType.rail;
        } else {
          _hasDrawer = true;
          return NavigationType.drawer;
        }
      },
    );
  }
}
