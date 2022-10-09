/// Model intended to initialize SDK
/// [applicantId] unique identifier of user that will pass KYC process. Should be provided outside KYC SDK.
/// [server] url to KYC server
class Applicant {
  final String applicantId;
  final String server;

  Applicant({
    required this.applicantId,
    required this.server,
  });
}
