// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/api/api_verification_repository_impl.dart' as _i31;
import '../../data/api/base/api_base_repository_impl.dart' as _i29;
import '../../data/general/configure_repository_impl.dart' as _i5;
import '../../data/helper/image_helper_impl.dart' as _i16;
import '../../data/kyc/kyc_repository_impl.dart' as _i19;
import '../../data/log/log_impl.dart' as _i22;
import '../../data/wrapper/platform.dart' as _i24;
import '../../domain/entity/mapper/documents/document_country_mapper.dart'
    as _i7;
import '../../domain/entity/mapper/documents/document_document_page_mapper.dart'
    as _i8;
import '../../domain/entity/mapper/documents/document_document_type_mapper.dart'
    as _i9;
import '../../domain/entity/mapper/kyc_status_mapper.dart' as _i20;
import '../../domain/exception/exception_handler_impl.dart' as _i13;
import '../../domain/repository/api/api_verification_repository.dart' as _i30;
import '../../domain/repository/general/configure_repository.dart' as _i4;
import '../../domain/repository/general/exception_handler.dart' as _i12;
import '../../domain/repository/helper/image_helper.dart' as _i15;
import '../../domain/repository/kyc/kyc_repository.dart' as _i18;
import '../../domain/repository/log/log.dart' as _i21;
import '../../domain/usecases/check_selfie_data.dart' as _i3;
import '../../domain/usecases/detect_selfie_data.dart' as _i6;
import '../../domain/usecases/get_kyc_status.dart' as _i14;
import '../../domain/usecases/prepare_jpg_data.dart' as _i25;
import '../../domain/usecases/upload_document_from_camera.dart' as _i26;
import '../../domain/usecases/upload_document_from_file.dart' as _i27;
import '../../domain/usecases/upload_selfie_data.dart' as _i28;
import '../../general/native_utils.dart' as _i23;
import '../store/screens/documents/documents_photo_screen_store.dart' as _i10;
import '../store/screens/documents/documents_select_type_screen_store.dart'
    as _i11;
import '../store/screens/liveness/kyc_liveness_screen_store.dart'
    as _i17; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.CheckSelfieData>(() => _i3.CheckSelfieData());
  gh.lazySingleton<_i4.ConfigureRepository>(
      () => _i5.ConfigureRepositoryImpl());
  gh.lazySingleton<_i6.DetectSelfieData>(() => _i6.DetectSelfieData());
  gh.lazySingleton<_i7.DocumentCountryMapper>(
      () => _i7.DocumentCountryMapper());
  gh.lazySingleton<_i8.DocumentDocumentPageMapper>(
      () => _i8.DocumentDocumentPageMapper());
  gh.lazySingleton<_i9.DocumentDocumentTypeMapper>(
      () => _i9.DocumentDocumentTypeMapper());
  gh.lazySingleton<_i10.DocumentsPhotoScreenStore>(
      () => _i10.DocumentsPhotoScreenStore());
  gh.lazySingleton<_i11.DocumentsSelectTypeScreenStore>(
      () => _i11.DocumentsSelectTypeScreenStore());
  gh.singleton<_i12.ExceptionHandler>(_i13.ExceptionHandlerImpl());
  gh.lazySingleton<_i14.GetKycStatus>(() => _i14.GetKycStatus());
  gh.lazySingleton<_i15.ImageHelper>(() => _i16.ImageHelperImpl());
  gh.lazySingleton<_i17.KycLivenessScreenStore>(
      () => _i17.KycLivenessScreenStore());
  gh.lazySingleton<_i18.KycRepository>(() => _i19.KycRepositoryImpl());
  gh.lazySingleton<_i20.KycStatusMapper>(() => _i20.KycStatusMapper());
  gh.lazySingleton<_i21.Log>(() => _i22.LogImpl(get<_i12.ExceptionHandler>()));
  gh.singleton<_i23.NativeUtils>(_i23.NativeUtilsImpl());
  gh.singleton<_i24.Platform>(_i24.Platform());
  gh.lazySingleton<_i25.PrepareJpgData>(() => _i25.PrepareJpgData());
  gh.lazySingleton<_i26.UploadDocumentFromCamera>(
      () => _i26.UploadDocumentFromCamera());
  gh.lazySingleton<_i27.UploadDocumentFromFile>(
      () => _i27.UploadDocumentFromFile());
  gh.lazySingleton<_i28.UploadSelfieData>(() => _i28.UploadSelfieData());
  gh.singleton<_i29.ApiBaseRepositoryImpl>(
      _i29.ApiBaseRepositoryImpl(get<_i4.ConfigureRepository>()));
  gh.lazySingleton<_i30.ApiVerificationRepository>(
      () => _i31.ApiVerificationRepositoryImpl(
            get<_i29.ApiBaseRepositoryImpl>(),
            get<_i4.ConfigureRepository>(),
          ));
  return get;
}
