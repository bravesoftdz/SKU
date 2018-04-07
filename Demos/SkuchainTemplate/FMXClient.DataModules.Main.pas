(*
  Copyright 2016, Skuchain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit FMXClient.DataModules.Main;

interface

uses
  System.SysUtils, System.Classes, Skuchain.Client.Application,
  Skuchain.Client.Client, Skuchain.Client.Client.Indy
;

type
  TMainDataModule = class(TDataModule)
    SkuchainClient: TSkuchainClient;
    SkuchainApplication: TSkuchainClientApplication;
  private
  public
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
