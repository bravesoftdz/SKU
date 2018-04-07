(*
  Copyright 2016, Skuchain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Ignition;

{$I Skuchain.inc}

interface

uses
  Classes, SysUtils
  , Skuchain.Core.Engine
;

type
  TServerEngine=class
  private
    class var FEngine: TSkuchainEngine;
{$IFDEF Skuchain_FIREDAC}
    class var FAvailableConnectionDefs: TArray<string>;
{$ENDIF}
  public
    class constructor CreateEngine;
    class destructor DestroyEngine;
    class property Default: TSkuchainEngine read FEngine;
  end;


implementation

uses
    Skuchain.Core.Application
  , Skuchain.Core.Utils
  , Skuchain.Core.MessageBodyWriter, Skuchain.Core.MessageBodyWriters
  , Skuchain.Core.MessageBodyReaders, Skuchain.Data.MessageBodyWriters
  , Skuchain.Utils.Parameters.IniFile
  {$IFDEF Skuchain_FIREDAC} , Skuchain.Data.FireDAC {$ENDIF}
  , Skuchain.Core.Activation, Skuchain.Core.Activation.Interfaces
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
{$IFDEF Skuchain_FIREDAC}
    FAvailableConnectionDefs := TSkuchainFireDAC.LoadConnectionDefs(FEngine.Parameters, 'FireDAC');
{$ENDIF}
  except
    FreeAndNil(FEngine);
    raise;
  end;
end;

class destructor TServerEngine.DestroyEngine;
begin
{$IFDEF Skuchain_FIREDAC}
  TSkuchainFireDAC.CloseConnectionDefs(FAvailableConnectionDefs);
{$ENDIF}
  FreeAndNil(FEngine);
end;

end.
