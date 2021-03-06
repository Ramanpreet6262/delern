import 'package:delern_flutter/flutter/localization.dart';
import 'package:delern_flutter/flutter/styles.dart' as app_styles;
import 'package:delern_flutter/models/card_model.dart';
import 'package:delern_flutter/models/deck_model.dart';
import 'package:delern_flutter/view_models/card_create_update_bloc.dart';
import 'package:delern_flutter/views/base/screen_bloc_view.dart';
import 'package:delern_flutter/views/helpers/save_updates_dialog.dart';
import 'package:delern_flutter/views/helpers/sign_in_widget.dart';
import 'package:flutter/material.dart';

class CardCreateUpdate extends StatefulWidget {
  final CardModel card;
  final DeckModel deck;

  const CardCreateUpdate({@required this.card, @required this.deck})
      : assert(card != null),
        assert(deck != null);

  @override
  State<StatefulWidget> createState() => _CardCreateUpdateState();
}

class _CardCreateUpdateState extends State<CardCreateUpdate> {
  bool _addReversedCard = false;
  bool _isChanged = false;
  final TextEditingController _frontTextController = TextEditingController();
  final TextEditingController _backTextController = TextEditingController();
  final FocusNode _frontSideFocus = FocusNode();
  CardCreateUpdateBloc _bloc;

  @override
  void initState() {
    _bloc = CardCreateUpdateBloc(cardModel: widget.card);
    _bloc.doClearInputFields.listen((_) => _clearInputFields());
    _bloc.doShowConfirmationDialog.listen((_) => showCardSaveUpdateDialog());
    _frontTextController.text = widget.card.front;
    _backTextController.text = widget.card.back;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final locale = AppLocalizations.of(context);
    if (_bloc.locale != locale) {
      _bloc.onLocale.add(locale);
    }
    final uid = CurrentUserWidget.of(context).user.uid;
    if (_bloc.uid != uid) {
      _bloc.onUid.add(uid);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _frontSideFocus.dispose();
    _bloc?.dispose();
    super.dispose();
  }

  Future<void> showCardSaveUpdateDialog() async {
    if (_isChanged) {
      final locale = AppLocalizations.of(context);
      final continueEditingDialog = await showSaveUpdatesDialog(
          context: context,
          changesQuestion: locale.continueEditingQuestion,
          yesAnswer: locale.yes,
          noAnswer: locale.discard);
      if (continueEditingDialog) {
        return false;
      }
    }
    _bloc.onDiscardChanges.add(null);
  }

  @override
  Widget build(BuildContext context) => ScreenBlocView(
        appBar: _buildAppBar(),
        body: _buildUserInput(),
        bloc: _bloc,
      );

  AppBar _buildAppBar() => AppBar(
        title: Text(widget.deck.name),
        actions: <Widget>[
          StreamBuilder<bool>(
            initialData: false,
            stream: _bloc.isOperationEnabled,
            builder: (context, snapshot) => _bloc.isAddOperation
                ? IconButton(
                    tooltip: AppLocalizations.of(context).addCardTooltip,
                    icon: const Icon(Icons.check),
                    onPressed: snapshot.data ? _saveCard : null)
                : FlatButton(
                    child: Text(
                      AppLocalizations.of(context).save.toUpperCase(),
                      style: _isChanged && snapshot.data
                          ? const TextStyle(color: Colors.white)
                          : null,
                    ),
                    onPressed: _isChanged && snapshot.data ? _saveCard : null),
          )
        ],
      );

  void _saveCard() {
    _bloc.onSaveCard.add(null);
  }

  Widget _buildUserInput() {
    final widgetsList = <Widget>[
      // TODO(ksheremet): limit lines in TextField
      TextField(
        key: const Key('frontCardInput'),
        autofocus: true,
        focusNode: _frontSideFocus,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: _frontTextController,
        onChanged: (text) {
          setState(() {
            _bloc.onFrontSideText.add(text);
            _isChanged = true;
          });
        },
        style: app_styles.primaryText,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context).frontSideHint),
      ),
      TextField(
        key: const Key('backCardInput'),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: _backTextController,
        onChanged: (text) {
          setState(() {
            _bloc.onBackSideText.add(text);
            _isChanged = true;
          });
        },
        style: app_styles.primaryText,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).backSideHint,
        ),
      ),
    ];

    // Add reversed card widget it it is adding cards
    if (_bloc.isAddOperation) {
      // https://github.com/flutter/flutter/issues/254 suggests using
      // CheckboxListTile to have a clickable checkbox label.
      widgetsList.add(CheckboxListTile(
        title: Text(
          AppLocalizations.of(context).reversedCardLabel,
          style: app_styles.secondaryText,
        ),
        value: _addReversedCard,
        onChanged: (newValue) {
          _bloc.onAddReversedCard.add(newValue);
          setState(() {
            _addReversedCard = newValue;
          });
        },
        // Position checkbox before the text.
        controlAffinity: ListTileControlAffinity.leading,
      ));
    }

    return ListView(
      padding: const EdgeInsets.only(left: 8, right: 8),
      children: widgetsList,
    );
  }

  void _clearInputFields() {
    setState(() {
      _isChanged = false;
      _frontTextController.clear();
      _backTextController.clear();
      _bloc.onFrontSideText.add('');
      _bloc.onBackSideText.add('');
      FocusScope.of(context).requestFocus(_frontSideFocus);
    });
  }
}
