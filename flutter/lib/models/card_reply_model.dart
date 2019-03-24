import 'dart:core';

import 'package:built_value/built_value.dart';
import 'package:delern_flutter/models/base/model.dart';

part 'card_reply_model.g.dart';

abstract class CardReplyModel
    implements Model, Built<CardReplyModel, CardReplyModelBuilder> {
  String get uid;
  String get deckKey;
  @nullable
  String get cardKey;
  String get key;
  int get levelBefore;
  bool get reply;
  // TODO(ksheremet): initialize
  DateTime get timestamp;

  /*CardReplyModel(
      {@required this.uid, @required this.deckKey, @required this.cardKey})
      : assert(uid != null),
        assert(deckKey != null) {
    timestamp = DateTime.now();
  }*/

  factory CardReplyModel([updates(b)]) = _$CardReplyModel;

  CardReplyModel._();

  @override
  String get rootPath => 'views/$uid/$deckKey/$cardKey';

  @override
  Map<String, dynamic> toMap(bool isNew) => {
        '$rootPath/$key': {
          'levelBefore': 'L$levelBefore',
          'reply': reply ? 'Y' : 'N',
          'timestamp':
              (timestamp ?? DateTime.now()).toUtc().millisecondsSinceEpoch,
        },
      };
}
