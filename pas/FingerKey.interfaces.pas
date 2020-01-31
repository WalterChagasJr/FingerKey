unit FingerKey.interfaces;

interface

type

TOnInitialization = procedure (status:string) of object;

IFingerKey = interface;

IFingerKey = interface
   ['{C430C784-E82C-4128-B546-34171793577A}']
    function GetVersaoBSP: string;
    function GetDigitalUsuario: string;
    function GetDigitalUsuarioCadastrato: string;
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

IFingerFactory = interface
   function FingerKey:IFingerKey;
end;

implementation

end.
