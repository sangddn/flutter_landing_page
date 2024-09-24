import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';

extension StringUtils on String {
  String splitCamelCase() {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match match) => ' ${match.group(0)}',
    ).trim();
  }

  String toSnakeCase() => replaceAllMapped(
        RegExp(r'([A-Z])'),
        (Match match) => '_${match.group(0)}',
      ).toLowerCase();

  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String uncapitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toLowerCase()}${substring(1)}';
  }

  String capitalizeEachWord() {
    return split(' ').map((e) => e.capitalize()).join(' ');
  }

  String onlyLetters({bool withSpaces = true, bool withCommonSymbols = true}) {
    final commonSymbols =
        withCommonSymbols ? r'!@#%^&*()_+-=[]{}|;:,.<>?/' : '';
    final space = withSpaces ? r'\s' : '';
    return replaceAll(RegExp('[^a-zA-Z$commonSymbols$space]'), '');
  }

  String onlyDigits({bool withSpaces = true, bool withCommonSymbols = true}) {
    final commonSymbols =
        withCommonSymbols ? r'!@#%^&*()_+-=[]{}|;:,.<>?/' : '';
    final space = withSpaces ? r'\s' : '';
    return replaceAll(RegExp('[^0-9$commonSymbols$space]'), '');
  }

  String onlyAlphaNumeric({
    bool withSpaces = true,
    bool withCommonSymbols = true,
  }) {
    final commonSymbols =
        withCommonSymbols ? r'!@#%^&*()_+-=[]{}|;:,.<>?/' : '';
    final space = withSpaces ? r'\s' : '';
    return replaceAll(RegExp('[^a-zA-Z0-9$commonSymbols$space]'), '');
  }

  int get xLength => characters.length;

  String sanitizeMarkdown() {
    // Convert Markdown to HTML
    final String htmlText = markdownToHtml(this, encodeHtml: false);

    // Strip HTML tags to get plaintext
    // This is a simplistic approach and might not handle all HTML entities correctly.
    final String plainText =
        htmlText.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

    return plainText.onlyAlphaNumeric();
  }

  bool get hasOnlyDigits =>
      onlyDigits(withSpaces: false, withCommonSymbols: false) == this;
  bool get hasOnlyLetters =>
      onlyLetters(withSpaces: false, withCommonSymbols: false) == this;
  bool get hasOnlyAlphaNumeric =>
      onlyAlphaNumeric(withSpaces: false, withCommonSymbols: false) == this;
}

extension Joins on Iterable<String> {
  String joinExceptLast([String separator = '', String lastSeparator = '']) {
    if (length <= 1) {
      return join(separator);
    }
    return '${take(length - 1).join(separator)}$lastSeparator$last';
  }
}
