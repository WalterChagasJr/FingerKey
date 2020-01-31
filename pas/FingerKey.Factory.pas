unit FingerKey.Factory;

interface
uses
    system.SysUtils, FingerKey.interfaces;
type
TFingerFactory = class(TInterfacedObject, IFingerFactory)
  public
     class function New:IFingerFactory;
     constructor create;
     destructor Destroy; override;
     function FingerKey:IFingerKey;
end;

implementation

uses
  FingerKeyHamster.ENBioBSP;

{ TFingerFactory }

constructor TFingerFactory.create;
begin

end;

destructor TFingerFactory.Destroy;
begin

  inherited;
end;

function TFingerFactory.FingerKey: IFingerKey;
begin
   Result:=TFingerKeyHamster.New;
end;

class function TFingerFactory.New: IFingerFactory;
begin
   result:=TFingerFactory.create;
end;

end.
