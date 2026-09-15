// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_controller.dart';

// **************************************************************************
// RoutingGenerator
// **************************************************************************

Router _$FilesControllerRouter(FilesController service) => Router()
  ..add('GET', '/', (Request request) async {
    final body = await service.download(request);
    return Response.ok(body);
  })
  ..add('GET', '/via-response', (Request request) async {
    return await service.downloadViaResponse(request);
  })
  ..add('POST', '/', (Request request) async {
    await service.upload(request, request.read());
    return Response.ok(null);
  });
