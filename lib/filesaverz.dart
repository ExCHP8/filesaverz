/// Library of [FileSaver].
///
/// A package that makes it easy for user to browse folder and save file or pick files.
library filesaverz;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../src/widgets/body.dart';
import '../src/widgets/footer.dart';
import '../src/widgets/header.dart';
import '../src/addons/filebrowser.dart';
import '../src/state/filesaverstate.dart';

part 'package:filesaverz/src/styles/text.dart';
part 'package:filesaverz/src/styles/icon.dart';
part 'package:filesaverz/src/styles/style.dart';
part 'package:filesaverz/src/addons/extensionfunction.dart';

/// File explorer to browse and select folder path for saving file or pick files.
class FileSaver extends StatelessWidget {
  /// An optional header of [FileSaver].
  ///
  /// Default value is [header].
  final Widget? headerBuilder;

  /// An optional body of [FileSaver].
  ///
  /// Displaying list of [FileSystemEntity].
  /// Default value is [body].
  final Widget? bodyBuilder;

  /// An optional footer of [FileSaver].
  ///
  /// Displaying option to input file name and select file types.
  /// Default value is [footer].
  final Widget? footerBuilder;

  /// A custom style for [FileSaver] which containing [Color], [TextStyle], [FileSaverIcon] and [FileSaverText].
  ///
  /// ```dart
  /// FileSaverStyle style = FileSaverStyle(
  ///   primaryColor: Colors.orange,
  ///   text: FileSaverText(
  ///     popupNo: 'Nay',
  ///     popupYes: 'Sí',
  ///   ),
  ///   icons: [
  ///     FileSaverIcon.file(
  ///       icon: (path) => Image.file(File(path)),
  ///       fileType: 'jpg',
  ///     )
  ///   ]
  /// );
  /// ```
  final FileSaverStyle? style;

  /// Default name that will be saved later. If user insert a new name, than it will be replaced.
  ///
  /// ```dart
  /// String initialFileName = 'Untitled File';
  /// ```
  final String? initialFileName;

  /// An optional [Directory].
  ///
  /// Default value in android is calling a [MethodChannel] of [Environment.getExternalStorageDirectory](https://developer.android.com/reference/android/os/Environment#getExternalStorageDirectory()).
  final Directory? initialDirectory;

  /// Giving user option to choose which file type to write.
  ///
  /// And also this [fileTypes] will be used as a parameter
  /// to displayed these file types only in file explorer.
  ///
  /// ```dart
  /// List<String> fileTypes = ['txt','rtf','html'];
  /// ```
  final List<String>? fileTypes;

  /// Choose whether you want to save file as `null`, pick file as `false` or pick files as `true`.
  final bool? _multiPicker;

  /// A private constructor to set [_multiPicker].
  const FileSaver._picker({
    this.style,
    this.fileTypes,
    this.bodyBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.initialFileName,
    this.initialDirectory,
    required bool multiPicker,
  }) : _multiPicker = multiPicker;

  /// A customable [FileSaver] where you can edit the widget which will be used as file explorer.
  ///
  /// ```dart
  /// FileSaver.builder(
  ///   initialFileName: 'New File',
  ///   headerBuilder: (context, state) => /* Your widget */,
  ///   bodyBuilder: (context, state) => /* Your widget */,
  ///   footerBuilder: (context, state) => /* Your widget */,
  ///   fileTypes: const ['txt'],
  /// );
  /// ```
  FileSaver.builder({
    Key? key,
    this.style,
    this.fileTypes,
    this.initialFileName,
    this.initialDirectory,
    Widget? Function(BuildContext context, FileSaverState state)? headerBuilder,
    Widget? Function(BuildContext context, FileSaverState state)? bodyBuilder,
    Widget? Function(BuildContext context, FileSaverState state)? footerBuilder,
  })  : _multiPicker = null,
        headerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => headerBuilder == null
                ? header(context: context, state: value)
                : headerBuilder(context, value)!),
        bodyBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => bodyBuilder == null
                ? body(context: context, state: value)
                : bodyBuilder(context, value)!),
        footerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => footerBuilder == null
                ? footer(context: context, state: value)
                : footerBuilder(context, value)!),
        super(key: key);

  /// Default file explorer for [FileSaver].
  ///
  /// ```dart
  /// FileSaver(
  ///   initialFileName: 'New File',
  ///   fileTypes: const ['txt','pdf'],
  /// );
  /// ```
  FileSaver({
    Key? key,
    this.style,
    this.fileTypes,
    this.initialFileName,
    this.initialDirectory,
  })  : _multiPicker = null,
        headerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) =>
                header(context: context, state: value)),
        bodyBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) =>
                body(context: context, state: value)),
        footerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) =>
                footer(context: context, state: value)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FileSaverState(
              multiPicker: _multiPicker,
              style: style ?? FileSaverStyle(),
              fileTypes: fileTypes ?? const [],
              fileName: initialFileName ?? 'Initial Directory',
              initialDirectory: initialDirectory,
            ),
        builder: (providerContext, providerChild) {
          Provider.of<FileSaverState>(providerContext, listen: false)
              .initState();
          return providerChild!;
        },
        child: Consumer<FileSaverState>(
            builder: (_, state, child) => PopScope(
                  onPopInvoked: (val) => state.back(),
                  child: Scaffold(
                    backgroundColor: state.style.secondaryColor,
                    body: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          headerBuilder!,
                          Expanded(child: bodyBuilder!),
                        ],
                      ),
                    ),
                    bottomSheet: footerBuilder,
                  ),
                )));
  }
}
