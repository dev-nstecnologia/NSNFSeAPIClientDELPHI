program NFSeAPIClientDelphi10_1;

uses
  Vcl.Forms,
  principal in 'principal.pas' {frmPrincipal},
  NFeAPI in 'NFSeAPI.pas',
  Vcl.Themes,
  Vcl.Styles,
  EnvioNFSe in 'Layouts\ABRASF\EnvioNFSe.pas',
  StatusProcessamentoReq in 'Layouts\StatusProcessamentoReq.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
