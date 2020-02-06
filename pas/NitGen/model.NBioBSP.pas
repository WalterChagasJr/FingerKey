unit model.NBioBSP;

interface

uses
  Comobj, SysUtils, Classes, Vcl.Forms, FingerKey.interfaces;
type
TNBioBSP  = class(TInterfacedObject, IFingerKey)
   const
      NBioAPIERROR_NONE = 0;
      NBioAPI_FIR_PURPOSE_VERIFY      = 1;
      //Constant for DeviceID
      NBioAPI_DEVICE_ID_NONE          = 0;
      NBioAPI_DEVICE_ID_FDP02_0       = 1;
      NBioAPI_DEVICE_ID_FDU01_0       = 2;
      NBioAPI_DEVICE_ID_AUTO_DETECT   = 255;
   private
      FEventoStatus:TOnInitialization;
      FobjNBioBSP      : variant;
      FobjDevice       : variant;
      FobjExtraction   : variant;
      FobjIndexSearch  : variant;
      FIDUsuario:string;
      FDigitalCapturada:string;
      FVersaoDoDriver:string;
    FDigitalCadastrada: string;
    function GetDigitalCapturada: string;
    function GetVersaoDoDriver: string;
    procedure SetIDUsuario(const Value: string);
    function GetIDUsuario: string;
    procedure SetDigitalCadastrada(const Value: string);
    function GetDigitalCadastrada: string;
   public
      class function New:IFingerKey;
      constructor create;
      destructor Destroy; override;
      function OnStatus(evento:TOnInitialization):IFingerKey;
      procedure InicializarDispositivo;
      procedure CapturarDigital;
      procedure VerificarDigital;
      property DigitalCapturada:string read GetDigitalCapturada;
      property VersaoDoDriver:string read GetVersaoDoDriver;
      property IDUsuario:string read GetIDUsuario write SetIDUsuario;
      property DigitalCadastrada:string read GetDigitalCadastrada write SetDigitalCadastrada;
end;

implementation

{ TNBioBSP }

procedure TNBioBSP.CapturarDigital;
begin
   try
      InicializarDispositivo;
      if Assigned(FEventoStatus) then
        FEventoStatus('Iniciando a captura da digital.');
      Application.ProcessMessages;
      FobjExtraction.Enroll('', 0);
      if FobjExtraction.ErrorCode <> NBioAPIERROR_NONE Then
      begin
          if Assigned(FEventoStatus) then
            FEventoStatus('A captura da digital falhou!');
          raise Exception.Create('A captura da digital falhou!');
      end;
      FDigitalCapturada := FobjExtraction.TextEncodeFIR;
      FobjIndexSearch.AddFIR(FDigitalCapturada, FIDUsuario);
      if (FobjIndexSearch.ErrorCode <> NBioAPIERROR_NONE) Then
      begin
          if Assigned(FEventoStatus) then
            FEventoStatus('A captura da digital falhou!');
          raise Exception.Create('A captura da digital falhou!');
      end;
      Application.ProcessMessages;
      if Assigned(FEventoStatus) then
         FEventoStatus('Digital capturada com sucesso.');
   finally
      FobjDevice.Close(NBioAPI_DEVICE_ID_AUTO_DETECT);
   end;
end;

constructor TNBioBSP.create;
begin
    if Assigned(FEventoStatus) then
       FEventoStatus('Inicializando dispotivo...');
    Application.ProcessMessages;
    FobjNBioBSP := CreateOleObject('NBioBSPCOM.NBioBSP');
    FobjDevice      := FobjNBioBSP.Device;
    FobjExtraction  := FobjNBioBSP.Extraction;
    FobjIndexSearch := FobjNBioBSP.IndexSearch;
    //Verificando se conseguiu inicializar o dispositivo.
    if FobjIndexSearch.ErrorCode <> NBioAPIERROR_NONE then
    begin
        if Assigned(FEventoStatus) then
          FEventoStatus('O módulo não foi inicializando corretamente, '+#13+'possívelmente não reconheceu o dispositivo conectado na entrada USB');
        raise Exception.Create('O módulo não foi inicializando corretamente, '+#13+'possívelmente não reconheceu o dispositivo conectado na entrada USB');
    end
    else
    begin
       if Assigned(FEventoStatus) then
          FEventoStatus('Módulo inicializado com sucesso.');
    end;
end;

destructor TNBioBSP.Destroy;
begin
  FobjDevice      := 0;
  FobjExtraction  := 0;
  FobjIndexSearch := 0;
  FobjNBioBSP     := 0;
  inherited;
end;

function TNBioBSP.GetDigitalCadastrada: string;
begin
   Result:=FDigitalCadastrada;
end;

function TNBioBSP.GetDigitalCapturada: string;
begin
   Result:=FDigitalCapturada;
end;

function TNBioBSP.GetIDUsuario: string;
begin
  Result:=FIDUsuario;
end;

function TNBioBSP.GetVersaoDoDriver: string;
begin
   Result:=FVersaoDoDriver;
end;

procedure TNBioBSP.InicializarDispositivo;
var
   strErro      : wideString;
begin
    if Assigned(FEventoStatus) then
        FEventoStatus('Iniciando o dispositivo.');
    Application.ProcessMessages;
    FobjDevice.Open(NBioAPI_DEVICE_ID_AUTO_DETECT) ;
    if FobjDevice.ErrorCode <> NBioAPIERROR_NONE then
    begin
        strErro := FobjDevice.ErrorDescription;
        raise Exception.Create('Falha ao abrir dispositivo.'+'menssagem de erro: '+strErro);
    end;
end;

class function TNBioBSP.New: IFingerKey;
begin
   Result:= TNBioBSP.create;
end;

function TNBioBSP.OnStatus(evento: TOnInitialization): IFingerKey;
begin
    Result:=Self;
    FEventoStatus:=evento;
end;

procedure TNBioBSP.SetDigitalCadastrada(const Value: string);
begin
  FDigitalCadastrada := Value;
end;

procedure TNBioBSP.SetIDUsuario(const Value: string);
begin
  FIDUsuario := Value;
end;

procedure TNBioBSP.VerificarDigital;
begin
   try
      InicializarDispositivo;
      if Assigned(FEventoStatus) then
          FEventoStatus('Verificando a digital...');
      Application.ProcessMessages;
      FobjExtraction.Capture(NBioAPI_FIR_PURPOSE_VERIFY);
      if FobjExtraction.ErrorCode = NBioAPIERROR_NONE then
      begin
          FobjDevice.Close(NBioAPI_DEVICE_ID_AUTO_DETECT);
          FDigitalCapturada := FobjExtraction.TextEncodeFIR;
          if Length(Trim(FDigitalCadastrada))>0 then
             FobjIndexSearch.AddFIR(FDigitalCadastrada, FIDUsuario);
          FobjIndexSearch.IdentifyUser(FDigitalCapturada, 5);
          if FobjIndexSearch.ErrorCode <> NBioAPIERROR_NONE then
          begin
             if Assigned(FEventoStatus) then
                FEventoStatus('Identiticação do usuário falhou.');
             raise Exception.Create('Identiticação do usuário falhou.');
          end;
          Application.ProcessMessages;
          if Assigned(FEventoStatus) then
             FEventoStatus('Digital verificada.');
      end
      else
      begin
          if Assigned(FEventoStatus) then
             FEventoStatus('A extração falhou.');
          raise Exception.Create('A extração falhou.');
      end;
   finally
       FobjDevice.Close(NBioAPI_DEVICE_ID_AUTO_DETECT);
   end;
end;

end.
