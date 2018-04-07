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
  , Skuchain.Core.Response

  , Skuchain.Core.Token.Resource

  , JsonDataObjects
  , Skuchain.JsonDataObjects.ReadersAndWriters
  ;

type
  [Path('helloworld')]
  THelloWorldResource = class
  public
    [GET]
    function HelloWorld: TJsonObject;
    [POST]
    function CountItems([BodyParam] AData: TJsonArray): Integer;
  end;

  [Path('token')]
  TTokenResource = class(TSkuchainTokenResource)

  end;

implementation

uses
    Skuchain.Core.Registry
  ;

{ THelloWorldResource }

function THelloWorldResource.CountItems(AData: TJsonArray): Integer;
begin
  Result := AData.Count;
end;

function THelloWorldResource.HelloWorld: TJsonObject;
begin
  Result := TJsonObject.Create;
  Result.S['Message'] := 'Hello, world!';
end;

initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<THelloWorldResource>;
  TSkuchainResourceRegistry.Instance.RegisterResource<TTokenResource>;
end.
