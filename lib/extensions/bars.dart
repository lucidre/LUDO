import 'package:ludo/common_libs.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

extension DeviceBar on BuildContext {
  showInformationSnackBar(String desciption) {
    showTopSnackBar(
        Overlay.of(this),
        CustomSnackBar.info(
            message: desciption,
            backgroundColor: Colors.blue[700]!,
            iconRotationAngle: 0,
            iconPositionTop: -10,
            iconPositionLeft: -10,
            icon: Icon(Icons.info_outline_rounded,
                color: white.withOpacity(.15), size: 120),
            messagePadding: const EdgeInsets.all(space16),
            textAlign: TextAlign.start,
            textStyle:
                font500S14.copyWith(color: white, fontWeight: FontWeight.w600)),
        snackBarPosition: SnackBarPosition.top);
  }

  void showSuccessSnackBar(String message) {
    showTopSnackBar(
        Overlay.of(this),
        CustomSnackBar.success(
            message: message,
            backgroundColor: Colors.green[700]!,
            messagePadding: const EdgeInsets.all(space16),
            textAlign: TextAlign.start,
            textStyle:
                font500S14.copyWith(color: white, fontWeight: FontWeight.w600)),
        snackBarPosition: SnackBarPosition.top);
  }

  void showErrorSnackBar(String message) {
    showTopSnackBar(
        Overlay.of(this),
        CustomSnackBar.error(
            message: message,
            backgroundColor: Colors.red[700]!,
            messagePadding: const EdgeInsets.all(space16),
            textAlign: TextAlign.start,
            textStyle:
                font500S14.copyWith(color: white, fontWeight: FontWeight.w600)),
        snackBarPosition: SnackBarPosition.top);
  }
}
