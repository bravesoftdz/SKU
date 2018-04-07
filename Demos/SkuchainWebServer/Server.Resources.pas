(*
  Copyright 2016, Skuchain-Curiosity library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Resources;

interface

uses
  SysUtils, Classes, Diagnostics

  , Skuchain.Core.Attributes
  , Skuchain.Core.MediaType
  , Skuchain.Core.Response

  , Skuchain.WebServer.Resources
  , Skuchain.Core.URL

  , Skuchain.Core.Classes
  , Skuchain.Core.Engine
  , Skuchain.Core.Application
;

type
  [Path('helloworld')
  , RootFolder('C:\Temp', True)]
  THelloWorldResource = class(TFileSystemResource)
  end;

implementation

uses
    IOUtils, DateUtils
  , Skuchain.Core.Registry
  , Skuchain.Core.Exceptions
  ;

initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<THelloWorldResource>(
    function: TObject
    begin
      Result := THelloWorldResource.Create;
    end
  );

end.
