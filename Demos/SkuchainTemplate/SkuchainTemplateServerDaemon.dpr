program SkuchainTemplateServerDaemon;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  SysUtils,
  {$IFDEF LINUX}
  Skuchain.Linux.Daemon in '..\..\Source\Skuchain.Linux.Daemon.pas',
  {$ENDIF}
  Server.Ignition in 'Server.Ignition.pas',
  Server.WebModule in 'Server.WebModule.pas' {ServerWebModule: TWebModule};

begin
  {$IFDEF LINUX}
  TSkuchainDaemon.Current.Name := 'SkuchainTemplateServerDaemon';
  TSkuchainDaemon.Current.Start;
  {$ENDIF}
end.
