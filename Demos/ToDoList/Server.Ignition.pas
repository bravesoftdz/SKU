(*
  Copyright 2016, Skuchain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Ignition;

interface

uses
  Classes, SysUtils
  , Skuchain.Core.Engine
;

type
  TServerEngine=class
  private
    class var FEngine: TSkuchainEngine;
  public
    class constructor CreateEngine;
    class destructor DestroyEngine;
    class property Default: TSkuchainEngine read FEngine;
  end;


implementation

uses
    Skuchain.Core.Application
  , Skuchain.Core.Utils
  , Skuchain.Core.MessageBodyWriter
  , Skuchain.Core.MessageBodyWriters
  , Skuchain.Core.MessageBodyReaders
  , Skuchain.Utils.Parameters.IniFile

  , Skuchain.Data.FireDAC
  , Skuchain.Core.Activation, DB, Rtti
  {$IFDEF MSWINDOWS}
  , Skuchain.mORMotJWT.Token
  {$ELSE}
  , Skuchain.JOSEJWT.Token
  {$ENDIF}
  , Server.Resources
  ;

{ TServerEngine }

class constructor TServerEngine.CreateEngine;
begin
  FEngine := TSkuchainEngine.Create;
  try
    // Engine configuration
    FEngine.Parameters.LoadFromIniFile;

    // Application configuration
    FEngine.AddApplication('DefaultApp', '/default', [ 'Server.Resources.*']);
    TSkuchainFireDAC.LoadConnectionDefs(FEngine.Parameters, 'FireDAC');
//    TSkuchainReqRespLoggerCodeSite.Instance;

//    TSkuchainFireDAC.AddContextValueProvider(
//      procedure (const AContext: TSkuchainActivation; const AName: string;
//        const ADesiredType: TFieldType; out AValue: TValue)
//      begin
//        AValue := 123;
//      end
//    );
  except
    FreeAndNil(FEngine);
    raise;
  end;
end;

class destructor TServerEngine.DestroyEngine;
begin
  FreeAndNil(FEngine);
end;

end.
