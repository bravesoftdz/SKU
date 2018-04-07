(*
  Copyright 2016, Skuchain-Curiosity library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Resources.Data;

interface

uses
  System.SysUtils, System.Classes
  , Data.DB

  , FireDAC.Stan.Intf, FireDAC.Stan.Option
  , FireDAC.Stan.Error, FireDAC.UI.Intf
  , FireDAC.Phys.Intf, FireDAC.Stan.Def
  , FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys
  , FireDAC.Comp.Client
  , FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt
  , FireDAC.Comp.DataSet

  , Skuchain.Data.FireDAC.DataModule
  , Skuchain.Core.Attributes
  , Skuchain.Core.URL
  ;

type
  [Path('data')]
  TDataResource = class(TSkuchainFDDataModuleResource)
    DBConnection: TFDConnection;
  private
  public
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
    Skuchain.Core.Registry
  ;


initialization
  TSkuchainResourceRegistry.Instance.RegisterResource<TDataResource>(
    function:TObject
    begin
      Result := TDataResource.Create(nil);
    end
  );

end.
