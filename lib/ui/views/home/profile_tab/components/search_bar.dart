part of '../tab.dart';

Widget buildSearchBar(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  return TextFormField(
    onChanged: model.shortListCrops,
    decoration: InputDecoration(
      prefixIcon: Icon(Icons.search, size: 14.r),
      hintText: AppLocalization.of(context).getTranslatedValue('searchCrops').toString(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
    ),
  );
}
