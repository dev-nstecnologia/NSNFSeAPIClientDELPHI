unit StatusProcessamentoReq;

interface
uses System.Json, REST.Json, REST.Json.Types;
type
  TStatusProcessamentoReq = class
  private
    [JSONName('CNPJ')]
    FCnpj: string;
    [JSONName('nsNRec')]
    FnsNRec: string;
    [JSONName('IM')]
    FIM: string;
  public
    function ToJsonString: string;
    property CNPJ: string read FCnpj write FCnpj;
    property nsNRec: string read FnsNRec write FnsNRec;
    property IM: string read FIM write FIM;
  end;
implementation

{ TStatusProcessamentoReq }

function TStatusProcessamentoReq.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self, [TJsonOption.joIgnoreEmptyStrings]);
end;

end.
