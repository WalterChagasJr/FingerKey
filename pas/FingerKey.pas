unit FingerKey;

interface

uses
  System.SysUtils, System.Classes, FingerKey.interfaces,FingerKey.Factory;

type
  TTiposDispotivos = (fkNenhum,fkHamsterNitgen);
  TFingerKey = class(TComponent)
  private
    { Private declarations }
    FEventoInitialization:TOnInitialization;
    FTipoDispotivos:TTiposDispotivos;
    FFinge:IFingerKey;
    FDigitalCadastrada:string;
    FDigitalCapturada:string;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InicializarDispositivo;
    procedure FinalizarDispositivo;
    procedure CadastrarDigital(UserID:string='');
    procedure VerificarDigital(UserID:string='');
    property DigitalCadastrada:string read FDigitalCadastrada;
    property DigitalCapturada:string read  FDigitalCapturada;
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

procedure TFingerKey.CadastrarDigital(UserID: string);
begin
   if FFinge<>nil then
   begin
       if Assigned(FEventoInitialization) then
           FEventoInitialization('Cadastrando digital...');
       if not FFinge.CadastrarDigital(UserID) then
       begin
          if Assigned(FEventoInitialization) then
             FEventoInitialization('Não foi possível cadastrar a digital.');
          raise Exception.Create('Não foi possível cadastrar a digital.');
       end;
       FDigitalCadastrada:=FFinge.DigitalUsuarioCadastrado;
   end
   else
      raise Exception.Create('Ainda não foi selecionado o dispositivo.');
end;

constructor TFingerKey.Create(AOwner: TComponent);
begin
   inherited;
   FFinge:=nil;
end;

destructor TFingerKey.Destroy;
begin
  inherited;
end;

procedure TFingerKey.FinalizarDispositivo;
begin
   if FFinge<>nil then
   begin
      try
         FFinge.FinalizarBSP;
         if Assigned(FEventoInitialization) then
            FEventoInitialization('Desconectado com sucesso.');
      Except
         on E:Exception do
         begin
             if Assigned(FEventoInitialization) then
                FEventoInitialization(e.Message);
             raise Exception.Create(e.Message);
         end;
      end;
   end
   else
   begin
      if Assigned(FEventoInitialization) then
          FEventoInitialization('O dispositivo ainda não foi inicializado.');
      raise Exception.Create('O dispositivo ainda não foi inicializado.');
   end;
end;

procedure TFingerKey.InicializarDispositivo;
begin
   case FTipoDispotivos of
     fkNenhum: FFinge:=nil;
     fkHamsterNitgen:
     begin
        FFinge :=TFingerFactory.New.FingerKey;
     end;
   end;
   if FFinge<>nil then
   begin
      try
          FFinge.OnEventoInitialization(FEventoInitialization);
          FFinge.InicializarBSP;
          FFinge.AbrirDispositivoBSP;
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

procedure TFingerKey.VerificarDigital(UserID: string);
begin
   if FFinge<>nil then
   begin
       if Assigned(FEventoInitialization) then
           FEventoInitialization('Verificando digital...');
       if not FFinge.VerificarDigital(UserID) then
       begin
           if Assigned(FEventoInitialization) then
              FEventoInitialization('Não foi possível verificar a digital.');
           raise Exception.Create('Não foi possível verificar a digital.');
       end;
       FDigitalCapturada:=FFinge.DigitalUsuario;
   end
   else
      raise Exception.Create('Ainda não foi selecionado o dispositivo.');
end;

end.
