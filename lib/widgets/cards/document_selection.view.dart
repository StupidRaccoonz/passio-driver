import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_sizes/file_sizes.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/services/toast.service.dart';
import 'package:fuodz/utils/permission_utils.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/html_text_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DocumentSelectionView extends StatefulWidget {
  DocumentSelectionView({
    Key? key,
    this.title = "",
    this.instruction = "",
    this.max = 2,
    required this.onSelected,
    required this.onSelfieSelected,
  }) : super(key: key);

  final int max;
  final String title;
  final String instruction;
  final Function(List<File> documents) onSelected;
  final Function(XFile selfie) onSelfieSelected;
  @override
  State<DocumentSelectionView> createState() => _DocumentSelectionViewState();
}

class _DocumentSelectionViewState extends State<DocumentSelectionView> {
  //
  List<File> selectedFiles = [];
  List<PlatformFile> selectedPlatformFiles = [];

  XFile? selfie;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "${widget.title}".text.xl.semiBold.make(),
        if (widget.instruction.isNotEmpty) HtmlTextView(widget.instruction),

        //
        CustomGridView(
          dataSet: selectedPlatformFiles,
          childAspectRatio: 1.5,
          noScrollPhysics: true,
          padding: EdgeInsets.zero,
          itemBuilder: (ctx, index) {
            final platformFile = selectedPlatformFiles[index];
            return Stack(
              children: [
                VStack(
                  [
                    "${platformFile.name}"
                        .text
                        .medium
                        .sm
                        .maxLines(2)
                        .ellipsis
                        .make(),
                    "${FileSize.getSize(platformFile.size)}".text.sm.make(),
                    "${platformFile.extension}".text.xs.italic.make(),
                  ],
                )
                    .p8()
                    .box
                    .roundedSM
                    .border(color: Colors.grey.shade400)
                    .make()
                    .p8()
                    .wFull(context),

                //remove button top corner
                Positioned(
                  top: 1,
                  right: !Utils.isArabic ? 0 : null,
                  left: Utils.isArabic ? 0 : null,
                  child: VxBox(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ).red500.roundedFull.make().onTap(
                    () {
                      selectedFiles.removeAt(index);
                      selectedPlatformFiles.removeAt(index);
                      widget.onSelected(selectedFiles);
                      setState(() {
                        selectedFiles = selectedFiles;
                        selectedPlatformFiles = selectedPlatformFiles;
                      });
                    },
                  ),
                ),
              ],
            );
          },
          emptyWidget: "Nothing selected. Tap to select"
              .tr()
              .text
              .make()
              .centered()
              .p20(),
        )
            .box
            .border(color: Colors.grey.shade400)
            .roundedSM
            .outerShadowSm
            .make()
            .onInkTap(openFileSelector)
            .py12(),

        selfie != null
            ? Stack(
                children: [
                  Row(
                    children: [
                      if (selfie != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(selfie!.path),
                            fit: BoxFit.cover,
                            height: 50,
                          ),
                        ),
                      Expanded(
                        child: VStack(
                          [
                            "${selfie!.name}"
                                .text
                                .medium
                                .sm
                                .maxLines(2)
                                .ellipsis
                                .make(),

                            // "${selfie!.}".text.sm.make(),
                            // "${selfie!}".text.xs.italic.make(),
                          ],
                        )
                            .p8()
                            .box
                            .roundedSM
                            .border(color: Colors.grey.shade400)
                            .make()
                            .p8()
                            .wFull(context),
                      ),
                    ],
                  ).onInkTap(openCameraFileSelector),

                  //remove button top corner
                  // Positioned(
                  //   top: 1,
                  //   right: !Utils.isArabic ? 0 : null,
                  //   left: Utils.isArabic ? 0 : null,
                  //   child: VxBox(
                  //     child: Icon(
                  //       Icons.close,
                  //       color: Colors.white,
                  //     ),
                  //   ).red500.roundedFull.make().onTap(
                  //     () {
                  //       selfie = nukkl
                  //       widget.onSelected(selectedFiles);
                  //       setState(() {
                  //         selectedFiles = selectedFiles;
                  //         selectedPlatformFiles = selectedPlatformFiles;
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera),
                  (selfie != null ? selfie!.name : "Upload live selfie")
                      .tr()
                      .text
                      .make()
                      .centered()
                      .p20(),
                ],
              )
                .box
                .border(color: Colors.grey.shade400)
                .roundedSM
                .outerShadowSm
                .make()
                .onInkTap(openCameraFileSelector)
                .py12(),

        // .box
        // .border(color: Colors.grey.shade400)
        // .roundedSM
        // .outerShadowSm
        // .make()
        // .onInkTap(openCameraFileSelector)
        // .py12(),
      ],
    );
  }

  openFileSelector() async {
    //check for permission first
    final permission =
        await PermissionUtils.handleFilesPermissionRequest(context);

    if (!permission) {
      return;
    }
    //End of permission check

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      final mFiles = result.paths.map((path) => File(path!)).toList();
      final mPlatformFiles = result.files;

      //
      selectedFiles.addAll(mFiles);
      selectedPlatformFiles.addAll(mPlatformFiles);

      //
      if (selectedFiles.length > widget.max) {
        selectedFiles = selectedFiles.sublist(0, widget.max);
        selectedPlatformFiles = selectedPlatformFiles.sublist(0, widget.max);
      }

      //
      widget.onSelected(selectedFiles);
      setState(() {
        selectedFiles = selectedFiles;
        selectedPlatformFiles = selectedPlatformFiles;
      });
    } else {
      ToastService.toastError("No Document selected".tr());
    }
  }

  openCameraFileSelector() async {
    //check for permission first
    final permission =
        await PermissionUtils.handleCameraPermissionRequest(context);

    debugPrint(permission.toString());
    if (!permission) {
      return;
    }
    //End of permission check

    XFile? result = await ImagePicker().pickImage(source: ImageSource.camera);

    if (result != null) {
      widget.onSelfieSelected(result);
      setState(() {
        selfie = result;
      });
    } else {
      ToastService.toastError("No Image Captured".tr());
    }
  }
}
