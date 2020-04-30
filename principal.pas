unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmPrincipal = class(TForm)
    Label6: TLabel;
    pgControl: TPageControl;
    formEmissao: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    btnEnviar: TButton;
    memoConteudoEnviar: TMemo;
    cbTpConteudo: TComboBox;
    chkExibir: TCheckBox;
    txtCNPJ: TEdit;
    GroupBox4: TGroupBox;
    memoRetorno: TMemo;
    txtIMCNPJ: TEdit;
    labelTokenEnviar: TLabel;
    cbTpAmb: TComboBox;
    Label3: TLabel;
    cbMunicipio: TComboBox;
    procedure btnEnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses NFSeAPI, System.JSON;

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
var
  retorno, statusEnvio, statusConsulta, statusDownload: String;
  cStat, nNF, chave, motivo, nsNRec, erros: String;
  jsonRetorno : TJSONObject;
begin

  if ((txtIMCNPJ.Text <> '') and
      (txtCNPJ.Text <> '') and
      (memoConteudoEnviar.Text <> '')) then
  begin

    memoRetorno.Lines.Clear;

    retorno := emitirNFSeSincrono(memoConteudoEnviar.Text, cbTpConteudo.Text,
    txtCNPJ.Text, txtIMCNPJ.Text, cbMunicipio.Text, cbTpAmb.Text, chkExibir.Checked);

    memoRetorno.Text := retorno;

    jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(retorno), 0) as TJSONObject;

	  statusEnvio := jsonRetorno.GetValue('statusEnvio').Value;
	  statusConsulta := jsonRetorno.GetValue('statusConsulta').Value;
    cStat := jsonRetorno.GetValue('cStat').Value;
    nNF := jsonRetorno.GetValue('nNFPref').Value;
    chave := jsonRetorno.GetValue('chave').Value;
    motivo := jsonRetorno.GetValue('motivo').Value;
	  nsNRec := jsonRetorno.GetValue('nsNRec').Value;

    //Aqui voce pode fazer uma validação para mostrar na tela as informações necessarias

    ShowMessage(motivo);
  end;
end;
end.
