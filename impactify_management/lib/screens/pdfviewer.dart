import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:impactify_management/widgets/custom_loading.dart';

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl({super.key});

  
  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SSM PDF View'),
        backgroundColor: Colors.transparent,
      ),
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (double progress) => CustomLoading(text: '$progress %'),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}