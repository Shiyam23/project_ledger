import '../Transaction.dart';
import 'Filter.dart';

class TransactionFilter extends Filter<Transaction> {
  TransactionFilter({
    String searchText,
  }) : _searchText = (searchText ?? "").trim().isEmpty ? null : searchText;

  String _searchText;

  set searchText(String searchText) =>
      _searchText = (searchText ?? "").trim().isEmpty ? null : searchText;

  @override
  List<Transaction> filterList(List<Transaction> list) {
    return list
        .where((t) => t.name.toLowerCase().contains(_searchText.toLowerCase()));
  }
}
