part of '../tab.dart';

class SelectCropsSubpage extends StatelessWidget {
  const SelectCropsSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeViewModel>(context, listen: true);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ListView(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 16.r),
          children: <Widget>[
            buildSearchBar(context),
            SizedBox(height: 24.r),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8.r),
              type: MaterialType.card,
              color: AppTheme.dirtyWhite,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: (model.cropsToShow == null)
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      )
                    : ((model.cropsToShow!.isEmpty)
                        ? Center(
                            child: AText(AppLocalization.of(context).getTranslatedValue('noCropPricesAvailable').toString()))
                        : GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            childAspectRatio: 1.5.sw / 1.sh,
                            children: List<Widget>.generate(
                              model.cropsToShow!.length,
                              (index) => buildCropIcon(
                                  context, model.cropsToShow![index]),
                            ),
                          )),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16.r,
          child: buildUpdateCropsButton(context),
        ),
      ],
    );
  }
}
