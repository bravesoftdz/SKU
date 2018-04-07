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
    class var FAvailableConnectionDefs: TArray<string>;
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
    FAvailableConnectionDefs := TSkuchainFireDAC.LoadConnectionDefs(FEngine.Parameters, 'FireDAC');
  except
    FreeAndNil(FEngine);
    raise;
  end;
end;

class destructor TServerEngine.DestroyEngine;
begin
  TSkuchainFireDAC.CloseConnectionDefs(FAvailableConnectionDefs);
  FreeAndNil(FEngine);
end;

end.
