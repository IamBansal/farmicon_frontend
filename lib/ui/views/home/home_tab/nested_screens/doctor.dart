part of '../tab.dart';

class DoctorSubpage extends StatelessWidget {
  DoctorSubpage({required this.model, Key? key}) : super(key: key) {
    model.fetchDoctorResultsCenters();
  }

  final HomeViewModel model;
  final _plantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget buildHeader(HomeViewModel model) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 20.r),
        child: Material(
          elevation: 5,
          type: MaterialType.card,
          borderRadius: BorderRadius.circular(8.r),
          color: AppTheme.dirtyWhite,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 12.r, 0, 8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          AppAssets.takeAPhoto,
                          width: 64.r,
                        ),
                        AText(
                          AppLocalization.of(context).getTranslatedValue('takeAPhoto').toString(),
                          style: AppTheme.otpInstructionsStyle
                              .copyWith(color: AppTheme.text),
                        ),
                      ],
                    ),
                    SizedBox(width: 30.r),
                    Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          AppAssets.seeDiagnosis,
                          width: 64.r,
                        ),
                        AText(
                          AppLocalization.of(context).getTranslatedValue('seeDiagnosis').toString(),
                          style: AppTheme.otpInstructionsStyle
                              .copyWith(color: AppTheme.text),
                        ),
                      ],
                    ),
                    SizedBox(width: 30.r),
                    Column(
                      children: <Widget>[
                        SvgPicture.asset(
                          AppAssets.getSolutions,
                          width: 64.r,
                        ),
                        AText(
                          AppLocalization.of(context).getTranslatedValue('getSolutions').toString(),
                          style: AppTheme.otpInstructionsStyle
                              .copyWith(color: AppTheme.text),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.r,),
                SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              // height: 50,
              child: TextField(
                controller: _plantController,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFDFDFDF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                    const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                    const BorderSide(color: Colors.black),
                  ),
                  hintText: 'Plant name',
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  hintMaxLines: 1,
                  labelText: 'Plant name',
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(color: Colors.black),
                maxLines: 1,
                minLines: 1,
              ),
            ),
                SizedBox(height: 20.r),
                ElevatedButton(
                  onPressed: () async {
                    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);

                    if (photo == null) {
                      Get.rawSnackbar(message: 'Photo not taken');
                    } else {
                      try {
                        if(_plantController.text.isNotEmpty) {
                          _plantController.text = '';
                          Get.rawSnackbar(message: 'Photo sent for analysis');
                          await model.sendPhotoForAnalysis(photo.path, 'apple');
                        } else{
                          Get.rawSnackbar(message: 'Enter plant type as well');
                        }
                      } catch (exception) {
                        Get.rawSnackbar(message: 'Unable to send photo for analysis');
                      }
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r))),
                    textStyle: const MaterialStatePropertyAll(AppTheme.h3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgPicture.asset(
                        AppAssets.cameraWhite,
                        width: 24.r,
                      ),
                      AText(AppLocalization.of(context).getTranslatedValue('takePicOfCrop').toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildResultsCard(CropAnalysis result) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.r),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(8.r),
          type: MaterialType.card,
          color: AppTheme.dirtyWhite,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.r, 20.r, 16.r, 12.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AImage(
                  ENV.BASE_URL + result.image,
                  width: 65.r,
                ),
                SizedBox(width: 20.r),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AText(
                          result.disease,
                          style: AppTheme.vendorDataTitleStyle,
                        ),
                        SizedBox(width: 10.r),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: (result.status == ResultStatus.complete)
                        //         ? const Color(0xFF34A853)
                        //         : AppTheme.tertiary,
                        //     borderRadius: BorderRadius.circular(22.r),
                        //   ),
                        //   height: 16.r,
                        //   width: (result.status == ResultStatus.complete)
                        //       ? 48.r
                        //       : 42.r,
                        //   alignment: Alignment.center,
                        //   child: Text(
                        //     enumToString(result.status, context),
                        //     style: AppTheme.cropDoctorResultStateStyle,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      width: 200.r,
                      child: AText(
                        result.treatment,
                        style: AppTheme.cropDoctorResultsStyle,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    AText(
                      result.plant_name.toString(),
                      // DateFormat('h:m a, d MMM').format(result.dateTime),
                      style: AppTheme.readMoreStyle
                          .copyWith(decoration: TextDecoration.none),
                    ),
                  ],
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              25.r,
              12.r,
              32.r,
              15.r,
            ),
            child: AText(
              AppLocalization.of(context).getTranslatedValue('recentResults').toString(),
              style: AppTheme.h3.copyWith(
                color: AppTheme.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 15.r),
          child: (model.doctorResults.isNotEmpty)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    model.doctorResults.length,
                    (index) => buildResultsCard(model.doctorResults[index]),
                  ),
                )
              : SizedBox(
                  width: 100.r,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primary,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
