import 'package:flutter/material.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart';

class TestDocumentRequestSourceWidget {
  final BuildContext context;
  final DocumentRequestSourceCallback finishCallback;

  TestDocumentRequestSourceWidget({
    required this.context,
    required this.finishCallback,
  });

  Future<void> show() {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Choose the method of providing the document',
                style: TextStyle(
                  color: Color(0xFF141719),
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  height: 24.0 / 20.0,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  finishCallback(DocumentSource.camera);
                  Navigator.of(context).pop();
                },
                child: const Text('Take a photo'),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0.0, 16, 32),
              child: ElevatedButton(
                onPressed: () {
                  finishCallback(DocumentSource.file);
                  Navigator.of(context).pop();
                },
                child: const Text('Download from gallery'),
              ),
            ),
          ],
        );
      },
    );
  }
}
