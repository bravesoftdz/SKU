unit Resources.Razor;

interface

uses
  Classes, SysUtils
  , Skuchain.Core.Attributes
  , Skuchain.Core.MediaType
  , Skuchain.Core.Response

  , Skuchain.Core.URL

  , Skuchain.Core.Classes
  , Skuchain.Core.Engine
  , Skuchain.Core.Application

  , Skuchain.DelphiRazor.Resources
;

type
  [Path('razor')]
  TGalleryRazorResource = class(TRazorResource)
  protected
    [Context] App: TSkuchainApplication;
    function GetRootFolder: string;
    function CategoryFolder(const ACategoryName: string): string;

    function DoProvideContext(const APathInfo: string;
      const APathParam: string): TArray<TContextEntry>; override;
  public
  end;


implementation

uses
    IOUtils, DateUtils, Contnrs
  , Skuchain.Core.Registry
  , Skuchain.Core.Exceptions
  , Skuchain.Core.Utils
  , Skuchain.Rtti.Utils
  , Gallery.Model
  , Generics.Collections
;

{ TGalleryRazorResource }

function TGalleryRazorResource.CategoryFolder(
  const ACategoryName: string): string;
begin
  Result := TPath.Combine(GetRootFolder, ACategoryName);
end;

function TGalleryRazorResource.DoProvideContext(const APathInfo,
  APathParam: string): TArray<TContextEntry>;
var
  LListObject: TList<TObject>;
  LCategoryList: TCategoryList;
  LItemsList: TItemList;
begin
  Result := inherited DoProvideContext(APathInfo, APathParam);

  if SameText(APathInfo, 'categories') then
  begin
    LCategoryList := TCategoryList.CreateFromFolder(GetRootFolder);
    try
      LListObject := LCategoryList.ToTListObject;
      Result := Result + [TContextEntry.Create('categories', LListObject)];
    finally
      LCategoryList.Free;
    end;
  end
  else if SameText(APathInfo, 'items') then
  begin
    LItemsList := TItemList.CreateFromFolder(CategoryFolder(APathParam));
    try
      LListObject := LItemsList.ToTListObject;
      Result := Result + [TContextEntry.Create('items', LListObject)];
    finally
      LItemsList.Free;
    end;
  end;
end;

function TGalleryRazorResource.GetRootFolder: string;
begin
  Result := App.Parameters.ByName('RootFolder'
    , TPath.Combine(ExtractFilePath(ParamStr(0)), 'root')).AsString;
end;

initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<TGalleryRazorResource>(
    function: TObject
    begin
      Result := TGalleryRazorResource.Create;
    end
  );

end.
