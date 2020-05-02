object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 608
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 8
    Top = 8
    Width = 114
    Height = 16
    Caption = 'CNPJ Do Emitente:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object labelTokenEnviar: TLabel
    Left = 202
    Top = 6
    Width = 174
    Height = 16
    Caption = 'Inscri'#231#227'o Municipal do CNPJ:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 477
    Top = 8
    Width = 95
    Height = 16
    Caption = 'Mun'#237'cipio NFSe'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object pgControl: TPageControl
    Left = 8
    Top = 63
    Width = 561
    Height = 530
    ActivePage = formEmissao
    Align = alCustom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object formEmissao: TTabSheet
      Caption = 'Emiss'#227'o S'#237'ncrona'
      object Label1: TLabel
        Left = 16
        Top = 15
        Width = 61
        Height = 16
        Caption = 'Conteudo:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 339
        Top = 15
        Width = 111
        Height = 16
        Caption = 'Tipo de Conteudo:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 21
        Top = 211
        Width = 110
        Height = 16
        Caption = 'Tipo de Ambiente:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object btnEnviar: TButton
        Left = 21
        Top = 248
        Width = 516
        Height = 28
        Caption = 'Enviar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnEnviarClick
      end
      object memoConteudoEnviar: TMemo
        Left = 21
        Top = 37
        Width = 511
        Height = 153
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object cbTpConteudo: TComboBox
        Left = 456
        Top = 3
        Width = 76
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 2
        Text = 'xml'
        Items.Strings = (
          'xml'
          'json')
      end
      object chkExibir: TCheckBox
        Left = 402
        Top = 212
        Width = 130
        Height = 17
        Caption = 'Exibir PDF na tela'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 282
        Width = 544
        Height = 212
        Caption = 'Retorno API'
        TabOrder = 4
        object memoRetorno: TMemo
          Left = 12
          Top = 24
          Width = 517
          Height = 177
          TabOrder = 0
        end
      end
      object cbTpAmb: TComboBox
        Left = 137
        Top = 205
        Width = 33
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = '2'
        Items.Strings = (
          '2'
          '1')
      end
      object cbSalvarXML: TCheckBox
        Left = 232
        Top = 212
        Width = 153
        Height = 17
        Caption = 'Salvar XML autorizado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
    end
  end
  object txtCNPJ: TEdit
    Left = 8
    Top = 30
    Width = 114
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object txtIMCNPJ: TEdit
    Left = 202
    Top = 28
    Width = 174
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object cbMunicipio: TComboBox
    Left = 477
    Top = 30
    Width = 95
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'canoas'
    Items.Strings = (
      'canoas')
  end
end
