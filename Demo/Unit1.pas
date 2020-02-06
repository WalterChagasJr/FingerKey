unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FingerKey, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageXML;

type
  TForm1 = class(TForm)
    FingerKey: TFingerKey;
    lblStatus: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    FDDigitais: TFDMemTable;
    FDDigitaisIdUsuario: TStringField;
    FDDigitaisDigitalUsuario: TBlobField;
    DBGrid1: TDBGrid;
    DsDigital: TDataSource;
    edtIDUsuario: TEdit;
    btnExportarDados: TButton;
    btnImportarDados: TButton;
    OpenDialog1: TOpenDialog;
    FDStanStorageXMLLink1: TFDStanStorageXMLLink;
    procedure FingerKeyInitizalization(status: string);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnImportarDadosClick(Sender: TObject);
    procedure btnExportarDadosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnExportarDadosClick(Sender: TObject);
begin
    FDDigitais.SaveToFile(ExtractFilePath(Application.ExeName)+'DADOS.xml', sfXML);
    MessageDlg('Dados exportados em: '+ExtractFilePath(Application.ExeName)+'DADOS.xml',  mtInformation, [mbOK],0);
end;

procedure TForm1.btnImportarDadosClick(Sender: TObject);
begin
    if OpenDialog1.Execute then
    begin
        FDDigitais.LoadFromFile(OpenDialog1.FileName, sfXML);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  try
      FingerKey.IDUsuario:=edtIDUsuario.Text;
      FingerKey.CapturarDigital;
      FDDigitais.Append;
      FDDigitaisIdUsuario.AsString:=edtIDUsuario.Text;
      FDDigitaisDigitalUsuario.AsString:=FingerKey.DigitalCapturada;
      FDDigitais.Post;
      btnExportarDados.Enabled:= FDDigitais.RecordCount>0;
      MessageDlg('Digital cadastrada.', mtInformation, [mbOK],0);
      Button2.Enabled:=True;
  except
     on E:Exception do
     begin
        Button2.Enabled:=false;
        MessageDlg(e.Message, mtWarning, [mbOK],0);
     end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   try
        FingerKey.IDUsuario:=FDDigitaisIdUsuario.AsString;
        FingerKey.DigitalCadastrada:=FDDigitaisDigitalUsuario.AsString;
        FingerKey.VerificarDigital;
   except
       on E:Exception do
       begin
          MessageDlg(e.Message, mtWarning, [mbOK],0);
       end;
   end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   try
        Button3.Enabled:=False;
        Application.ProcessMessages;
        FingerKey.InicializarDispositivo;
        Button1.Enabled:=True;
        Button2.Enabled :=True;
        Button4.Enabled:=True;
   except
       on E:Exception do
       begin
          Button3.Enabled:=true;
          Button1.Enabled:=false;
          Button2.Enabled:=false;
          Button4.Enabled:=false;
          MessageDlg(e.Message, mtWarning, [mbOK],0);
       end;
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   try
        Button1.Enabled:=false;
        Button2.Enabled:=false;
        Button4.Enabled:=False;
        Application.ProcessMessages;
        Button3.Enabled:=True;
   except
       on E:Exception do
       begin
          Button1.Enabled:=true;
          Button2.Enabled:=true;
          Button4.Enabled:=true;
          Application.ProcessMessages;
          MessageDlg(e.Message, mtWarning, [mbOK],0);
       end;
   end;
end;

procedure TForm1.FingerKeyInitizalization(status: string);
begin
    lblStatus.Caption:=status;
end;

end.
