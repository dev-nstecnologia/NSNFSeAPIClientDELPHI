# NSNFSeAPIClientDELPHI

Esta página apresenta trechos de códigos de um módulo em Delphi 10 desenvolvido com o intuito de consumir as funcionalidades da NS NFS-e API.

-------

## Primeiros passos:

### Integrando ao sistema:

Para utilizar as funções de comunicação com a API, você precisa realizar os seguintes passos:

1. Extraia o conteúdo da pasta compactada que você baixou;
2. Copie para a pasta da sua aplicação a classe **NFSeAPI.pas**, que esta na pasta raiz;
3. Abra o seu projeto e importe a pasta copiada.
4.A aplicação utiliza as bibliotecas **Indy 10** e **System.JSON** para realizar a comunicação com a API e fazer a manipulação de dados JSON, respectivamente. As referências já estão referenciadas na classe.

**OBS.:** Caso ocorra erro ao compilar o projeto(Could Not Load SSL Library), pode significar que o mesmo não possua, em sua pasta Debug, duas dlls essenciais para a execução do código. Veja mais informações de como resolver o problema neste post do nosso blog: [Erro de SSL](https://nstecnologia.com.br/blog/could-not-load-ssl-library/)

**Pronto!**  Agora, você já pode consumir a NS NFS-e API através do seu sistema. Todas as funcionalidades de comunicação foram implementadas na classe NFeAPI.pas. Confira abaixo sobre realizar uma emissão completa.

------

## Emissão Sincrona:

### Realizando uma Emissão:

Para realizar uma emissão completa, você poderá utilizar a função emitirNFSeSincrono do módulo NFSeAPI. Veja abaixo sobre os parâmetros necessários, e um exemplo de chamada do método.

#### Parâmetros:

**ATENÇÃO:** o **token** também é um parâmetro necessário e você deve primeiramente defini-lo no módulo NFSeAPI.pas estaticamente. Ele é uma constante do módulo localizado no inicio do mesmo. 

![image](https://user-images.githubusercontent.com/54732019/80749107-59ba6180-8afc-11ea-87cc-cbcc3d246d77.png)


Parametros     | Descrição
:-------------:|:-----------
conteudo       | Conteúdo de emissão da NFS-e.
tpConteudo     | Tipo de conteúdo que está sendo enviado. Valores possíveis: JSON ou XML
CNPJ           | CNPJ do emitente do documento.
IM             | A incrição municipal ligada ao CNPJ. 
municipio      | Municipio da NFS-e
tpAmb          | Ambiente onde foi autorizado o documento.Valores possíveis:<ul> <li>1 - produção</li> <li>2 - homologação</li> </ul>
caminho        | Caminho onde devem ser salvos os xmls baixados.
exibeNaTela    | Se deseja exibir o pdf na tela para que o mesmo seja visualizado e baixado. Valores possíveis: <ul> <li>**True** - será exibido</li> <li>**False** - não será exibido</li> </ul> 

#### Serializando JSON de Emissão NFS-e:

Para conseguir criar um json de emissão de maneira mais pratica e mais rapida, foi desenvolvido pela nossa equipe uma serie de classes para serialização. Estas unidades se encontram dentro do diretorio 'Layouts', o qual esta sub-dividido em pastas de schemas adotados por cada municipio. Temos atualmente:
 
Layout   | Municipios 
:-------:|:-----------
ABRASF   | <ul><li>Canoas</li></ul> 

Dessa forma, para que consigamos demostrar uma serialização de JSON iremos utilizar o Layout ABRASF facilitando a geração de um arquivo de emissão. Veja uma function de geração do Layout escolhido: 

	{As informações utilizadas são meramente ilustrativas, você deve preencher com as informações corretas do serviço prestado}
	function LayoutABRASFCreate(): string;
	var
	  nfseABRASF: TEnvioNFSe;
	  rps: TRps;
	  infRps: TInfRps;
	  ide: TIdentificacaoRps;
	  subst: TRpsSubstituido;
	  servico: TServico;
	  valores: TValores;
	  prestador : TPrestador;
	  tomador: TTomador;
	  ideTomador: TIdentificacaoTomador;
	  pessoaTomador: TCpfCnpj;
	  endereco: TEndereco;
	  contato: TContato;
	  interServico: TIntermediarioServico;
	  pessoaInter: TCpfCnpj;
	  consCivil: TConstrucaoCivil;
	  jObject: TJSONObject;

	begin
	  nfseABRASF := TEnvioNFSe.Create;

	  try
		rps := TRps.Create;
		  infRps := TInfRps.Create;
			infRps.DataEmissao := '2020-04-30T14:10:00';
			infRps.NaturezaOperacao := 1;
			infRps.RegimeEspecialTributacao := 2;
			infRps.OptanteSimplesNacional := 2;
			infRps.IncentivadorCultural := 2;
			infRps.Status := 1;

			{Identificação RPS}
			ide := TIdentificacaoRps.Create;
			  ide.Numero := 1;
			  ide.Serie := 1;
			  ide.Tipo := 1;
			infRps.IdentificacaoRps:= ide;

			{Identificação do RPS Substituido}
			subst := TRpsSubstituido.Create;
			  subst.Numero := 1;
			  subst.Serie := 1;
			  subst.Tipo := 1;
			infRps.RpsSubstituido := subst;

			{Informações do Serviço Prestado}
			servico := TServico.Create;
			  {Valores do Serviço Prestado}
			  valores := TValores.Create;
				valores.ValorServicos := '1200.00';
				valores.ValorDeducoes := '0.00';
				valores.ValorPis := '0.00';
				valores.ValorCofins := '0.00';
				valores.ValorInss := '0.00';
				valores.ValorIr := '0.00';
				valores.ValorCsll := '0.00';
				valores.IssRetido := 1;
				valores.ValorIss := '60.00';
				valores.ValorIssRetido := '60.00';
				valores.OutrasRetencoes := '0.00';
				valores.BaseCalculo := '1200.00';
				valores.Aliquota := '0.05';
				valores.ValorLiquidoNfse := '1140.00';
				valores.DescontoIncondicionado := '0.00';
				valores.DescontoCondicionado := '0.00';
			  servico.Valores := valores;
			  servico.ItemListaServico := '99999';
			  servico.CodigoCnae := 9999999;
			  servico.CodigoTributacaoMunicipio := '9999';
			  servico.Discriminacao := 'Exemplo';
			  servico.CodigoMunicipio := 9999999;
			infRps.Servico := servico;

			{Informações do Prestador do Serviço}
			prestador := TPrestador.Create;
			  prestador.Cnpj := '99999999999999';
			  prestador.InscricaoMunicipal := '0';
			infRps.Prestador := prestador;

			{Informações do Tomador do Serviço}
			tomador := TTomador.Create;
			  tomador.RazaoSocial := 'Razão Social Tomador';
			  ideTomador := TIdentificacaoTomador.Create;
				ideTomador.InscricaoMunicipal := '999999999999999';
				pessoaTomador := TCpfCnpj.Create;
				  pessoaTomador.Cpf := '99999999999';
				ideTomador.CpfCnpj := pessoaTomador;
			  tomador.IdentificacaoTomador := ideTomador;
			  {Endereço do Tomador do Serviço}
			  endereco := TEndereco.Create;
				endereco.Endereco := 'Av. Exemplo';
				endereco.Numero := '1';
				endereco.Bairro := 'Exemplo';
				endereco.CodigoMunicipio := 9999999;
				endereco.Uf := 'RS';
				endereco.Cep := 99999999;
			  tomador.Endereco := endereco;
			  {Contato do Tomador do Serviço}
			  contato := TContato.Create;
				contato.Telefone := '99999999999';
				contato.Email := 'exemplo@exemplo.com';
			  tomador.Contato := contato;
			infRps.Tomador := tomador;

			{Informaçãoes do Intermediario do Serviço}
			  interServico := TIntermediarioServico.Create;
				interServico.RazaoSocial := 'Razão Social Intermediario';
				interServico.InscricaoMunicipal := '999999999999999';
				pessoaInter := TCpfCnpj.Create;
				  pessoaInter.Cpf := '99999999999';
				interServico.CpfCnpj := pessoaInter;
			  infRps.IntermediarioServico := interServico;

			{Identificação da Constução Civil}
			consCivil:= TConstrucaoCivil.Create;
			  consCivil.CodigoObra := '999999999999999';
			  consCivil.Art := '999999999999999';
			infRps.ConstrucaoCivil := consCivil;

		  rps.InfRps := infRps;
		nfseABRASF.Rps := rps;

		Result := nfseABRASF.ToJsonString();

	  finally
		nfseABRASF.Free;
	  end;
	end;

#### Exemplo de chamada:

Após ter serializado em JSON sua NFS-e e você pode chamar a function **emitirNFSeSincrono**, completando todos os parâmetros listados acima
    
	conteudo := LayoutABRASFCreate();
	tpConteudo := 'json'; 
	CNPJEmit := '99999999999999';
	IM := '999999999999999';
	municipio := 'canoas';
	tpAmb := '2';
	exibirPDF := True;
	
    retorno := emitirNFSeSincrono(conteudo, tpConteudo, CNPJEmit, IM, municipio, tpAmb, exibirPDF);
    ShowMessage(retorno);

O código acima fará o envio, a consulta e download do documento, utilizando as funções emitirNFSe, consultarStatusProcessamento e downloadNFSeESalvar, presentes no módulo NFSeAPI.pas. Por isso, o retorno será um JSON com os principais campos retornados pelos métodos citados anteriormente. No exemplo abaixo, veja como tratar o retorno da função emitirNFeSincrono:

#### Exemplo de tratamento de retorno:

O JSON retornado pelo método terá os seguintes campos: statusEnvio, statusConsulta, cStat, nNFPref, chave, nsNRec e motivo. Veja o exemplo abaixo:

    {
        "statusEnvio": "200",
        "statusConsulta": "200",
        "cStat": "100",
		"nNFPref": "128", 
        "chave": "128",
		"nsNRec": "300",
        "motivo": "Documento Autorizado com Sucesso",
		"pdfNFSe": "https://enfs-hom.abaco.com.br/canoas/..."      
    }
      
Confira um código para tratamento do retorno, no qual pegará as informações dispostas no JSON de Retorno disponibilizado:

    retorno := emitirNFSeSincrono(conteudo, 'json', '999999999999999', '999999999999999', 'canoas', '2', True);

    jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(retorno), 0) as TJSONObject;

	statusEnvio := jsonRetorno.GetValue('statusEnvio').Value;
	statusConsulta := jsonRetorno.GetValue('statusConsulta').Value;
    cStat := jsonRetorno.GetValue('cStat').Value;
    nNF := jsonRetorno.GetValue('nNFPref').Value;
    chave := jsonRetorno.GetValue('chave').Value;
	nsNRec := jsonRetorno.GetValue('nsNRec').Value;
    motivo := jsonRetorno.GetValue('motivo').Value;
	pdf := jsonRetorno.GetValue('pdfNFSe').Value;
	
	ShowMessage(motivo);
    
	//Aqui voce pode fazer uma validação para mostrar na tela as informações necessarias
	
-----

## Demais Funcionalidades:

No módulo NFSeAPI, você pode encontrar também as seguintes funcionalidades:

NOME                     | FINALIDADE             | DOCUMENTAÇÂO CONFLUENCE
:-----------------------:|:----------------------:|:-----------------------
**enviaConteudoParaAPI** |Função genérica que envia um conteúdo para API. Requisições do tipo POST.|
**emitirNFSe** | Envia uma NFS-e para processamento.|[Emitir NFS-e](https://confluence.ns.eti.br/pages/viewpage.action?pageId=29037021#Emiss%C3%A3onaNFS-eAPI-Emiss%C3%A3odeNFS-e).
**consultarStatusProcessamento** | Consulta o status de processamento de uma NFS-e.| [Status de Processamento da NFS-e](https://confluence.ns.eti.br/pages/viewpage.action?pageId=29037021#Emiss%C3%A3onaNFS-eAPI-StatusdeProcessamentodaNFS-e).
**cancelarNFe** | Realiza o cancelamento de uma NFS-e. | [Cancelamento de NFS-e](https://confluence.ns.eti.br/display/PUB/Cancelamento+na+NFS-e+API#CancelamentonaNFS-eAPI-CancelamentodeNFS-e).
**listarNSNRecs** | Lista os nsNRec vinculados a uma NFS-e. | [Lista de NSNRecs vinculados a uma NFS-e](https://confluence.ns.eti.br/display/PUB/Listagem+de+NSNRecs+vinculados+a+uma+NFS-e+na+NFS-e+API).
**salvarXML** | Salva um XML em um diretório. | 
**gravaLinhaLog** | Grava uma linha de texto no arquivo de log. | 
