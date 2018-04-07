unit Data.Remote;

interface

uses
  System.SysUtils, System.Classes, Skuchain.Client.SubResource,
  Skuchain.Client.SubResource.JSON, System.JSON, Skuchain.Client.CustomResource,
  Skuchain.Client.Resource, Skuchain.Client.Resource.JSON, Skuchain.Client.Client,
  Skuchain.Client.SubResource.Stream, Skuchain.Client.Application,
  Skuchain.Utils.Parameters, Skuchain.Client.Token, Skuchain.Client.Client.Indy
;

type
  TJSONArrayProc = TProc<TJSONArray>;
  TStreamProc = TProc<TStream>;

  TRemoteData = class(TDataModule)
    SkuchainClient: TSkuchainClient;
    CategoriesResource: TSkuchainClientResourceJSON;
    GalleryApplication: TSkuchainClientApplication;
    CategoryItemsSubResource: TSkuchainClientSubResourceJSON;
    ItemSubResource: TSkuchainClientSubResourceStream;
    Token: TSkuchainClientToken;
    procedure GalleryApplicationError(AResource: TObject; AException: Exception;
      AVerb: TSkuchainHttpVerb; const AAfterExecute: TProc<System.Classes.TStream>;
      var AHandled: Boolean);
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    procedure GetCategories(const AOnSuccess: TJSONArrayProc);
    procedure GetItems(const ACategory: string; const AOnSuccess: TJSONArrayProc);
    procedure GetItem(const ACategory, AItem: string; const AOnSuccess: TStreamProc);
  end;

var
  RemoteData: TRemoteData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Data.Main;

{$R *.dfm}

{ TRemoteData }

procedure TRemoteData.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF ANDROID} // tethering
  SkuchainClient.SkuchainEngineURL := 'http://192.168.43.152:8080/';
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  SkuchainClient.SkuchainEngineURL := 'http://localhost:8080/';
  {$ENDIF}
end;

procedure TRemoteData.GalleryApplicationError(AResource: TObject;
  AException: Exception; AVerb: TSkuchainHttpVerb;
  const AAfterExecute: TProc<System.Classes.TStream>; var AHandled: Boolean);
var
  LMessage: string;
begin
  LMessage := AException.Message;
  AHandled := True;

  TThread.Queue(nil,
    procedure
    begin
      MainData.ShowError(LMessage);
    end
  );
end;

procedure TRemoteData.GetCategories(const AOnSuccess: TJSONArrayProc);
begin
  CategoriesResource.GETAsync(
    procedure (AResource: TSkuchainClientCustomResource)
    var
      LResponse: TJSONValue;
    begin
      LResponse := (AResource as TSkuchainClientResourceJSON).Response;
      if Assigned(AOnSuccess) and (LResponse is TJSONArray) then
        AOnSuccess(TJSONArray(LResponse));
    end
  );
end;

procedure TRemoteData.GetItem(const ACategory, AItem: string;
  const AOnSuccess: TStreamProc);
begin
  ItemSubResource.Resource := '';
  ItemSubResource.PathParamsValues.Clear;
  ItemSubResource.PathParamsValues.Add(ACategory);
  ItemSubResource.PathParamsValues.Add(AItem);
  ItemSubResource.GETAsync(
    procedure (AResource: TSkuchainClientCustomResource)
    var
      LResponse: TStream;
    begin
      LResponse := (AResource as TSkuchainClientSubResourceStream).Response;
      if Assigned(AOnSuccess) then
        AOnSuccess(LResponse);
    end
  );
end;

procedure TRemoteData.GetItems(const ACategory: string; const AOnSuccess: TJSONArrayProc);
begin
  CategoryItemsSubResource.Resource := ACategory;
  CategoryItemsSubResource.GETAsync(
    procedure (AResource: TSkuchainClientCustomResource)
    var
      LResponse: TJSONValue;
    begin
      LResponse := (AResource as TSkuchainClientSubResourceJSON).Response;
      if Assigned(AOnSuccess) and (LResponse is TJSONArray) then
        AOnSuccess(TJSONArray(LResponse));
    end
  );
end;

end.
