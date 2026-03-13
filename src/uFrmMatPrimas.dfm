object FrmMatPrimas: TFrmMatPrimas
  Caption = 'Cadastro de Mat'#233'rias-Primas'
  ClientHeight = 660  ClientWidth = 820
  Font.Name = 'Segoe UI'  Font.Height = -13
  Position = poOwnerFormCenter  OnCreate = FormCreate
  object pnlTopo: TPanel
    Left=0 Top=0 Width=820 Height=40 Align=alTop BevelOuter=bvNone Color=$00993300
    object lblTitulo: TLabel
      Left=12 Top=10 Caption='CADASTRO DE MAT'#201'RIAS-PRIMAS'
      Font.Color=clWhite Font.Style=[fsBold] Font.Height=-14 ParentFont=False
    end
  end
  object pnlFiltro: TPanel
    Left=0 Top=40 Width=820 Height=44 Align=alTop BevelOuter=bvNone TabOrder=1
    object edtFiltro: TEdit Left=8 Top=10 Width=260 Height=25 TabOrder=0 end
    object chkSoAtivos: TCheckBox
      Left=280 Top=13 Width=80 Caption='S'#243' ativos' Checked=True State=cbChecked TabOrder=1
    end
    object btnBuscar: TButton Left=368 Top=9 Width=80 Height=27 Caption='Buscar' TabOrder=2 OnClick=btnBuscarClick end
    object btnNovo: TButton   Left=456 Top=9 Width=80 Height=27 Caption='Novo'   TabOrder=3 OnClick=btnNovoClick end
  end
  object sgdLista: TStringGrid
    Left=0 Top=84 Width=820 Height=200 Align=alTop
    ColCount=7 DefaultRowHeight=22 RowCount=2 FixedRows=1
    Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
    TabOrder=2 OnClick=sgdListaClick
  end
  object pnlEdicao: TPanel
    Left=0 Top=284 Width=820 Height=376 Align=alTop
    BevelOuter=bvNone Color=$00FAFAFA TabOrder=3 Visible=False
    object lblCodigo: TLabel Left=8 Top=10 Caption='C'#243'digo: *' end
    object edtCodigo: TEdit Left=8 Top=28 Width=120 Height=25 MaxLength=20 TabOrder=0 end
    object lblDesc: TLabel Left=140 Top=10 Caption='Descri'#231#227'o: *' end
    object edtDesc: TEdit Left=140 Top=28 Width=340 Height=25 MaxLength=100 TabOrder=1 end
    object lblCategoria: TLabel Left=492 Top=10 Caption='Categoria' end
    object cboCategoria: TComboBox Left=492 Top=28 Width=200 Height=25 Style=csDropDownList TabOrder=2 end
    object lblUnidade: TLabel Left=8 Top=64 Caption='Unidade: *' end
    object cboUnidade: TComboBox Left=8 Top=82 Width=160 Height=25 Style=csDropDownList TabOrder=3 end
    object lblCustoMedio: TLabel Left=180 Top=64 Caption='Custo M'#233'dio' end
    object edtCustoMedio: TEdit Left=180 Top=82 Width=110 Height=25 Text='0,00' TabOrder=4 end
    object lblEstAtual: TLabel Left=302 Top=64 Caption='Est. Atual' end
    object edtEstAtual: TEdit Left=302 Top=82 Width=100 Height=25 Text='0,000' TabOrder=5 end
    object lblEstMin: TLabel Left=414 Top=64 Caption='Est. M'#237'n.' end
    object edtEstMin: TEdit Left=414 Top=82 Width=100 Height=25 Text='0,000' TabOrder=6 end
    object lblEstMax: TLabel Left=526 Top=64 Caption='Est. M'#225'x.' end
    object edtEstMax: TEdit Left=526 Top=82 Width=100 Height=25 Text='0,000' TabOrder=7 end
    object lblLocalizacao: TLabel Left=8 Top=118 Caption='Localiza'#231#227'o' end
    object edtLocalizacao: TEdit Left=8 Top=136 Width=160 Height=25 TabOrder=8 end
    object lblAtivo: TLabel Left=180 Top=118 Caption='Ativo' end
    object cboAtivo: TComboBox Left=180 Top=136 Width=60 Height=25 Style=csDropDownList TabOrder=9 end
    object lblObs: TLabel Left=8 Top=172 Caption='Observa'#231#245'es' end
    object mmoObs: TMemo Left=8 Top=190 Width=680 Height=70 TabOrder=10 end
    object btnSalvar: TButton Left=8 Top=276 Width=100 Height=32 Caption='Salvar' TabOrder=11 OnClick=btnSalvarClick end
    object btnExcluir: TButton Left=116 Top=276 Width=100 Height=32 Caption='Excluir' Enabled=False TabOrder=12 OnClick=btnExcluirClick end
    object btnCancelar: TButton Left=224 Top=276 Width=100 Height=32 Caption='Cancelar' TabOrder=13 OnClick=btnCancelarClick end
  end
end
