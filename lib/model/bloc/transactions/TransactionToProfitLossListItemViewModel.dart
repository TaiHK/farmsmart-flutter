import 'package:farmsmart_flutter/model/bloc/transactions/TransactionToRecordTransactionViewModel.dart';
import 'package:farmsmart_flutter/model/model/TransactionEntity.dart';
import 'package:farmsmart_flutter/ui/common/DogTagStyles.dart';
import 'package:farmsmart_flutter/ui/profitloss/ProfitLossListItem.dart';
import 'package:intl/intl.dart';
import '../Transformer.dart';


class _Strings {
  static const costPrefix = "-";
  static const salePrefix = "+";
  static const divider = " - ";
  static const descriptionPlaceholder = "No description";
}

class _Constants {
  static const transactionDateFormat = "d MMMM";
}

class TransactionToProfitLossListItemViewModel
    implements
        ObjectTransformer<TransactionEntity, ProfitLossListItemViewModel> {
  final TransactionToRecordTransactionViewModel _detailTransformer;
  final _dateFormatter = DateFormat(_Constants.transactionDateFormat);

  TransactionToProfitLossListItemViewModel(this._detailTransformer);

  @override
  ProfitLossListItemViewModel transform({TransactionEntity from}) {
    return ProfitLossListItemViewModel(
      title: _title(from) ,
      subtitle: _subtitle(from),
      detail: _detail(from),
      style: from.amount.isSale()
          ? DogTagStyles.positiveStyle()
          : DogTagStyles.negativeStyle(),
      detailViewModel: _detailTransformer.transform(from: from),
    );
  }

  String _title(TransactionEntity from) {
    final dateString = (from.timestamp == null)
        ? ""
        : _dateFormatter.format(from.timestamp);
    return dateString + _Strings.divider + from.tag;
  }

  String _subtitle(TransactionEntity from) {
    return from.description ?? Intl.message(_Strings.descriptionPlaceholder);
  }

  String _detail(TransactionEntity from) {
    final amountString = from.amount.toString();
    return from.amount.isCost() ? _Strings.costPrefix + amountString : _Strings.salePrefix + amountString;
  }
}