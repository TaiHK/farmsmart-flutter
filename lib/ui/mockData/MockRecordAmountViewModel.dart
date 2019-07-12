import 'package:farmsmart_flutter/model/loading_status.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmount.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmountHeader.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmountListItem.dart';

class MockRecordAmountViewModel {
  var cropIsfilled = false;
  var amountIsFilled = false;

  static RecordAmountViewModel buildSale() {
    List<RecordAmountListItemViewModel> list = [];

    for (var i = 0; i < 3; i++) {
      list.add(MockRecordAmountListItemViewModel.build(i));
    }

    return RecordAmountViewModel (
      loadingStatus: LoadingStatus.SUCCESS,
      actions: list,
      buttonTitle: _mockButtonTitle[1],
      onTap: null,
    );

  }

  static RecordAmountViewModel buildCost() {
    List<RecordAmountListItemViewModel> list = [];

    for (var i = 0; i < 3; i++) {
      list.add(MockRecordAmountListItemViewModel.build(i));
    }

    return RecordAmountViewModel (
      loadingStatus: LoadingStatus.SUCCESS,
      actions: list,
      buttonTitle: _mockButtonTitle[0],
      onTap: null,
    );
  }

}

class MockRecordAmountListItemViewModel {
  static RecordAmountListItemViewModel build(int index) {
    return RecordAmountListItemViewModel(
      icon: _mockItemIcon[index],
      title: _mockItemTitle[index],
      hint: _mockItemHint[index],
      arrow: _mockArrowIcon[index],
      selectedDate: _mockSelectedDate [index],
      listOfCrops: _mockListOfCrops[index],
      listener: null,
    );
  }
}


List _mockSelectedDate = [DateTime.now(), null, null];

List _mockButtonTitle = ["Record Cost", "Record Sale"];

List _mockItemTitle = ["Date", "Crop", null];
List _mockItemIcon = [
  "assets/icons/detail_icon_date.png",
  "assets/icons/detail_icon_best_soil.png",
  "assets/icons/detail_icon_description.png"
];
List _mockItemHint = ["Today", "Select...", "Description (optional)..."];
List _mockArrowIcon = [
  "assets/icons/chevron.png", "assets/icons/chevron.png", null];
List _mockListOfCrops = [null, [
  "Okra",
  "Tomatoes",
  "Potatoes",
  "Cowpeas",
  "Sweetcorn",
  "Cucumber",
  "Beetroot"
], null
];



