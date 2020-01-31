unit FingerKeyHamster.ENBioBSP;

interface

uses
   BSPInter,
   NBioAPI_Type,
   Vcl.Forms,
   system.SysUtils,
   system.Classes,
   Winapi.Windows,
   FingerKey.interfaces;

type
TFingerKeyHamster = class(TInterfacedObject, IFingerKey)
   private
    //Variáveis de controle
    FDispositivoConectado:Boolean;
    m_DeviceID   : WORD;
    m_DataType   : DWORD;
    m_init_info0 : NBioAPI_INIT_INFO_0;
    m_hFIR       : DWORD;
    m_FullFIR      : NBioAPI_FIR;
    m_BinaryStream : array of BYTE;
    m_TextFIR      : NBioAPI_FIR_TEXTENCODE;
    m_TextStream   : array of Char;
    //=====================================
    FVersaoBSP:string;
    FListaDispositivos:TStringlist;
    FDigitalUsuarioCadastrato:string;
    FDigitalUsuario:string;
    FCodigoUsuario:string;
    FEventoInitialization:TOnInitialization;
    procedure InitInformation;
    Procedure DisplayDeviceList;
    Procedure MakeStreamFromFIR;
    Procedure MakeStreamFromTextFIR;
    Procedure MakeFIRFromStream(pBinaryStream : array of BYTE; pFullFIR : NBioAPI_FIR_PTR);
    Procedure MakeTextFIRFromStream(pTextFIR : NBioAPI_FIR_TEXTENCODE_PTR);
    function GetDigitalUsuario: string;
    function GetDigitalUsuarioCadastrato: string;
    function GetVersaoBSP: string;
   public
    class function New:IFingerKey;
    constructor create;
    destructor Destroy; override;
    function InicializarBSP:Boolean;
    procedure FinalizarBSP;
    function AbrirDispositivoBSP:Boolean;
    function CadastrarDigital(usuario:string):Boolean;
    function VerificarDigital(CodigoUsuario:string):Boolean;
    function OnEventoInitialization(value:TOnInitialization):IFingerKey;
    property VersaoBSP:string read  GetVersaoBSP;
    property DigitalUsuarioCadastrado:string read GetDigitalUsuarioCadastrato;
    property DigitalUsuario:string read GetDigitalUsuario;

end;

implementation

{ TFingerKeyHamster }

function TFingerKeyHamster.AbrirDispositivoBSP:Boolean;
var
    openedDeviceID : WORD;
    tempDeviceName : String;
    p : integer;
    id : integer;
begin

    Result:=false;
    FDispositivoConectado:=false;
    openedDeviceID := NBioAPI_DEVICE_ID_AUTO_DETECT;
    tempDeviceName := '';
    p := Pos(' (ID:', FListaDispositivos[0]);

    if p > 0 then
      tempDeviceName := Copy(FListaDispositivos[0], 1, p - 1);

    if tempDeviceName = 'Auto_Detect' then
       openedDeviceID := NBioAPI_DEVICE_ID_AUTO_DETECT
    else
    if tempDeviceName = 'FDP02' then
       openedDeviceID := NBioAPI_DEVICE_ID_FDP02_0
    else
    if tempDeviceName = 'FDU01' then
       openedDeviceID := NBioAPI_DEVICE_ID_FDU01_0
    else
    if tempDeviceName = 'OSU02' then
       openedDeviceID := NBioAPI_DEVICE_ID_OSU02_0
    else
    if tempDeviceName = 'FDU11' then
       openedDeviceID := NBioAPI_DEVICE_ID_FDU11_0
    else
    if tempDeviceName = 'FSC01' then
        openedDeviceID := NBioAPI_DEVICE_ID_FSC01_0
    else
    if tempDeviceName = 'FDU03' then
        openedDeviceID := NBioAPI_DEVICE_ID_FDU03_0
    else
    if tempDeviceName = 'FDU05' then
        openedDeviceID := NBioAPI_DEVICE_ID_FDU05_0
    else
    if tempDeviceName = 'FDU08' then
       openedDeviceID := NBioAPI_DEVICE_ID_FDU08_0;
    //Close Device
    CloseDevice(m_DeviceID);
    if p > 0 then
    begin
        id := StrToInt(Copy(FListaDispositivos[0], p + 5, 1));
        openedDeviceID := openedDeviceID + (id * $100);
    end;
    //Open Device
    Application.ProcessMessages;
    if Assigned(FEventoInitialization) then
       FEventoInitialization('Conectando com o dispositivo de forma automática.');
    m_DeviceID := openedDeviceID;
    if OpenDevice(openedDeviceID) = NBioAPIERROR_NONE then
    begin
        Application.ProcessMessages;
        if Assigned(FEventoInitialization) then
           FEventoInitialization('Dispositivo conectado com sucesso.');
        Result:=True;
        FDispositivoConectado:=True;
    end
    else
       raise Exception.Create('Falha ao abrir o dispositivo.');
end;

function TFingerKeyHamster.CadastrarDigital(usuario: string): Boolean;
var
    payload  : NBioAPI_FIR_PAYLOAD;
    Err      : DWORD;
    lnLength : LongInt;
begin
    FCodigoUsuario:=usuario;
    Result:=False;
    if not FDispositivoConectado then
    begin
       try
          InicializarBSP;
          AbrirDispositivoBSP;
       Except
          on E:Exception do
          begin
             raise Exception.Create(E.Message);
          end;
       end;
    end;
    if m_hFIR <> 0 then
       FreeFIRHandle(m_hFIR);
    if FCodigoUsuario = '' then
    begin

       if Assigned(FEventoInitialization) then
           FEventoInitialization('Capturando digital do usuário');
       Err := Enroll(@m_hFIR, nil, m_init_info0.DefaultTimeout, nil);
    end
    else
    begin
        Application.ProcessMessages;
        if Assigned(FEventoInitialization) then
           FEventoInitialization('Capturando digital do usuário');
        payload.Length := Length(FCodigoUsuario) + 1;
        SetLength(payload.Data, payload.Length);
        CopyMemory(payload.Data, PChar(FCodigoUsuario), payload.Length);
        Err := Enroll(@m_hFIR, @payload, m_init_info0.DefaultTimeout, nil);
    end;
    if Err = NBioAPIERROR_NONE then
    begin
        Application.ProcessMessages;
        if Assigned(FEventoInitialization) then
           FEventoInitialization('Digital do usuário capturada com sucesso');
        //m_DataType = 1
        //Get full fir from handle.
        FreeFIR(@m_FullFIR);
        GetFullFIR(m_hFIR, @m_FullFIR);
        //m_DataType = 2
        //Get binary stream from handle.
        lnLength := GetFirLength(m_hFIR);
        SetLength(m_BinaryStream, lnLength);
        MakeStreamFromFIR;
        //m_DataType = 4
        //Get text fir from handle
        FreeTextFIR(@m_TextFIR);
        GetTextFIR(m_hFIR, @m_TextFIR);
        FDigitalUsuarioCadastrato:=m_TextFIR.TextFIR;
        //m_DataType = 3
        //Get text stream from
        SetLength(m_TextStream, StrLen(m_TextFIR.TextFIR));
        MakeStreamFromTextFIR;
        Result:=True;
    end;
end;

constructor TFingerKeyHamster.create;
begin
    FListaDispositivos:=TStringlist.Create;;
end;

destructor TFingerKeyHamster.Destroy;
begin
  FreeAndNil(FListaDispositivos);
  inherited;
end;

procedure TFingerKeyHamster.DisplayDeviceList;
var
    Err            : DWORD;
    i              : Integer;
    dDevice_count  : DWORD;
    nHighByte      : Char;
    nLowByte       : Char;
begin
    Application.ProcessMessages;
    if Assigned(FEventoInitialization) then
       FEventoInitialization('Listando os dispositivos...');
    FListaDispositivos.add('Auto_Detect');
    Err := EunmerateDevice(@dDevice_count);
    if (Err = NBioAPIERROR_NONE) and (dDevice_count > 0) then
    begin
        for i := 0 to (dDevice_count - 1) do
        begin
            nHighByte := (g_aDevice_list + (2*i) + 1)^;
            nLowByte  := (g_aDevice_list + (2*i))^;
            case Integer(nLowByte) of
                NBioAPI_DEVICE_ID_FDP02_0 :  FListaDispositivos.add('FDP02 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_FDU01_0 :  FListaDispositivos.add('FDU01 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_OSU02_0 :  FListaDispositivos.add('OSU02 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_FDU11_0 :  FListaDispositivos.add('FDU11 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_FSC01_0 :  FListaDispositivos.add('FSC01 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_FDU03_0 :  FListaDispositivos.add('FDU03 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_FDU05_0 :  FListaDispositivos.add('FDU05 (ID:' + IntToStr(integer(nHighByte)) + ')');
                NBioAPI_DEVICE_ID_FDU08_0 :  FListaDispositivos.add('FDU08 (ID:' + IntToStr(integer(nHighByte)) + ')');
            end;
        end;
    end;
end;

procedure TFingerKeyHamster.FinalizarBSP;
begin
   Application.ProcessMessages;
   if Assigned(FEventoInitialization) then
       FEventoInitialization('Encerrando a conexão com o dispotivo.');
   CloseDevice(m_DeviceID);
   FreeFIRHandle(m_hFIR);
   FreeFIR(@m_FullFIR);
   TerminateNBioAPI;
   //FreeLibrary - 'NBioBSP.dll'
   try
       FreeLibrary(g_hwnd);
       FDispositivoConectado:=false;
       if Assigned(FEventoInitialization) then
           FEventoInitialization('Dispositivo desconectado com sucesso.');
   except
      on e: exception do
      begin
         FDispositivoConectado:=false;
      end;
   end;
end;

function TFingerKeyHamster.GetDigitalUsuario: string;
begin
   Result:=FDigitalUsuario;
end;

function TFingerKeyHamster.GetDigitalUsuarioCadastrato: string;
begin
   Result:=FDigitalUsuarioCadastrato;
end;

function TFingerKeyHamster.GetVersaoBSP: string;
begin
   Result:=FVersaoBSP;
end;

function TFingerKeyHamster.InicializarBSP:Boolean;
begin
    Result:=false;
    g_hwnd := 0;
    m_hFIR := 0;
    try
       Application.ProcessMessages;
       if Assigned(FEventoInitialization) then
          FEventoInitialization('Carregando a biblioteca NBioBSP.dll');
       g_hwnd := LoadLibrary('NBioBSP.dll');
    except
       on e: exception do
    end;
    if (g_hwnd <> 0) then
    begin
        Application.ProcessMessages;
        if Assigned(FEventoInitialization) then
            FEventoInitialization('Carregando as funções da DLL...');
        LoadNBioBSPFunctions;
        IsValidModule;
        Application.ProcessMessages;
        if Assigned(FEventoInitialization) then
            FEventoInitialization('inicializando a API');
        InitNBioAPI;
        FreeFIR(@m_FullFIR);
        m_DeviceID := NBioAPI_DEVICE_ID_AUTO_DETECT;
        m_DataType := 4; //Text FIR
       // m_DataType := 0; // handle
        //Data Initialized
        InitInformation;
        Result:=True;
    end
    else
    begin
        raise Exception.Create('Erro ao carregar a biblioteca NBioBSP.dll');
    end;
end;

procedure TFingerKeyHamster.InitInformation;
begin
    if GetBSPVersion = NBioAPIERROR_NONE then
    begin
        FVersaoBSP:= Format(' - BSP Version : v%.4f', [g_bsp_ver.Major + g_bsp_ver.Minor/10000]);
    end;
    DisplayDeviceList;
end;

procedure TFingerKeyHamster.MakeFIRFromStream(pBinaryStream: array of BYTE;
  pFullFIR: NBioAPI_FIR_PTR);
begin
    CopyMemory(@pFullFIR.Format, @(pBinaryStream[0]), sizeof(DWORD));
    CopyMemory(@pFullFIR.Header, @(pBinaryStream[sizeof(DWORD)]), sizeof(pFullFIR.Header));
    SetLength(pFullFIR.Data, pFullFIR.Header.DataLength);
    CopyMemory(pFullFIR.Data, @(pBinaryStream[sizeof(pFullFIR.Format) + pFullFIR.Header.Length]), pFullFIR.Header.DataLength);
end;

procedure TFingerKeyHamster.MakeStreamFromFIR;
begin
    CopyMemory(@(m_BinaryStream[0]), @m_FullFIR.Format, sizeof(m_FullFIR.Format));
    CopyMemory(@(m_BinaryStream[sizeof(m_FullFIR.Format)]), @m_FullFIR.Header, m_FullFIR.Header.Length);
    CopyMemory(@(m_BinaryStream[sizeof(m_FullFIR.Format) + m_FullFIR.Header.Length]), m_FullFIR.Data, m_FullFIR.Header.DataLength);
end;

procedure TFingerKeyHamster.MakeStreamFromTextFIR;
begin
   CopyMemory(@m_TextStream[0], m_TextFIR.TextFIR, sizeof(m_TextFIR.TextFIR));
end;

procedure TFingerKeyHamster.MakeTextFIRFromStream(
  pTextFIR: NBioAPI_FIR_TEXTENCODE_PTR);
begin
   pTextFIR.IsWideChar := False;
   GetMem(pTextFIR.TextFIR, Length(m_TextStream));
   CopyMemory(pTextFIR.TextFIR, @m_TextStream[0], sizeof(m_TextStream));
end;

class function TFingerKeyHamster.New: IFingerKey;
begin
   Result:=TFingerKeyHamster.create;
end;

function TFingerKeyHamster.OnEventoInitialization(
  value: TOnInitialization): IFingerKey;
begin
   Result:=Self;
   FEventoInitialization:=value;
end;

function TFingerKeyHamster.VerificarDigital(CodigoUsuario:string): Boolean;
var
    input_fir : NBioAPI_INPUT_FIR;
    bValue    : BOOL;
    payload   : NBioAPI_FIR_PAYLOAD;
    fullFIR   : NBioAPI_FIR;
    textFIR   : NBioAPI_FIR_TEXTENCODE;
    Err       : DWORD;
begin
    Result:=False;
    FDigitalUsuario :='';
    bValue   := True;
    if not FDispositivoConectado then
    begin
       try
          InicializarBSP;
          AbrirDispositivoBSP;
       Except
          on E:Exception do
          begin
             raise Exception.Create(E.Message);
          end;
       end;
    end;
    if m_hFIR = 0 then
       raise Exception.Create('Não foi possível encontrar a impressão digital registrada!');
    case m_DataType of
        0 : //Handle in BSP
        begin
                input_fir.Form              := NBioAPI_FIR_FORM_HANDLE;
                input_fir.InputFir.FIRinBSP := @m_hFIR;
        end;
        1 : //Full FIR
        begin
                input_fir.Form          := NBioAPI_FIR_FORM_FULLFIR;
                input_fir.InputFIR.FIR  := @m_FullFIR;
        end;
        2 : //Binary Data
        begin
                FreeFIR(@fullFIR);
                MakeFIRFromStream(m_BinaryStream, @fullFIR);

                input_fir.Form          := NBioAPI_FIR_FORM_FULLFIR;
                input_fir.InputFIR.FIR  := @fullFIR;
        end;
        3 : //Text Encoded Data
        begin
                MakeTextFIRFromStream(@textFIR);

                input_fir.Form          := NBioAPI_FIR_FORM_TEXTENCODE;
                input_fir.InputFIR.FIR  := @textFIR;
        end;
        4 : //Text FIR
        begin
                input_fir.Form          := NBioAPI_FIR_FORM_TEXTENCODE;
                input_fir.InputFIR.FIR  := @m_TextFIR;
        end;
    end;
    Application.ProcessMessages;
    if Assigned(FEventoInitialization) then
       FEventoInitialization('Verificando digita do usuário...');
    Err := Verify(input_fir, @bValue, @payload, m_init_info0.DefaultTimeout, nil);
    if Err = NBioAPIERROR_NONE then
    begin
        //CopyMemory(PChar(CodigoUsuario), payload.Data, payload.Length);
        if bValue = boolean(NBioAPI_TRUE) then
        begin
            if (payload.Length > 0) then
            begin
                case m_DataType of
                   4:
                   begin
                       FDigitalUsuario:= m_TextFIR.TextFIR;
                   end;
                end;
                FreePayload(@payload);
            end;
            Application.ProcessMessages;
            if Assigned(FEventoInitialization) then
               FEventoInitialization('Verificação realizada com sucesso.');
            result:=True;
        end
        else
           raise Exception.Create('Falha na verificação');
    end
    else
       raise Exception.Create('Falha na verificação');
end;

end.
