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

##### Parâmetros:

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

##### Exemplo de chamada:

Após ter todos os parâmetros listados acima, você deverá fazer a chamada da função. Veja o código de exemplo abaixo:
           
    retorno := emitirNFSeSincrono(conteudo, tpConteudo, CNPJEmit, IM, municipio, tpAmb, exibirNaTela);
    ShowMessage(retorno);

A função **emitirNFSeSincrono** fará o envio, a consulta e download do documento, utilizando as funções emitirNFe, consultarStatusProcessamento e downloadNFeAndSave, presentes no módulo NFeAPI.pas. Por isso, o retorno será um JSON com os principais campos retornados pelos métodos citados anteriormente. No exemplo abaixo, veja como tratar o retorno da função emitirNFeSincrono:

##### Exemplo de tratamento de retorno:

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

    retorno := emitirNFSeSincrono(conteudo, 'xml', '11111111111111', '102030', 'canoas', '2', True);

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
