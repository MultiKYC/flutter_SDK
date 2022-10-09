import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kyc/config.dart';
import 'package:kyc/screens/step_screen.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart' as kyc_sdk;

class ConfigScreen extends StatefulWidget {
  static const tag = 'SplashScreen';

  @override
  _ConfigScreenState createState() {
    return _ConfigScreenState();
  }
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _config = Config();
  final _urlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  final _applicantController = TextEditingController();
  final _applicantFocusNode = FocusNode();

  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    _urlController.text = _config.kycUrl;
    _applicantController.text = _config.applicantId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: const Text(
                  'Please fill next fields to be able use KYC',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 8),
                child: const Text('KYC server url:'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: CupertinoTextField(
                  controller: _urlController,
                  focusNode: _urlFocusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 8),
                child: const Text('KYC applicant id:'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: CupertinoTextField(
                  controller: _applicantController,
                  focusNode: _applicantFocusNode,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Connect'),
              if (_connecting) ...[
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  width: 16,
                  height: 16,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ],
          ),
          onPressed: () {
            if (!_connecting) {
              _connect();
            }
          },
        ),
      ),
    );
  }

  Future<void> _connect() async {
    setState(() {
      _connecting = true;
    });

    _urlFocusNode.unfocus();
    _applicantFocusNode.unfocus();

    final applicantId = _applicantController.text;
    _config.applicantId = applicantId;

    final kycUrl = _urlController.text;
    _config.kycUrl = kycUrl;

    final kyc_sdk.KycSdk _kycSdk = kyc_sdk.KycSdk(applicant: kyc_sdk.Applicant(applicantId: applicantId, server: kycUrl));
    await _kycSdk.initialize();
    _kycSdk.checkStatus().then((value) {
      switch (value) {
        case kyc_sdk.KycStepStatus.verificationNew:
          _openStepScreen();
          break;
        case kyc_sdk.KycStepStatus.verificationInProgress:
          _openStepScreen();
          break;
        case kyc_sdk.KycStepStatus.verificationApproved:
          _openStepScreen();
          break;
        case kyc_sdk.KycStepStatus.verificationApplicantFiled:
          _showToast('KycStepStatus.verificationApplicantFiled');
          break;
        case kyc_sdk.KycStepStatus.verificationCanceled:
          _showToast('KycStepStatus.verificationCanceled');
          break;
        case kyc_sdk.KycStepStatus.errorKyc:
          _showToast('KycStepStatus.errorKyc');
          break;
        case kyc_sdk.KycStepStatus.errorConnection:
          _showToast('KycStepStatus.errorConnection');
          break;
        case kyc_sdk.KycStepStatus.errorGeneral:
          _showToast('KycStepStatus.errorGeneral');
          break;
        case kyc_sdk.KycStepStatus.errorStepNotSupported:
          _showToast('KycStepStatus.errorStepNotSupported');
          break;
        case kyc_sdk.KycStepStatus.errorExpired:
          _showToast('KycStepStatus.errorExpired');
          break;
      }
    }).whenComplete(() {
      setState(() {
        _connecting = false;
      });
    });
  }

  void _openStepScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => StepScreen(),
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
