unit NFSeAPI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdHTTP, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, ShellApi, IdCoderMIME, EncdDecd;

// Assinatura das fun��es
function enviaConteudoParaAPI(conteudoEnviar, url, tpConteudo: String; tpAmb: String = ''): String;

function emitirNFSeSincrono(conteudo, tpConteudo, CNPJ, im, municipio,
tpAmb: String; exibeNaTela: boolean = false): String;
function emitirNFSe(conteudo, tpConteudo, tpAmb, municipio: String): String;
function consultarStatusProcessamento(CNPJ, nsNRec, tpAmb, IM, municipio: String): String;
//Eventos
function cancelarNFSe(xml, municipio, tpAmb, caminho: String): String; Overload;
function cancelarNFSe(cnpj, im, municipio, cMun, codigo, nNF, tpAmb, caminho: String): String;  Overload;
function cancelarNFSe(conteudo, tpConteudo, municipio, tpAmb, caminho: String): String; Overload;

//Fun��es
function listarNSNRecs(cnpj, tpAmb: String; nRPS: String = ''; serieRPS: String = ''): String; Overload;
function listarNSNRecs(cnpj, tpAmb: String; nNF: String = ''): String; Overload;
function listarNSNRecs(json: String): String; Overload;

//Utilitarios
function salvarXML(xml, caminho, nome: String): String;
procedure gravaLinhaLog(conteudo: String);

implementation

uses
  System.json, StrUtils, System.Types, principal;

var
  tempoEspera: Integer = 600;
  token: String = 'SEU TOKEN';

// Fun��o gen�rica de envio para um url
function enviaConteudoParaAPI(conteudoEnviar, url, tpConteudo: String; tpAmb: String = ''): String;
var
  retorno: String;
  conteudo: TStringStream;
  HTTP: TIdHTTP;
  IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
begin
  conteudo := TStringStream.Create(conteudoEnviar, TEncoding.UTF8);
  HTTP := TIdHTTP.Create(nil);
  try
    if AnsiLowerCase(tpConteudo) = 'json' then
    begin
      HTTP.Request.ContentType := 'application/json';
    end
    else if AnsiLowerCase(tpConteudo) = 'xml' then
    begin
      HTTP.Request.ContentType := 'application/xml';
    end;

    IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HTTP.IOHandler := IdSSLIOHandlerSocketOpenSSL1;

    HTTP.Request.ContentEncoding := 'UTF-8';

    HTTP.Request.CustomHeaders.Values['X-AUTH-TOKEN'] := token;
    if(tpAmb <> '')then
    begin
      HTTP.Request.CustomHeaders.Values['tpAmb'] := tpAmb;
    end;

    try
      retorno := HTTP.Post(url, conteudo);
    except
      on E: EIdHTTPProtocolException do
        retorno := E.ErrorMessage;
      on E: Exception do
        retorno := E.Message;
    end;

  finally
    conteudo.Free();
    HTTP.Free();
  end;

  Result := retorno;
end;

// Esta fun��o emite uma NF-e de forma s�ncrona, fazendo o envio, a consulta e o download da nota
function emitirNFSeSincrono(conteudo, tpConteudo, CNPJ, im, municipio,
tpAmb: String; exibeNaTela: boolean = false): String;
var
  retorno, resposta, statusEnvio, statusConsulta, motivo, nsNRec,
  chave, cStat, nNF, pdf, xml, caminho: String;
  erro: TJSONValue;
  jsonRetorno, jsonAux: TJSONObject;
begin
  // Inicia as vari�veis vazias
  statusEnvio := '';
  statusConsulta := '';
  motivo := '';
  nsNRec := '';
  erro := TJSONString.Create('');
  chave := '';
  nNF := '';
  cStat := '';
  pdf := '';
  xml := '';
  caminho := '';

  resposta := emitirNFSe(conteudo, tpConteudo, tpAmb, municipio);
  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  statusEnvio := jsonRetorno.GetValue('status').Value;

  if (statusEnvio = '200') Or (statusEnvio = '-6')then
  begin

    nsNRec := jsonRetorno.GetValue('nsNRec').Value;

    sleep(tempoEspera);

    resposta := consultarStatusProcessamento(CNPJ, nsNRec, tpAmb, im, municipio);

    jsonRetorno := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(resposta), 0) as TJSONObject;
    statusConsulta := jsonRetorno.GetValue('status').Value;

    if (statusConsulta = '200') then
    begin

      cStat := jsonRetorno.GetValue('cStat').Value;

      if (cStat = '100') then
      begin

        chave := jsonRetorno.GetValue('chave').Value;
        motivo := jsonRetorno.GetValue('xMotivo').Value;
        nNF := jsonRetorno.GetValue('nNF').Value;
        pdf := jsonRetorno.GetValue('urlImpressao').Value;
        xml := jsonRetorno.GetValue('xml').Value;
        caminho := ExtractFilePath(GetCurrentDir) + CNPJ + '\xmls\';
        salvarXML(xml, caminho, chave + '-procNFSe.xml');
        if(exibeNaTela)then
        begin
            ShellExecute(Application.Handle, 'open', PChar(pdf),
            nil, nil, SW_SHOWMAXIMIZED);
        end;
      end
      else
      begin
        motivo := jsonRetorno.GetValue('xMotivo').Value;
      end;
    end
    else if(statusConsulta = '-2')then
    begin
      motivo := jsonRetorno.GetValue('xMotivo').Value;
    end
    else if(statusConsulta = '-400')then
    begin
      motivo := jsonRetorno.GetValue('motivo').Value;
    end;

  end
  else if (statusEnvio = '-999') Or (statusEnvio = '-5')then
  begin
    erro := jsonRetorno.Get('erro').JsonValue;
    jsonAux := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(erro.ToString), 0) as TJSONObject;
    cStat := jsonAux.GetValue('cStat').Value;
    motivo := jsonAux.GetValue('xMotivo').Value;
  end;

  retorno := '{' +
                  '"statusEnvio": "'    + statusEnvio    + '",'  +
                  '"statusConsulta": "' + statusConsulta + '",'  +
                  '"cStat": "'          + cStat          + '",'  +
                  '"nNFPref: "'         + nNF            + '",'  +
                  '"chave": "'          + chave          + '",'  +
                  '"nsNRec": "'         + nsNRec         + '",'  +
                  '"motivo": "'         + motivo         + '"'  +
             '}';

  gravaLinhaLog('[JSON_RETORNO]');
  gravaLinhaLog(retorno);
  gravaLinhaLog('');

  Result := retorno;
end;
// Emitir NF-e
function emitirNFSe(conteudo, tpConteudo, tpAmb, municipio: String): String;
var
  url, resposta: String;
begin
  //url := 'https://nfseapi.ns.eti.br/v1/' + municipio + '/emissao';
  url := 'http://nfseapihml.ns.eti.br/v1/' + municipio + '/emissao';

  gravaLinhaLog('[ENVIO_DADOS]');
  gravaLinhaLog(conteudo);

  resposta := enviaConteudoParaAPI(conteudo, url, tpConteudo, tpAmb);

  gravaLinhaLog('[ENVIO_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;
// Consultar Status de Processamento
function consultarStatusProcessamento(CNPJ, nsNRec, tpAmb, IM, municipio: String): String;
var
  json: String;
  url, resposta: String;
begin

  json := '{' +
              '"CNPJ": "'    + CNPJ   + '",' +
              '"nsNRec": "'  + nsNRec + '",' +
              '"IM": "'      + IM     + '"'  +
          '}';

  //url := 'https://nfseapi.ns.eti.br/v1/' + municipio + '/emissao/status';
  url := 'http://nfseapihml.ns.eti.br/v1/' + municipio + '/emissao/status';

  gravaLinhaLog('[CONSULTA_STATUS_PROCESSAMENTO_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[CONSULTA_STATUS_PROCESSAMENTO_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;

// Realizar o cancelamento da NF-e
function cancelarNFSe(xml, municipio, tpAmb, caminho: String): String; Overload;
begin

  Result := cancelarNFSe(xml, 'xml', municipio, tpAmb, caminho);

end;
function cancelarNFSe(cnpj, im, municipio, cMun, codigo, nNF, tpAmb, caminho: String): String;  Overload;
var
  json: String;
begin

  json := '{' +
              '"CNPJ": "'    + cnpj    + '",' +
              '"IM": "'      + im    + '",' +
              '"nNF": "'     + nNF + '",' +
              '"cMun": "'    + cMun    + '",' +
              '"codigo": "'  + codigo    + '"'  +
          '}';

  Result := cancelarNFSe(json, 'json', municipio, tpAmb, caminho);
end;
function cancelarNFSe(conteudo, tpConteudo, municipio, tpAmb, caminho: String): String;  Overload;
var
  url, resposta, status, cStat, xml, idEvento: String;
  retEvento: TJSONValue;
  jsonRetorno, jsonAux: TJSONObject;
begin
  url := 'https://nfseapi.ns.eti.br/v1/' + municipio + '/cancelar';

  gravaLinhaLog('[CANCELAMENTO_DADOS]');
  gravaLinhaLog(conteudo);

  resposta := enviaConteudoParaAPI(conteudo, url, tpConteudo, tpAmb);

  gravaLinhaLog('[CANCELAMENTO_RESPOSTA]');
  gravaLinhaLog(resposta);

  jsonRetorno := TJSONObject.ParseJSONValue(
    TEncoding.ASCII.GetBytes(resposta), 0)
    as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  if(status = '200')then
  begin

    retEvento := jsonRetorno.Get('retEvento').JsonValue;
    jsonAux := TJSONObject.ParseJSONValue(
      TEncoding.ASCII.GetBytes(retEvento.ToString), 0)
      as TJSONObject;
    cStat := jsonAux.GetValue('cStat').Value;

    if(cStat = '135')then
    begin
      xml := jsonAux.GetValue('xml').Value;
      idEvento := jsonAux.GetValue('idEvento').Value;
      salvarXML(xml, caminho, idEvento + '-procEvenNFSe.xml');
    end;
  end;

  Result := resposta;
end;

// Realiza a listagem de nsNRec vinculados a uma chave de NF-e
function listarNSNRecs(cnpj, tpAmb, nRPS, serieRPS: String): String; Overload;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin
  json := '{' +
              '"CNPJ": "'     + cnpj     + '",' +
              '"tpAmb": "'    + tpAmb    + '",' +
              '"nRPS": "'     + nRPS     + '",' +
              '"serieRPS": "' + serieRPS + '"'  +
          '}';

  resposta := listarNSNRecs(json);

  Result := resposta;
end;
function listarNSNRecs(cnpj, tpAmb, nNF: String): String; Overload;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin
  // Monta o Json
    json := '{' +
              '"CNPJ": "'  + cnpj   + '",' +
              '"tpAmb": "' + tpAmb  + '",' +
              '"nNF": "'   + nNF    + '"' +
          '}';

  resposta := listarNSNRecs(json);

  Result := resposta;
end;
function listarNSNRecs(json: String): String; Overload;
var
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin

  url := 'https://NFSe.ns.eti.br/util/list/nsnrecs';

  gravaLinhaLog('[LISTA_NSNRECS_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[LISTA_NSNRECS_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;

// Fun��o para salvar o XML de retorno
function salvarXML(xml, caminho, nome: String): String;
var
  arquivo: TextFile;
  conteudoSalvar, localParaSalvar: String;
begin
  // Seta o caminho para o arquivo XML
  localParaSalvar := caminho + nome;

  // Associa o arquivo ao caminho
  AssignFile(arquivo, localParaSalvar);
  // Abre para escrita o arquivo
  Rewrite(arquivo);

  // Copia o retorno
  conteudoSalvar := xml;
  // Ajeita o XML retirando as barras antes das aspas duplas
  conteudoSalvar := StringReplace(conteudoSalvar, '\"', '"',
    [rfReplaceAll, rfIgnoreCase]);

  // Escreve o retorno no arquivo
  Writeln(arquivo, conteudoSalvar);

  // Fecha o arquivo
  CloseFile(arquivo);
end;

// Grava uma linha no log
procedure gravaLinhaLog(conteudo: String);
var
  caminhoEXE, nomeArquivo, data: String;
  log: TextFile;
begin
  // Pega o caminho do execut�vel
  caminhoEXE := ExtractFilePath(GetCurrentDir);
  caminhoEXE := caminhoEXE + 'log\';

  // Pega a data atual
  data := DateToStr(Date);

  // Ajeita o XML retirando as barras antes das aspas duplas
  data := StringReplace(data, '/', '', [rfReplaceAll, rfIgnoreCase]);

  nomeArquivo := caminhoEXE + data;

  // Se diret�rio \log n�o existe, � criado
  if not DirectoryExists(caminhoEXE) then
    CreateDir(caminhoEXE);

  AssignFile(log, nomeArquivo + '.txt');
{$I-}
  Reset(log);
{$I+}
  if (IOResult <> 0) then
    Rewrite(log) { arquivo n�o existe e ser� criado }
  else
  begin
    CloseFile(log);
    Append(log); { o arquivo existe e ser� aberto para sa�das adicionais }
  end;

  Writeln(log, DateTimeToStr(Now) + ' - ' + conteudo);

  CloseFile(log);
end;

end.

