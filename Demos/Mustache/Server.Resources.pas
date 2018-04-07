(*
  Copyright 2016, Skuchain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Resources;

interface

uses
  SysUtils, Classes

  , Skuchain.Core.Attributes
  , Skuchain.Core.MediaType
  , Skuchain.Core.JSON
  , Skuchain.Core.Response

  , Skuchain.Core.Token.Resource

  , Skuchain.dmustache, Skuchain.dmustache.InjectionService
  , Skuchain.Metadata, Skuchain.Metadata.JSON, Skuchain.Metadata.InjectionService
  ;

type
  [Path('helloworld')]
  THelloWorldResource = class
  protected
    [Context] mustache: TSkuchaindmustache;
  public
    [GET, Produces(TMediaType.TEXT_PLAIN)]
    function SayHelloWorld: string;

    [GET, Path('/to/{Someone}'), Produces(TMediaType.TEXT_PLAIN)]
    function SayHelloTo([PathParam] Someone: string): string;

    [GET, Path('metadata/simple'), Produces(TMediaType.TEXT_HTML)]
    function MetadataSimple([Context] Metadata: TSkuchainApplicationMetadata): string;

    [GET, Path('metadata/bootstrap'), Produces(TMediaType.TEXT_HTML)]
    function MetadataBootstrap([Context] Metadata: TSkuchainApplicationMetadata): string;

    [GET, Path('metadata/json'), Produces(TMediaType.APPLICATION_JSON)]
    function MetadataJSON([Context] Metadata: TSkuchainApplicationMetadata): string;
  end;

  [Path('token')]
  TTokenResource = class(TSkuchainTokenResource)
  end;

implementation

uses
  Skuchain.Core.Registry
, SynCommons
;

{ THelloWorldResource }

function THelloWorldResource.MetadataSimple(Metadata: TSkuchainApplicationMetadata): string;
begin
  Result := mustache.RenderTemplateWithJSON('metadata_simple.html', Metadata.ToJSON, True);
end;

function THelloWorldResource.MetadataBootstrap(
  Metadata: TSkuchainApplicationMetadata): string;
begin
  Result := mustache.RenderTemplateWithJSON('metadata_bootstrap.html', Metadata.ToJSON, True);
end;

function THelloWorldResource.MetadataJSON(
  Metadata: TSkuchainApplicationMetadata): string;
var
  LJSON: TJSONObject;
begin
  LJSON := Metadata.ToJSON;
  try
    Result := LJSON.ToJSON;
  finally
    LJSON.Free;
  end;
end;

function THelloWorldResource.SayHelloTo(Someone: string): string;
var
  LContext: Variant;
begin
  TDocVariant.New(LContext);
  LContext.Someone := Someone;
  LContext.Now := Now;
  Result := mustache.Render('Hello, {{Someone}}. Current time is: {{Now}}.', LContext);
end;

function THelloWorldResource.SayHelloWorld: string;
begin
  Result := 'Hello World!';
end;

initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<THelloWorldResource>;
  TSkuchainResourceRegistry.Instance.RegisterResource<TTokenResource>;
end.
