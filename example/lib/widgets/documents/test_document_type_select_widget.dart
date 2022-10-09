import 'package:flutter/material.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart';

class TestDocumentTypeSelectWidget extends StatefulWidget {
  final List<DocumentCountry> countryList;
  final DocumentSetUpScreenBuilderCallback finishCallback;
  final BuildContext baseContext;

  const TestDocumentTypeSelectWidget({
    required this.countryList,
    required this.finishCallback,
    required this.baseContext,
  });

  @override
  _TestDocumentTypeSelectWidgetState createState() => _TestDocumentTypeSelectWidgetState();
}

class _TestDocumentTypeSelectWidgetState extends State<TestDocumentTypeSelectWidget> {
  //final GetPredefinedCountryUseCase _getPredefinedCountryUseCase = getIt<GetPredefinedCountryUseCase>();
  String predefinedCountryName = '';
  late BuildContext baseContext;
  late int documentsTypeQty;
  List<bool> radioButtonStatusList = [];
  late DocumentDocumentType currentDocumentType;

  @override
  void initState() {
    baseContext = widget.baseContext;
    documentsTypeQty = widget.countryList[0].documents.length;
    currentDocumentType = widget.countryList[0].documents[0];
    for (int i = 0; i < documentsTypeQty; i++) {
      radioButtonStatusList.add(i == 0 && true);
    }
    predefinedCountryName = widget.countryList[0].name;
    super.initState();
  }

  @override
  Widget build(BuildContext baseContext) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: const Text(
                'Get ready to take a photo of the document',
                style: TextStyle(
                  color: Color(0xFF141719),
                  fontWeight: FontWeight.w700,
                  fontSize: 28.0,
                  height: 32.0 / 28.0,
                ),
                maxLines: 3,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: const Text(
                'To be verified, you will need a document proving your identity. Make sure the document is not out of date or physically damaged.',
                style: TextStyle(
                  color: Color(0xFF707B80),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  height: 20.0 / 16.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: const Color(0xFFC0C8CC),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      'The country that issued the document',
                      style: TextStyle(
                        color: Color(0xFFA4ADB2),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                        height: 16.0 / 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Text(
                      predefinedCountryName,
                      style: const TextStyle(
                        color: Color(0xFFA4ADB2),
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        height: 20.0 / 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: const Text(
                'Document type:',
                style: TextStyle(
                  color: Color(0xFF141719),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                  height: 24.0 / 18.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.countryList[0].documents.length,
              itemBuilder: (BuildContext baseContext, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < documentsTypeQty; i++) {
                        radioButtonStatusList[i] = false;
                      }
                      radioButtonStatusList[index] = true;
                      currentDocumentType = widget.countryList[0].documents[index];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    constraints: const BoxConstraints(
                      minHeight: 80,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFDCE2E5),
                          blurRadius: 12.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (widget.countryList[0].documents[index].name == 'ID-card') ...[
                          Image.asset(
                            'assets/id_card_ua.png',
                            width: 90,
                            height: 60,
                          )
                        ] else if (widget.countryList[0].documents[index].name == 'International passport') ...[
                          Image.asset(
                            'assets/passport_international.png',
                            width: 90,
                            height: 60,
                          )
                        ],
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
                            child: Text(
                              widget.countryList[0].documents[index].name == 'ID-card'
                                  ? 'ID card'
                                  : widget.countryList[0].documents[index].name == 'International passport'
                                      ? 'Foreign passport of Ukraine'
                                      : widget.countryList[0].documents[index].name,
                              style: const TextStyle(
                                color: Color(0xFF141719),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                height: 20.0 / 16.0,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Radio(
                          value: radioButtonStatusList[index],
                          groupValue: true,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        child: ElevatedButton(
          child: const Text('Next'),
          onPressed: () => widget.finishCallback(widget.countryList[0], currentDocumentType),
        ),
      ),
    );
  }
}
