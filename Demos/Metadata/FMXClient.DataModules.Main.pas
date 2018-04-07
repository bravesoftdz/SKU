(*
  Copyright 2016, Skuchain-Curiosity library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit FMXClient.DataModules.Main;

interface

uses
  System.SysUtils, System.Classes, Skuchain.Client.CustomResource,
  Skuchain.Client.Resource, Skuchain.Client.Resource.JSON, Skuchain.Client.Application,
  Skuchain.Client.Client, Skuchain.Client.SubResource, Skuchain.Client.SubResource.JSON,
  Skuchain.Client.Messaging.Resource, System.JSON, Skuchain.Metadata, Skuchain.Metadata.JSON,
  Skuchain.Client.Client.Indy
;

type
  TMainDataModule = class(TDataModule)
    Client: TSkuchainClient;
    DefaultApplication: TSkuchainClientApplication;
    MetadataResource: TSkuchainClientResourceJSON;
  private
    { Private declarations }
    FMetadata: TSkuchainEngineMetadata;
    function GetMetadata: TSkuchainEngineMetadata;
  public
    procedure Refresh(const AThen: TProc = nil);
    property Metadata: TSkuchainEngineMetadata read GetMetadata;
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TMainDataModule }

function TMainDataModule.GetMetadata: TSkuchainEngineMetadata;
begin
  if not Assigned(FMetadata) then
  begin
    FMetadata := TSkuchainEngineMetadata.Create(nil);
    try
      MetadataResource.GET(nil,
        procedure (AStream: TStream)
        begin
          FMetadata.FromJSON(MetadataResource.Response as TJSONObject);
        end
      );
    except
      FreeAndNil(FMetadata);
      raise;
    end;
  end;
  Result := FMetadata;
end;

procedure TMainDataModule.Refresh(const AThen: TProc);
begin
  FreeAndNil(FMetadata);
  GetMetadata;
  if Assigned(AThen) then
    AThen();
end;

end.
