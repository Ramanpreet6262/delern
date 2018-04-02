import 'dart:async';

import 'package:flutter/material.dart';

import '../view_models/deck_view_model.dart';
import 'vm_view.dart';
import 'observing_animated_list.dart';

class DecksWidget extends VMViewWidget<DecksViewModel> {
  DecksWidget(Future<DecksViewModel> s) : super(s);

  @override
  _DecksWidgetState createState() => new _DecksWidgetState();
}

class _DecksWidgetState extends VMViewState<DecksViewModel, DecksWidget> {
  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return new Center(child: new CircularProgressIndicator());
    }

    return new ObservingAnimatedList(
      list: model.decks,
      itemBuilder: (context, item, animation, index) => new SizeTransition(
            child: new DeckListItem(item),
            sizeFactor: animation,
          ),
    );
  }
}

class DeckListItem extends StatelessWidget {
  final DeckViewModel model;

  DeckListItem(this.model);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: _buildDeckName(context),
              ),
              _buildNumberOfCards(),
              _buildDeckMenu(context),
            ],
          ),
        ),
        new Divider(height: 1.0),
      ],
    );
  }

  Widget _buildDeckName(BuildContext context) {
    return new Material(
      child: new InkWell(
        splashColor: Theme.of(context).splashColor,
        onTap: () {
          print(model.name);
        },
        child: new Container(
          padding: const EdgeInsets.only(
              top: 14.0, bottom: 14.0, left: 8.0, right: 8.0),
          child: new Text(
            model?.name ?? 'Loading...',
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberOfCards() {
    return new Container(
      child: new Text(model?.cardsToLearn?.toString() ?? 'N/A',
          style: new TextStyle(
            fontSize: 18.0,
          )),
    );
  }

  Widget _buildDeckMenu(BuildContext context) {
    return new Material(
      child: new InkResponse(
        splashColor: Theme.of(context).splashColor,
        radius: 15.0,
        onTap: () {},
        child: new IconButton(
            icon: new Icon(Icons.more_vert, size: 30.0), onPressed: null),
      ),
    );
  }
}