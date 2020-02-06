unit FingerKey;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, FingerKey.interfaces,FingerKey.Factory;

type
  TTiposDispotivos = (fkNenhum,fkHamsterNitgen);
  TFingerKey = class(TComponent)
  private
    { Private declarations }
    FTipoDispotivos:TTiposDispotivos;
    FEventoInitialization:TOnInitialization;
    FFinger:IFingerKey;
    FDigitalCapturada:string;
    FIDUsuario:string;
    FDigitalCadastrada:string;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InicializarDispositivo;
    procedure CapturarDigital;
    procedure VerificarDigital;
    property DigitalCapturada:string read  FDigitalCapturada;
    property IDUsuario:string read FIDUsuario write FIDUsuario;
    property DigitalCadastrada:string read FDigitalCadastrada write FDigitalCadastrada;
  published
    { Published declarations }
    property TipoDeDispotivos: TTiposDispotivos read  FTipoDispotivos write FTipoDispotivos;
    property Initizalization :TOnInitialization read  FEventoInitialization write FEventoInitialization;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ReconhecimentoDigital', [TFingerKey]);
end;

{ TFingerKey }

procedure TFingerKey.CapturarDigital;
begin
   if FFinger<>nil then
   begin
       if Assigned(FEventoInitialization) then
           FEventoInitialization('Cadastrando digital...');
       try
           FFinger.IDUsuario:=FIDUsuario;
           FFinger.CapturarDigital;
           FDigitalCapturada:=FFinger.DigitalCapturada;
       except
          if Assigned(FEventoInitialization) then
             FEventoInitialization('Não foi possível cadastrar a digital.');
          raise Exception.Create('Não foi possível cadastrar a digital.');
       end;
   end
   else
      raise Exception.Create('Ainda não foi selecionado o dispositivo.');
end;

constructor TFingerKey.Create(AOwner: TComponent);
begin
   inherited;
   FFinger:=nil;
end;

destructor TFingerKey.Destroy;
begin
  inherited;
end;

procedure TFingerKey.InicializarDispositivo;
begin
   case FTipoDispotivos of
     fkNenhum: FFinger:=nil;
     fkHamsterNitgen:
     begin
        try
           FFinger :=TFingerFactory.New.FingerKey;
        except
            on E:Exception do
            begin
               raise Exception.Create(e.Message);
            end;
        end;
     end;
   end;
   if FFinger<>nil then
   begin
      try
          FFinger.OnStatus(FEventoInitialization);
      except
          on E:Exception do
          begin
              if Assigned(FEventoInitialization) then
                  FEventoInitialization(E.Message);
              raise Exception.Create(e.Message);
          end;
      end;

   end
   else
      raise Exception.Create('Ainda não foi selecionado o dispositivo.');
end;

procedure TFingerKey.VerificarDigital;
begin
   if FFinger<>nil then
   begin
       if Assigned(FEventoInitialization) then
           FEventoInitialization('Verificando digital...');
       try
          FFinger.IDUsuario:=FIDUsuario;
          FFinger.DigitalCadastrada:=FDigitalCadastrada;
          FFinger.VerificarDigital;
          FDigitalCapturada:=FFinger.DigitalCapturada;
       except
          on E:Exception do
          begin
             if Assigned(FEventoInitialization) then
              FEventoInitialization(e.Message);
           raise Exception.Create(e.Message);
          end;
       end;
   end
   else
      raise Exception.Create('Ainda não foi selecionado o dispositivo.');
end;

end.
