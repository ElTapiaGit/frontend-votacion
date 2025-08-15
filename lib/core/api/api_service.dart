import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/error_logger.dart';
import 'package:demo_filestack/core/api/token_interceptor.dart';
import 'package:demo_filestack/data/models/user_model.dart';
import 'package:demo_filestack/data/models/mesa_model.dart';
import 'package:demo_filestack/data/models/votosPresidencial_model.dart';
import 'package:demo_filestack/data/models/votosUninominal_model.dart';
import 'package:demo_filestack/data/models/acta_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://sleeping-are-galaxy-friendly.trycloudflare.com/api")
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) {
    dio.interceptors.add(TokenInterceptor());
    return _ApiService(dio, baseUrl: baseUrl);
  }

  @POST("/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST("/password/forgot")
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  @POST("/password/reset")
  Future<void> resetPassword(@Body() Map<String, dynamic> body);

  @GET("/mesas/{codigoMesa}")
  Future<MesaModel> getMesaByCodigo(@Path("codigoMesa") int codigoMesa);

  @GET("/mesas/num/{numMesa}")
  Future<MesaModel> getMesaByNum(@Path("numMesa") String numMesa);

  @GET("/votospresidenciales/mesa/{mesaId}")
  Future<VotoPresidencialResponse?> obtenerVotoPresidencialPorMesa(@Path("mesaId") String mesaId);

  @GET("/uninominal/mesa/{mesaId}")
  Future<VotoUninominalResponse?> obtenerVotoUninominalPorMesa(@Path("mesaId") String mesaId);

  @POST("/votospresidenciales")
  Future<VotoPresidencialResponse> enviarVotosPresidenciales(@Body() VotoPresidencialRequest request);

  @POST("/uninominal")
  Future<VotoUninominalResponse> enviarVotoUninominal(@Body() VotoUninominalRequest request);
  
  @POST("/acta")
  Future<ActaModel> crearActa(@Body() ActaRequest request);
}
