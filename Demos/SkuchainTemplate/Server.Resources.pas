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
  , Skuchain.Core.URL

  , Skuchain.Core.Token.Resource
  ;

type
  [Path('helloworld')]
  THelloWorldResource = class
  protected
  public
    [GET, Produces(TMediaType.TEXT_PLAIN)]
    function SayHelloWorld: string;
  end;

  [Path('token')]
  TTokenResource = class(TSkuchainTokenResource)
  end;

implementation

uses
    Skuchain.Core.Registry
;

{ THelloWorldResource }

function THelloWorldResource.SayHelloWorld: string;
begin
  Result := 'Hello World!';
end;

initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<THelloWorldResource>;
  TSkuchainResourceRegistry.Instance.RegisterResource<TTokenResource>;
end.
