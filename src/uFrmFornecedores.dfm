object FrmFornecedores: TFrmFornecedores
  Left = 0  Top = 0
  Caption = 'Cadastro de Fornecedores'
  ClientHeight = 660  ClientWidth = 860
  Font.Name = 'Segoe UI'  Font.Height = -13
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  object pnlTopo: TPanel
    Left=0  Top=0  Width=860  Height=40  Align=alTop  BevelOuter=bvNone  Color=$00993300
    object lblTitulo: TLabel
      Left=12  Top=10  Caption='CADASTRO DE FORNECEDORES'
      Font.Color=clWhite  Font.Style=[fsBold]  Font.Height=-14  ParentFont=False
    end
  end
  object pnlFiltro: TPanel
    Left=0  Top=40  Width=860  Height=44  Align=alTop  BevelOuter=bvNone  TabOrder=1
    object edtFiltro: TEdit
      Left=8  Top=10  Width=280  Height=25  TabOrder=0
    end
    object chkSoAtivos: TCheckBox
      Left=300  Top=13  Width=80  Caption='S'#243' ativos'  Checked=True  State=cbChecked  TabOrder=1
    end
    object btnBuscar: TButton
      Left=390  Top=9  Width=80  Height=27  Caption='Buscar'  TabOrder=2  OnClick=btnBuscarClick
    end
    object btnNovo: TButton
      Left=480  Top=9  Width=80  Height=27  Caption='Novo'  TabOrder=3  OnClick=btnNovoClick
    end
  end
  object sgdLista: TStringGrid
    Left=0  Top=84  Width=860  Height=200  Align=alTop
    ColCount=7  DefaultRowHeight=22  RowCount=2  FixedRows=1
    Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
    TabOrder=2  OnClick=sgdListaClick
  end
  object pnlEdicao: TPanel
    Left=0  Top=284  Width=860  Height=376  Align=alTop
    BevelOuter=bvNone  Color=$00FAFAFA  TabOrder=3  Visible=False
    object pgcDados: TPageControl
      Left=0  Top=0  Width=860  Height=320  Align=alTop  TabOrder=0
      object tabGeral: TTabSheet
        Caption='Dados Gerais'
        object lblTipo: TLabel Left=8 Top=10 Caption='Tipo:' end
        object cboTipo: TComboBox Left=8 Top=28 Width=120 Height=25 Style=csDropDownList TabOrder=0 end
        object lblNome: TLabel Left=140 Top=10 Caption='Nome: *' end
        object edtNome: TEdit Left=140 Top=28 Width=300 Height=25 TabOrder=1 end
        object lblFantasia: TLabel Left=452 Top=10 Caption='Nome Fantasia' end
        object edtFantasia: TEdit Left=452 Top=28 Width=240 Height=25 TabOrder=2 end
        object lblCNPJ: TLabel Left=8 Top=64 Caption='CNPJ' end
        object edtCNPJ: TEdit Left=8 Top=82 Width=160 Height=25 MaxLength=18 TabOrder=3 end
        object lblCPF: TLabel Left=8 Top=64 Caption='CPF' Visible=False end
        object edtCPF: TEdit Left=8 Top=82 Width=140 Height=25 MaxLength=14 TabOrder=4 Visible=False end
        object lblIE: TLabel Left=180 Top=64 Caption='Ins. Estadual' end
        object edtIE: TEdit Left=180 Top=82 Width=120 Height=25 TabOrder=5 end
        object lblEmail: TLabel Left=8 Top=118 Caption='E-mail' end
        object edtEmail: TEdit Left=8 Top=136 Width=220 Height=25 TabOrder=6 end
        object lblFone1: TLabel Left=240 Top=118 Caption='Fone 1' end
        object edtFone1: TEdit Left=240 Top=136 Width=140 Height=25 TabOrder=7 end
        object lblFone2: TLabel Left=392 Top=118 Caption='Fone 2' end
        object edtFone2: TEdit Left=392 Top=136 Width=140 Height=25 TabOrder=8 end
        object lblContato: TLabel Left=8 Top=172 Caption='Contato' end
        object edtContato: TEdit Left=8 Top=190 Width=200 Height=25 TabOrder=9 end
        object lblAtivo: TLabel Left=220 Top=172 Caption='Ativo' end
        object cboAtivo: TComboBox Left=220 Top=190 Width=60 Height=25 Style=csDropDownList TabOrder=10 end
      end
      object tabEndereco: TTabSheet
        Caption='Endere'#231'o'
        object lblCEP: TLabel Left=8 Top=10 Caption='CEP' end
        object edtCEP: TEdit Left=8 Top=28 Width=100 Height=25 TabOrder=0 end
        object lblLogr: TLabel Left=120 Top=10 Caption='Logradouro' end
        object edtLogr: TEdit Left=120 Top=28 Width=340 Height=25 TabOrder=1 end
        object lblNum: TLabel Left=472 Top=10 Caption='N'#250'mero' end
        object edtNum: TEdit Left=472 Top=28 Width=80 Height=25 TabOrder=2 end
        object lblComp: TLabel Left=564 Top=10 Caption='Complemento' end
        object edtComp: TEdit Left=564 Top=28 Width=160 Height=25 TabOrder=3 end
        object lblBairro: TLabel Left=8 Top=64 Caption='Bairro' end
        object edtBairro: TEdit Left=8 Top=82 Width=200 Height=25 TabOrder=4 end
        object lblCidade: TLabel Left=220 Top=64 Caption='Cidade' end
        object edtCidade: TEdit Left=220 Top=82 Width=200 Height=25 TabOrder=5 end
        object lblUF: TLabel Left=432 Top=64 Caption='UF' end
        object edtUF: TEdit Left=432 Top=82 Width=40 Height=25 MaxLength=2 TabOrder=6 end
        object lblObs: TLabel Left=8 Top=118 Caption='Observa'#231#245'es' end
        object mmoObs: TMemo Left=8 Top=136 Width=700 Height=80 TabOrder=7 end
      end
    end
    object btnSalvar: TButton
      Left=8 Top=328 Width=100 Height=32 Caption='Salvar' TabOrder=1 OnClick=btnSalvarClick
    end
    object btnExcluir: TButton
      Left=116 Top=328 Width=100 Height=32 Caption='Excluir' Enabled=False TabOrder=2 OnClick=btnExcluirClick
    end
    object btnCancelar: TButton
      Left=224 Top=328 Width=100 Height=32 Caption='Cancelar' TabOrder=3 OnClick=btnCancelarClick
    end
  end
end
