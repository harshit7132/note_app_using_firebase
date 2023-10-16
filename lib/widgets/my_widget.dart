import 'package:flutter/material.dart';

InputDecoration myInputDecoration({
  IconData? mPrefixIcon,
  IconData? mSuffixIcon,
  required String mLabel,
  required String mHint,
  VoidCallback? onSuffixIconTap,
}) {
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.never,
    counterText: '',
    prefixIcon: mPrefixIcon != null ? Icon(mPrefixIcon) : null,
    suffixIcon: mSuffixIcon != null
        ? InkWell(onTap: onSuffixIconTap, child: Icon(mSuffixIcon))
        : null,
    labelText: mLabel,
    alignLabelWithHint: true,
    hintText: mHint,
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
  );
}
