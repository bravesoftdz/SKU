(*
  Copyright 2016, Skuchain-Curiosity - REST Library

  Home: https://github.com/andrea-magni/Skuchain
*)
unit Server.Forms.Main;

{$I Skuchain.inc}

interface

uses Classes, SysUtils, Forms, ActnList, ComCtrls, StdCtrls, Controls, ExtCtrls
  , Skuchain.http.Server.Indy, System.Actions
  ;

type
  TMainForm = class(TForm)
    MainActionList: TActionList;
    StartServerAction: TAction;
    StopServerAction: TAction;
    TopPanel: TPanel;
    Label1: TLabel;
    StartButton: TButton;
    StopButton: TButton;
    PortNumberEdit: TEdit;
    MainTreeView: TTreeView;
    procedure StartServerActionExecute(Sender: TObject);
    procedure StartServerActionUpdate(Sender: TObject);
    procedure StopServerActionExecute(Sender: TObject);
    procedure StopServerActionUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PortNumberEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FServer: TSkuchainhttpServerIndy;
  protected
    procedure RenderEngines(const ATreeView: TTreeView);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  StrUtils, Web.HttpApp
  , Skuchain.Core.URL, Skuchain.Core.Engine, Skuchain.Core.Application, Skuchain.Core.Registry
  , Server.Ignition;

procedure TMainForm.RenderEngines(const ATreeView: TTreeView);
begin

  ATreeview.Items.BeginUpdate;
  try
    ATreeview.Items.Clear;
    TSkuchainEngineRegistry.Instance.EnumerateEngines(
      procedure (AName: string; AEngine: TSkuchainEngine)
      var
        LEngineItem: TTreeNode;
      begin
        LEngineItem := ATreeview.Items.AddChild(nil
          , AName +  ' [ :' + AEngine.Port.ToString + AEngine.BasePath + ']'
        );

        AEngine.EnumerateApplications(
          procedure (AName: string; AApplication: TSkuchainApplication)
          var
            LApplicationItem: TTreeNode;
          begin
            LApplicationItem := ATreeview.Items.AddChild(LEngineItem
              , AApplication.Name +  ' [' + AApplication.BasePath + ']'
            );

            AApplication.EnumerateResources(
              procedure (AName: string; AInfo: TSkuchainConstructorInfo)
              var
                LResourceItem: TTreeNode;
              begin
                LResourceItem := ATreeview.Items.AddChild(LApplicationItem
                  , AInfo.TypeTClass.ClassName +  ' [' + AName + ']'
                );

              end
            );
          end
        );
      end
    );

    if ATreeView.Items.Count > 0 then
      ATreeView.Items[0].Expand(True);
  finally
    ATreeView.Items.EndUpdate;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopServerAction.Execute;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PortNumberEdit.Text := IntToStr(TServerEngine.Default.Port);

  // skip favicon requests (browser)
  TServerEngine.Default.OnBeforeHandleRequest :=
    function (AEngine: TSkuchainEngine; AURL: TSkuchainURL;
      ARequest: TWebRequest; AResponse: TWebResponse; var Handled: Boolean
    ): Boolean
    begin
      Result := True;
      if SameText(AURL.Document, 'favicon.ico') then
      begin
        Result := False;
        Handled := True;
      end;
    end;

  RenderEngines(MainTreeView);

  StartServerAction.Execute;
end;

procedure TMainForm.PortNumberEditChange(Sender: TObject);
begin
  TServerEngine.Default.Port := StrToInt(PortNumberEdit.Text);
end;

procedure TMainForm.StartServerActionExecute(Sender: TObject);
begin
  // http server implementation
  FServer := TSkuchainhttpServerIndy.Create(TServerEngine.Default);
  try
    FServer.DefaultPort := TServerEngine.Default.Port;
    FServer.Active := True;
  except
    FServer.Free;
    raise;
  end;
end;

procedure TMainForm.StartServerActionUpdate(Sender: TObject);
begin
  StartServerAction.Enabled := (FServer = nil) or (FServer.Active = False);
end;

procedure TMainForm.StopServerActionExecute(Sender: TObject);
begin
  FServer.Active := False;
  FreeAndNil(FServer);
end;

procedure TMainForm.StopServerActionUpdate(Sender: TObject);
begin
  StopServerAction.Enabled := Assigned(FServer) and (FServer.Active = True);
end;

end.
