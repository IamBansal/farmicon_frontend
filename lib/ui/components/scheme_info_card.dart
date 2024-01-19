import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/environment_config.dart';
import '../../models/scheme_info.dart';
import '../../services/app_localizations.dart';
import '../app_theme.dart';
import 'image.dart';
import 'text.dart';

class SchemeInfoCard extends StatelessWidget {
  const SchemeInfoCard(this.schemeInfo, {this.squeeze = false, Key? key})
      : super(key: key);

  final SchemeInfo schemeInfo;
  final bool squeeze;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(schemeInfo.link));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AImage(
            ENV.BASE_URL + schemeInfo.imageUrl,
            width: 65.r,
          ),
          SizedBox(width: 20.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: squeeze ? 200.r : 220.r,
                child: AText(
                  schemeInfo.title[AppLocalization.of(context).locale]!,
                  style: AppTheme.cropDoctorResultsStyle
                      .copyWith(fontWeight: FontWeight.w600),
                  forceHindi: true,
                ),
              ),
              SizedBox(height: 4.r),
              AText(
                DateFormat('EEE, d MMM').format(schemeInfo.createdAt),
                style: AppTheme.readMoreStyle
                    .copyWith(decoration: TextDecoration.none),
              ),
              SizedBox(height: 12.r),
            ],
          ),
        ],
      ),
    );
  }
}
