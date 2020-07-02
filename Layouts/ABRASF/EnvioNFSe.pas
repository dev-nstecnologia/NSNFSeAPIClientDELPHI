unit Layouts.ABRASF.EnvioNFSe;

interface
uses System.Json, REST.Json, REST.Json.Types;
type

  TConstrucaoCivil = class
  private
    [JSONName('CodigoObra')]
    FCodObra: string;
    [JSONName('Art')]
    FArt: string;
  public
    property CodigoObra: string read FCodObra write FCodObra;
    property Art: string read FArt write FArt;
  end;

  TCpfCnpj = class
  private
    [JSONName('Cpf')]
    FCPF: String;
    [JSONName('Cnpj')]
    FCNPJ: String;
  public
    property Cpf: string read FCPF write FCPF;
    property Cnpj: string read FCNPJ write FCNPJ;
  end;

  TIntermediarioServico = class
  private
    [JSONName('RazaoSocial')]
    FRazaoSocial: string;
    [JSONName('CpfCnpj')]
    FPessoa: TCpfCnpj;
    [JSONName('InscricaoMunicipal')]
    FIM: string;
  public
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property CpfCnpj: TCpfCnpj read FPessoa write FPessoa;
    property InscricaoMunicipal: string read FIM write FIM;
  end;

  TContato = class
  private
    [JSONName('Telefone')]
    FTelefone: string;
    [JSONName('Email')]
    FEmail: string;
  public
    property Telefone: string read FTelefone write FTelefone;
    property Email: string read FEmail write FEmail;
  end;

  TEndereco = class
  private
    [JSONName('Endereco')]
    FEndereco: string;
    [JSONName('Numero')]
    FNumero: string;
    [JSONName('Complemento')]
    FComplemento: string;
    [JSONName('Bairro')]
    FBairro: string;
    [JSONName('CodigoMunicipio')]
    FCodMunicipio: Integer;
    [JSONName('Uf')]
    FUF: string;
    [JSONName('Cep')]
    FCEP: Integer;
  public
    property Endereco: string read FEndereco write FEndereco;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property CodigoMunicipio: Integer read FCodMunicipio write FCodMunicipio;
    property Uf: string read FUF write FUF;
    property Cep: Integer read FCEP write FCEP;
  end;

  TIdentificacaoTomador = class
  private
    [JSONName('CpfCnpj')]
    FPessoa: TCpfCnpj;
    [JSONName('InscricaoMunicipal')]
    FIM: string;
  public
    property CpfCnpj: TCpfCnpj read FPessoa write FPessoa;
    property InscricaoMunicipal: string read FIM write FIM;
  end;

  TTomador = class
  private
    [JSONName('IdentificacaoTomador')]
    FIdTomador: TIdentificacaoTomador;
    [JSONName('RazaoSocial')]
    FRazaoSocial: string;
    [JSONName('Endereco')]
    FEndereco: TEndereco;
    [JSONName('Contato')]
    FContato: TContato;
  public
    property IdentificacaoTomador: TIdentificacaoTomador read FIdTomador write FIdTomador;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Contato: TContato read FContato write FContato;
  end;

  TPrestador = class
  private
    [JSONName('Cnpj')]
    FCNPJ: string;
    [JSONName('InscricaoMunicipal')]
    FIM: string;
  public
    property Cnpj: string read FCNPJ write FCNPJ;
    property InscricaoMunicipal: string read FIM write FIM;
  end;

  TValores = class
  private
    [JSONName('ValorServicos')]
    FValorServicos: string;
    [JSONName('ValorDeducoes')]
    FValorDeducoes: string;
    [JSONName('ValorPis')]
    FValorPis: string;
    [JSONName('ValorCofins')]
    FValorCofins: string;
    [JSONName('Valorinss')]
    FValorinss: string;
    [JSONName('ValorIr')]
    FValorIr: string;
    [JSONName('ValorCsll')]
    FValorCsll: string;
    [JSONName('IssRetido')]
    FIssRetido: Integer;
    [JSONName('ValorIss')]
    FValorIss: string;
    [JSONName('OutrasRetencoes')]
    FOutrasRet: string;
    [JSONName('BaseCalculo')]
    FBaseCal: string;
    [JSONName('Aliquota')]
    FAliq: string;
    [JSONName('ValorLiquidoNfse')]
    FValorLiqNFSe: string;
    [JSONName('ValorIssRetido')]
    FValorIssRet: string;
    [JSONName('DescontoCondicionado')]
    FDescCond: string;
    [JSONName('DescontoIncondicionado')]
    FDescInc: string;


  public
    property ValorServicos: string read FValorServicos write FValorServicos;
    property ValorDeducoes: string read FValorDeducoes write FValorDeducoes;
    property ValorPis: string read FValorPis write FValorPis;
    property ValorCofins: string read FValorCofins write FValorCofins;
    property Valorinss: string read FValorinss write FValorinss;
    property ValorIr: string read FValorIr write FValorIr;
    property ValorCsll: string read FValorCsll write FValorCsll;
    property IssRetido: Integer read FIssRetido write FIssRetido;
    property ValorIss: string read FValorIss write FValorIss;
    property ValorIssRetido: string read FValorIssRet write FValorIssRet;
    property OutrasRetencoes: string read FOutrasRet write FOutrasRet;
    property BaseCalculo: string read FBaseCal write FBaseCal;
    property Aliquota: string read FAliq write FAliq;
    property ValorLiquidoNfse: string read FValorLiqNFSe write FValorLiqNFSe;
    property DescontoCondicionado: string read FDescCond write FDescCond;
    property DescontoIncondicionado: string read FDescInc write FDescInc;
  end;

  TServico = class
  private
    [JSONName('Valores')]
    FValores: TValores;
    [JSONName('ItemListaServico')]
    FItemListaServico: string;
    [JSONName('CodigoCnae')]
    FCodCNAE: Integer;
    [JSONName('CodigoTributacaoMunicipio')]
    FCodTribMun: string;
    [JSONName('Discriminacao')]
    FDiscriminacao: string;
    [JSONName('CodigoMunicipio')]
    FCodMun: Integer;
  public
    property Valores: TValores read FValores write FValores;
    property ItemListaServico: string read FItemListaServico write FItemListaServico;
    property CodigoCnae: Integer read FCodCNAE write FCodCNAE;
    property CodigoTributacaoMunicipio: string read FCodTribMun write FCodTribMun;
    property Discriminacao: string read FDiscriminacao write FDiscriminacao;
    property CodigoMunicipio: Integer read FCodMun write FCodMun;
  end;

  TRpsSubstituido = class
  private
    [JSONName('Numero')]
    FNumero: Integer;
    [JSONName('Serie')]
    FSerie: Integer;
    [JSONName('Tipo')]
    FTipo: Integer;
  public
    property Tipo: Integer read FTipo write FTipo;
    property Serie: Integer read FSerie write FSerie;
    property Numero: Integer read FNumero write FNumero;
  end;

  TIdentificacaoRps = class
  private
    [JSONName('Numero')]
    FNumero: Integer;
    [JSONName('Serie')]
    FSerie: Integer;
    [JSONName('Tipo')]
    FTipo: Integer;
  public
    property Tipo: Integer read FTipo write FTipo;
    property Serie: Integer read FSerie write FSerie;
    property Numero: Integer read FNumero write FNumero;
  end;

  TInfRps = class
  private
    [JSONName('IdentificacaoRps')]
    FIdentificacaoRps: TIdentificacaoRps;
    [JSONName('DataEmissao')]
    FDataEmissao: string;
    [JSONName('NaturezaOperacao')]
    FNaturezaOperacao: Integer;
    [JSONName('RegimeEspecialTributacao')]
    FRegimeEspecialTributacao: Integer;
    [JSONName('OptanteSimplesNacional')]
    FOptanteSimplesNacional: Integer;
    [JSONName('IncentivadorCultural')]
    FIncentivadorCultural: Integer;
    [JSONName('Status')]
    FStatus: Integer;
    [JSONName('RpsSubstituido')]
    FRpsSubstituido: TRpsSubstituido;
    [JSONName('Servico')]
    FServico: TServico;
    [JSONName('Prestador')]
    FPrestador: TPrestador;
    [JSONName('Tomador')]
    FTomador: TTomador;
    [JSONName('InterServico')]
    FInterServico: TIntermediarioServico;
    [JSONName('ConstrucaoCivil')]
    FConstrucaoCivil: TConstrucaoCivil;
  public
    property IdentificacaoRps: TIdentificacaoRps read FIdentificacaoRps write FIdentificacaoRps;
    property DataEmissao: string read FDataEmissao write FDataEmissao;
    property NaturezaOperacao: Integer read FNaturezaOperacao write FNaturezaOperacao;
    property RegimeEspecialTributacao: Integer read FRegimeEspecialTributacao write FRegimeEspecialTributacao;
    property OptanteSimplesNacional: Integer read FOptanteSimplesNacional write FOptanteSimplesNacional;
    property IncentivadorCultural: Integer read FIncentivadorCultural write FIncentivadorCultural;
    property Status: Integer read FStatus write FStatus;
    property RpsSubstituido: TRpsSubstituido read FRpsSubstituido write FRpsSubstituido;
    property Servico: TServico read FServico write FServico;
    property Prestador: TPrestador read FPrestador write FPrestador;
    property Tomador: TTomador read FTomador write FTomador;
    property IntermediarioServico: TIntermediarioServico read FInterServico write FInterServico;
    property ConstrucaoCivil: TConstrucaoCivil read FConstrucaoCivil write FConstrucaoCivil;
  end;

  TRps = class
  private
    [JSONName('InfRps')]
    FInfRps: TInfRps;
  public
    property InfRps: TInfRps read FInfRps write FInfRps;
  end;

  TEnvioNFSe = class
  private
    [JSONName('Rps')]
    FRps: TRps;
  public
    function ToJsonString: string;
    property Rps: TRps read FRps write FRps;
  end;

implementation

{ TNFSeCanoas }

function TEnvioNFSe.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self, [TJsonOption.joIgnoreEmptyStrings]);
end;

end.
