part of '../tab.dart';

Widget buildUserCard(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  return Align(
    alignment: Alignment.center,
    child: Material(
      elevation: 5,
      type: MaterialType.card,
      borderRadius: BorderRadius.circular(8.r),
      color: AppTheme.dirtyWhite,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.r, 18.r, 16.r, 18.r),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: AImage(
                model.user.imageUrl,
                width: 64.r,
              ),
            ),
            SizedBox(width: 20.r),
            SizedBox(
              width: 210.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AText(
                    model.user.name,
                    style: AppTheme.vendorDataTitleStyle,
                  ),
                  if (model.user.phoneNumber != null)
                    AText(
                      model.user.phoneNumber!,
                      style: AppTheme.otpInstructionsStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 18 / 12,
                        color: AppTheme.text,
                      ),
                    ),
                  if (model.user.email != null)
                    AText(
                      model.user.email!,
                      style: AppTheme.otpInstructionsStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 18 / 12,
                        color: AppTheme.text,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
