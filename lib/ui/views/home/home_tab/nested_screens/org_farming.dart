part of '../tab.dart';

class OrganicFarmingSubpage extends StatelessWidget {
  const OrganicFarmingSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeViewModel>(context, listen: true);

    if (model.orgFarmingTips.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 15.r),
      children: List<Widget>.generate(
        model.orgFarmingTips.length,
        (index) => SchemeInfoCard(model.orgFarmingTips[index]),
      ),
    );
  }
}
