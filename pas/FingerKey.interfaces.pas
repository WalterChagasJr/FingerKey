unit FingerKey.interfaces;

interface
uses
    Winapi.Windows;

type

TOnInitialization = procedure (status:string) of object;

IFingerKey = interface;

IFingerKey = interface
   ['{DCB570AF-AEE3-4191-85C8-8D23499EA49A}']
   function GetDigitalCapturada: string;
   function GetVersaoDoDriver: string;
   procedure SetIDUsuario(const Value: string);
   function GetIDUsuario: string;
   procedure SetDigitalCadastrada(const Value: string);
   function GetDigitalCadastrada: string;
   function OnStatus(evento:TOnInitialization):IFingerKey;
   procedure InicializarDispositivo;
   procedure CapturarDigital;
   procedure VerificarDigital;
   property DigitalCapturada:string read GetDigitalCapturada;
   property VersaoDoDriver:string read GetVersaoDoDriver;
   property IDUsuario:string read GetIDUsuario write SetIDUsuario;
   property DigitalCadastrada:string read GetDigitalCadastrada write SetDigitalCadastrada;
end;

IFingerFactory = interface
   function FingerKey:IFingerKey;
end;

implementation

end.
