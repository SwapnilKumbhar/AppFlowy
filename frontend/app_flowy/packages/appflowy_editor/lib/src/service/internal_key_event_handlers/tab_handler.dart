import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

ShortcutEventHandler tabHandler = (editorState, event) {
  // Only Supports BulletedList For Now.

  final selection = editorState.service.selectionService.currentSelection.value;
  final textNodes = editorState.service.selectionService.currentSelectedNodes
      .whereType<TextNode>();
  if (textNodes.length != 1 || selection == null || !selection.isSingle) {
    return KeyEventResult.ignored;
  }

  final textNode = textNodes.first;
  final previous = textNode.previous;
  if (textNode.subtype != BuiltInAttributeKey.bulletedList ||
      previous == null ||
      previous.subtype != BuiltInAttributeKey.bulletedList) {
    return KeyEventResult.handled;
  }

  final path = previous.path + [previous.children.length];
  final afterSelection = Selection(
    start: selection.start.copyWith(path: path),
    end: selection.end.copyWith(path: path),
  );
  TransactionBuilder(editorState)
    ..deleteNode(textNode)
    ..insertNode(path, textNode)
    ..setAfterSelection(afterSelection)
    ..commit();

  return KeyEventResult.handled;
};
