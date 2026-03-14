object FrmClientes: TFrmClientes
  Left = 0
  Top = 0
  Caption = 'Cadastro de Clientes'
  ClientHeight = 660
  ClientWidth = 860
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 860
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 161
      Height = 19
      Caption = 'CADASTRO DE CLIENTES'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlFiltro: TPanel
    Left = 0
    Top = 40
    Width = 860
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtFiltro: TEdit
      Left = 8
      Top = 10
      Width = 280
      Height = 25
      TabOrder = 0
    end
    object chkSoAtivos: TCheckBox
      Left = 300
      Top = 13
      Width = 80
      Height = 17
      Caption = 'S'#243' ativos'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object btnBuscar: TButton
      Left = 390
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClick
    end
    object btnNovo: TButton
      Left = 480
      Top = 9
      Width = 80
      Height = 27
      Caption = 'Novo'
      TabOrder = 3
      OnClick = btnNovoClick
    end
  end
  object sgdLista: TStringGrid
    Left = 0
    Top = 84
    Width = 860
    Height = 200
    Align = alTop
    ColCount = 7
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 284
    Width = 860
    Height = 376
    Align = alTop
    BevelOuter = bvNone
    Color = 16448250
    TabOrder = 3
    Visible = False
    object pgcDados: TPageControl
      Left = 0
      Top = 0
      Width = 860
      Height = 320
      ActivePage = tabGeral
      Align = alTop
      TabOrder = 0
      object tabGeral: TTabSheet
        Caption = 'Dados Gerais'
        object lblTipo: TLabel
          Left = 8
          Top = 10
          Width = 29
          Height = 17
          Caption = 'Tipo:'
        end
        object lblNome: TLabel
          Left = 140
          Top = 10
          Width = 48
          Height = 17
          Caption = 'Nome: *'
        end
        object lblFantasia: TLabel
          Left = 452
          Top = 10
          Width = 87
          Height = 17
          Caption = 'Nome Fantasia'
        end
        object lblCPF: TLabel
          Left = 8
          Top = 64
          Width = 21
          Height = 17
          Caption = 'CPF'
        end
        object lblCNPJ: TLabel
          Left = 8
          Top = 64
          Width = 29
          Height = 17
          Caption = 'CNPJ'
          Visible = False
        end
        object lblRG: TLabel
          Left = 160
          Top = 64
          Width = 17
          Height = 17
          Caption = 'RG'
        end
        object lblIE: TLabel
          Left = 160
          Top = 64
          Width = 72
          Height = 17
          Caption = 'Ins. Estadual'
          Visible = False
        end
        object lblEmail: TLabel
          Left = 8
          Top = 118
          Width = 36
          Height = 17
          Caption = 'E-mail'
        end
        object lblFone1: TLabel
          Left = 260
          Top = 118
          Width = 39
          Height = 17
          Caption = 'Fone 1'
        end
        object lblFone2: TLabel
          Left = 412
          Top = 118
          Width = 39
          Height = 17
          Caption = 'Fone 2'
        end
        object lblLimite: TLabel
          Left = 8
          Top = 172
          Width = 100
          Height = 17
          Caption = 'Limite de Cr'#233'dito'
        end
        object lblAtivo: TLabel
          Left = 140
          Top = 172
          Width = 29
          Height = 17
          Caption = 'Ativo'
        end
        object cboTipo: TComboBox
          Left = 8
          Top = 28
          Width = 120
          Height = 25
          Style = csDropDownList
          TabOrder = 0
          OnChange = cboTipoChange
        end
        object edtNome: TEdit
          Left = 140
          Top = 28
          Width = 300
          Height = 25
          TabOrder = 1
        end
        object edtFantasia: TEdit
          Left = 452
          Top = 28
          Width = 240
          Height = 25
          TabOrder = 2
        end
        object edtCPF: TEdit
          Left = 8
          Top = 82
          Width = 140
          Height = 25
          MaxLength = 14
          TabOrder = 3
        end
        object edtCNPJ: TEdit
          Left = 8
          Top = 82
          Width = 160
          Height = 25
          MaxLength = 18
          TabOrder = 4
          Visible = False
        end
        object edtRG: TEdit
          Left = 160
          Top = 82
          Width = 120
          Height = 25
          TabOrder = 5
        end
        object edtIE: TEdit
          Left = 160
          Top = 82
          Width = 120
          Height = 25
          TabOrder = 6
          Visible = False
        end
        object edtEmail: TEdit
          Left = 8
          Top = 136
          Width = 240
          Height = 25
          TabOrder = 7
        end
        object edtFone1: TEdit
          Left = 260
          Top = 136
          Width = 140
          Height = 25
          TabOrder = 8
        end
        object edtFone2: TEdit
          Left = 412
          Top = 136
          Width = 140
          Height = 25
          TabOrder = 9
        end
        object edtLimite: TEdit
          Left = 8
          Top = 190
          Width = 120
          Height = 25
          TabOrder = 10
          Text = '0,00'
        end
        object cboAtivo: TComboBox
          Left = 140
          Top = 190
          Width = 60
          Height = 25
          Style = csDropDownList
          TabOrder = 11
        end
      end
      object tabEndereco: TTabSheet
        Caption = 'Endere'#231'o'
        object lblCEP: TLabel
          Left = 8
          Top = 10
          Width = 22
          Height = 17
          Caption = 'CEP'
        end
        object lblLogr: TLabel
          Left = 120
          Top = 10
          Width = 70
          Height = 17
          Caption = 'Logradouro'
        end
        object lblNum: TLabel
          Left = 472
          Top = 10
          Width = 48
          Height = 17
          Caption = 'N'#250'mero'
        end
        object lblComp: TLabel
          Left = 564
          Top = 10
          Width = 82
          Height = 17
          Caption = 'Complemento'
        end
        object lblBairro: TLabel
          Left = 8
          Top = 64
          Width = 35
          Height = 17
          Caption = 'Bairro'
        end
        object lblCidade: TLabel
          Left = 220
          Top = 64
          Width = 41
          Height = 17
          Caption = 'Cidade'
        end
        object lblUF: TLabel
          Left = 432
          Top = 64
          Width = 15
          Height = 17
          Caption = 'UF'
        end
        object lblObs: TLabel
          Left = 8
          Top = 118
          Width = 76
          Height = 17
          Caption = 'Observa'#231#245'es'
        end
        object edtCEP: TEdit
          Left = 8
          Top = 28
          Width = 100
          Height = 25
          TabOrder = 0
        end
        object edtLogr: TEdit
          Left = 120
          Top = 28
          Width = 340
          Height = 25
          TabOrder = 1
        end
        object edtNum: TEdit
          Left = 472
          Top = 28
          Width = 80
          Height = 25
          TabOrder = 2
        end
        object edtComp: TEdit
          Left = 564
          Top = 28
          Width = 160
          Height = 25
          TabOrder = 3
        end
        object edtBairro: TEdit
          Left = 8
          Top = 82
          Width = 200
          Height = 25
          TabOrder = 4
        end
        object edtCidade: TEdit
          Left = 220
          Top = 82
          Width = 200
          Height = 25
          TabOrder = 5
        end
        object edtUF: TEdit
          Left = 432
          Top = 82
          Width = 40
          Height = 25
          MaxLength = 2
          TabOrder = 6
        end
        object mmoObs: TMemo
          Left = 8
          Top = 136
          Width = 700
          Height = 80
          TabOrder = 7
        end
      end
    end
    object btnSalvar: TButton
      Left = 8
      Top = 328
      Width = 100
      Height = 32
      Caption = 'Salvar'
      TabOrder = 1
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 116
      Top = 328
      Width = 100
      Height = 32
      Caption = 'Excluir'
      Enabled = False
      TabOrder = 2
      OnClick = btnExcluirClick
    end
    object btnCancelar: TButton
      Left = 224
      Top = 328
      Width = 100
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
  end
end
