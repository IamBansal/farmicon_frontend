import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/environment_config.dart';
import '../../constants/app_assets.dart';
import '../../models/vendor_data.dart';
import '../app_theme.dart';
import 'image.dart';
import 'text.dart';

class VendorInfoCard extends StatelessWidget {
  const VendorInfoCard(this.vendorData, {Key? key}) : super(key: key);

  final VendorData vendorData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AImage(
          ENV.BASE_URL + vendorData.imageUrl,
          width: 65.r,
        ),
        SizedBox(width: 20.r),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AText(
              vendorData.name,
              style: AppTheme.vendorDataTitleStyle,
            ),
            SizedBox(height: 2.r),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(AppAssets.call, width: 12.r),
                  AText(
                    vendorData.phoneNumber.toString(),
                    style: AppTheme.readMoreStyle
                        .copyWith(color: AppTheme.greyText),
                  ),
                ],
              ),
              onTap: () {
                launchUrl(
                  Uri(
                    scheme: 'tel',
                    path: '+${vendorData.countryCode}${vendorData.phoneNumber}',
                  ),
                );
              },
            ),
            SizedBox(height: 2.r),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(AppAssets.mapPinOutline, width: 12.r),
                  SizedBox(
                    width: 180.r,
                    child: AText(
                      vendorData.address,
                      style: AppTheme.readMoreStyle
                          .copyWith(color: AppTheme.greyText),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Open maps
              },
            ),
            SizedBox(height: 14.r),
          ],
        ),
      ],
    );
  }
}
