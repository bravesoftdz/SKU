unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Skuchain.Client.CustomResource, Skuchain.Client.Resource,
  Skuchain.Client.FireDAC, Skuchain.Client.Application, Skuchain.Client.Client, Vcl.StdCtrls,
  Skuchain.Client.Client.Indy
;

type
  TForm1 = class(TForm)
    SkuchainClient1: TSkuchainClient;
    SkuchainClientApplication1: TSkuchainClientApplication;
    SkuchainDatamoduleResource: TSkuchainFDResource;
    employee1: TFDMemTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    SendToServerButton: TButton;
    FilterEdit: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SendToServerButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SkuchainDatamoduleResource.QueryParams.Values['filter'] := FilterEdit.Text;
  SkuchainDatamoduleResource.GET();
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SkuchainDatamoduleResource.GET();
end;

procedure TForm1.SendToServerButtonClick(Sender: TObject);
begin
  SkuchainDatamoduleResource.POST();
end;

end.
