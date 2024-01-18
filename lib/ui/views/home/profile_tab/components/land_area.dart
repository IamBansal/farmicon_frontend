part of '../tab.dart';

List<Widget> buildLandAreaSection(BuildContext context) {
  final model = Provider.of<HomeViewModel>(context, listen: true);

  DropdownMenuItem<String> getAreaOption(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: AText(value),
    );
  }

  return <Widget>[
    Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
        8.r,
        18.r,
        8.r,
        10.r,
      ),
      child: AText(
        AppLocalization.of(context).getTranslatedValue('landArea').toString(),
        style: AppTheme.h3.copyWith(
          color: AppTheme.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Align(
      alignment: Alignment.center,
      child: Material(
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(8.r),
        elevation: 5,
        color: AppTheme.dirtyWhite,
        child: Container(
          padding: EdgeInsets.all(8.r),
          width: 350.r,
          height: 50.r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextInput(
                hint: AppLocalization.of(context).getTranslatedValue('area').toString(),
                onChanged: (_) => model.updateArea(),
                width: 212.r,
                controller: model.areaQuantity,
                keyboard: const TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(
                width: 100.r,
                child: DropdownButtonFormField(
                  style:
                      AppTheme.googleButtonStyle.copyWith(color: AppTheme.text),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: AppTheme.primary),
                      gapPadding: 0,
                    ),
                    contentPadding: EdgeInsets.only(left: 10.r),
                  ),
                  onChanged: model.updateArea,
                  value: model.user.areaUnit,
                  items: <DropdownMenuItem<String>>[
                    getAreaOption('acre'),
                    getAreaOption('hectare'),
                    getAreaOption('km²'),
                    getAreaOption('m²'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}
