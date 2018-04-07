unit ReadersAndWriters.JSON;

interface

uses
    Classes, SysUtils, Rtti
  , Skuchain.Core.Classes
  , Skuchain.Core.Attributes
  , Skuchain.Core.MessageBodyWriter
  , Skuchain.Core.MediaType
  , Skuchain.Core.Activation.Interfaces
  ;

type
  [Produces(TMediaType.APPLICATION_JSON)]
  TCategoryListWriter=class(TInterfacedObject, IMessageBodyWriter)
  public
    procedure WriteTo(const AValue: TValue; const AMediaType: TMediaType;
      AOutputStream: TStream; const AActivation: ISkuchainActivation);
  end;

  [Produces(TMediaType.APPLICATION_JSON)]
  TItemListWriter=class(TInterfacedObject, IMessageBodyWriter)
  public
    procedure WriteTo(const AValue: TValue; const AMediaType: TMediaType;
      AOutputStream: TStream; const AActivation: ISkuchainActivation);
  end;

implementation

uses
    Skuchain.Rtti.Utils
  , Skuchain.Core.JSON
  , Skuchain.Core.Declarations
  , Gallery.Model
  , Rest.JSON
  , Gallery.Model.JSON;

{ TCategoryWriter }

procedure TCategoryListWriter.WriteTo(const AValue: TValue; const AMediaType: TMediaType;
  AOutputStream: TStream; const AActivation: ISkuchainActivation);
var
  LWriter: TStreamWriter;
  LJSONArray: TJSONArray;
begin
  LWriter := TStreamWriter.Create(AOutputStream);
  try
    LJSONArray := TGallerySkuchainhal.ListToJSONArray(AValue.AsType<TCategoryList>);;
    try
      LWriter.Write(LJSONArray.ToJSON);
    finally
      LJSONArray.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

{ TItemListWriter }

procedure TItemListWriter.WriteTo(const AValue: TValue; const AMediaType: TMediaType;
  AOutputStream: TStream; const AActivation: ISkuchainActivation);
var
  LWriter: TStreamWriter;
  LJSONArray: TJSONArray;
begin
  LWriter := TStreamWriter.Create(AOutputStream);
  try
    LJSONArray := TGallerySkuchainhal.ListToJSONArray(AValue.AsType<TItemList>);;
    try
      LWriter.Write(LJSONArray.ToJSON);
    finally
      LJSONArray.Free;
    end;
  finally
    LWriter.Free;
  end;
end;

initialization
  TSkuchainMessageBodyRegistry.Instance.RegisterWriter<TCategoryList>(TCategoryListWriter);
  TSkuchainMessageBodyRegistry.Instance.RegisterWriter<TItemList>(TItemListWriter);

end.
