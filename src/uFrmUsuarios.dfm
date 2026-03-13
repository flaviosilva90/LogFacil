object FrmUsuarios: TFrmUsuarios
  Left = 0
  Top = 0
  Caption = 'Cadastro de Usu'#225'rios'
  ClientHeight = 599
  ClientWidth = 816
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
    Width = 816
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 10040064
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 12
      Top = 10
      Width = 183
      Height = 19
      Caption = 'CADASTRO DE USUM'#193'RIOS'
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
    Width = 816
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edtFiltro: TEdit
      Left = 8
      Top = 10
      Width = 300
      Height = 25
      Hint = 'Filtrar por nome ou login'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnBuscar: TButton
      Left = 316
      Top = 9
      Width = 90
      Height = 27
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClick
    end
    object btnNovo: TButton
      Left = 416
      Top = 9
      Width = 90
      Height = 27
      Caption = 'Novo'
      TabOrder = 2
      OnClick = btnNovoClick
    end
  end
  object sgdLista: TStringGrid
    Left = 0
    Top = 84
    Width = 816
    Height = 300
    Align = alTop
    ColCount = 6
    DefaultRowHeight = 22
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    OnClick = sgdListaClick
  end
  object pnlEdicao: TPanel
    Left = 0
    Top = 384
    Width = 816
    Height = 216
    Align = alTop
    BevelOuter = bvNone
    Color = 16448250
    TabOrder = 3
    Visible = False
    object lblNome: TLabel
      Left = 8
      Top = 10
      Width = 48
      Height = 17
      Caption = 'Nome: *'
    end
    object lblLogin: TLabel
      Left = 300
      Top = 10
      Width = 44
      Height = 17
      Caption = 'Login: *'
    end
    object lblSenha: TLabel
      Left = 462
      Top = 10
      Width = 38
      Height = 17
      Caption = 'Senha:'
    end
    object lblEmail: TLabel
      Left = 8
      Top = 62
      Width = 39
      Height = 17
      Caption = 'E-mail:'
    end
    object lblPerfil: TLabel
      Left = 280
      Top = 62
      Width = 41
      Height = 17
      Caption = 'Perfil: *'
    end
    object lblAtivo: TLabel
      Left = 452
      Top = 62
      Width = 32
      Height = 17
      Caption = 'Ativo:'
    end
    object edtNome: TEdit
      Left = 8
      Top = 28
      Width = 280
      Height = 25
      MaxLength = 100
      TabOrder = 0
    end
    object edtLogin: TEdit
      Left = 300
      Top = 28
      Width = 150
      Height = 25
      MaxLength = 50
      TabOrder = 1
    end
    object edtSenha: TEdit
      Left = 462
      Top = 28
      Width = 150
      Height = 25
      MaxLength = 50
      PasswordChar = '*'
      TabOrder = 2
    end
    object edtEmail: TEdit
      Left = 8
      Top = 80
      Width = 260
      Height = 25
      MaxLength = 100
      TabOrder = 3
    end
    object cboPerfil: TComboBox
      Left = 280
      Top = 80
      Width = 160
      Height = 25
      Style = csDropDownList
      TabOrder = 4
    end
    object cboAtivo: TComboBox
      Left = 452
      Top = 80
      Width = 60
      Height = 25
      Style = csDropDownList
      TabOrder = 5
    end
    object btnSalvar: TButton
      Left = 8
      Top = 122
      Width = 100
      Height = 32
      Caption = 'Salvar'
      TabOrder = 6
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 116
      Top = 122
      Width = 100
      Height = 32
      Caption = 'Excluir'
      Enabled = False
      TabOrder = 7
      OnClick = btnExcluirClick
    end
    object btnCancelar: TButton
      Left = 224
      Top = 122
      Width = 100
      Height = 32
      Caption = 'Cancelar'
      TabOrder = 8
      OnClick = btnCancelarClick
    end
  end
end
