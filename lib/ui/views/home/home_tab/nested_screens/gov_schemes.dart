part of '../tab.dart';

class GovSchemesSubpage extends StatelessWidget {
  const GovSchemesSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeViewModel>(context, listen: true);

    if (model.govSchemes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 15.r),
      children: List<Widget>.generate(
        model.govSchemes.length,
        (index) => SchemeInfoCard(model.govSchemes[index]),
      ),
    );
  }
}
