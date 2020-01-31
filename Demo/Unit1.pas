unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FingerKey;

type
  TForm1 = class(TForm)
    FingerKey: TFingerKey;
    lblStatus: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FingerKeyInitizalization(status: string);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
  try
      FingerKey.CadastrarDigital('adenilson');
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
        FingerKey.VerificarDigital('adenilson');
        MessageDlg('Digital Reconhecida. Digital: '+FingerKey.DigitalCapturada, mtInformation, [mbOK],0);
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
        Button4.Enabled:=True;
   except
       on E:Exception do
       begin
          Button3.Enabled:=false;
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
        FingerKey.FinalizarDispositivo;
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
