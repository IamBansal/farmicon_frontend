part of '../tab.dart';

class PriceSubpage extends StatelessWidget {
  const PriceSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildHeader(HomeViewModel model) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
        width: 1.sw,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: TextFormField(
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
                  isDense: true,
                ),
                maxLines: 1,
                initialValue: '',
                onChanged: model.filterCrops,
              ),
            ),
            SizedBox(width: 5.r),
            SizedBox(
              width: 130.r,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined, size: 14.r),
                  hintText: AppLocalization.of(context).getTranslatedValue('pincode').toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                ),
                maxLines: 1,
                onChanged: (p) {
                  if (p.length == 6) {
                    model.fetchCropPrices(pincode: p);
                  } else if (p.isEmpty) {
                    model.fetchCropPrices();
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    Widget buildCropPriceCard(HomeViewModel model, CropPrice crop) {
      return Padding(
        padding: EdgeInsets.only(top: 16.r),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(8.r),
          type: MaterialType.card,
          color: AppTheme.dirtyWhite,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.r, 16.r, 16.r, 10.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipOval(
                  child: (model.imageUrlMap.containsKey(crop.name['en']!))
                      ? AImage(
                          model.imageUrlMap[crop.name['en']!]!,
                          width: 48.r,
                        )
                      : Container(
                          color: AppTheme.lightPrimary,
                          width: 48.r,
                          height: 48.r,
                          padding: EdgeInsets.all(10.r),
                          child: SvgPicture.asset(AppAssets.leaf, width: 48.r),
                        ),
                ),
                SizedBox(width: 12.r),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AText(
                      crop.name[AppLocalization.of(context).locale]!,
                      style: AppTheme.vendorDataTitleStyle
                          .copyWith(color: AppTheme.text),
                    ),
                    SizedBox(height: 8.r),
                    AText(
                      AppLocalization.of(context).getTranslatedValue('avgPrice').toString(),
                      style: AppTheme.cropDoctorResultStateStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppTheme.grey100,
                      ),
                    ),
                    AText(
                      (crop.price == 0)
                          ? 'Price not available'
                          : 'Rs ${crop.price.round()}/${crop.unit[AppLocalization.of(context).locale]}',
                      style: AppTheme.cropPriceStyle,
                    ),
                    SizedBox(height: 8.r),
                    AText(
                      '${AppLocalization.of(context).getTranslatedValue('variety').toString()}: ${crop.variety[AppLocalization.of(context).locale]}',
                      style: AppTheme.cropDoctorResultsStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => model.toggleCrop(
                    crop.name['en']!,
                    crop.variety['en']!,
                  ),
                  child: SvgPicture.asset(
                    (crop.isBookmarked)
                        ? AppAssets.bookmarkFilled
                        : AppAssets.bookmarkEmpty,
                    width: 24.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final model = Provider.of<HomeViewModel>(context, listen: true);

    return ListView(
      children: <Widget>[
        buildHeader(model),
        Padding(
            padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 16.r),
            child: (model.allCrops == null)
                ? SizedBox(
                    width: 100.r,
                    child: const CircularProgressIndicator(
                        color: AppTheme.primary),
                  )
                : ((model.pricesToShow!.isEmpty)
                    ? Center(child: AText(AppLocalization.of(context).getTranslatedValue('noCropPricesAvailable').toString()))
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(
                          model.pricesToShow!.length,
                          (index) => buildCropPriceCard(
                              model, model.pricesToShow![index]),
                        ),
                      ))),
      ],
    );
  }
}
