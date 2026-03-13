object FrmProdutos: TFrmProdutos
  Caption = 'Cadastro de Produtos'
  ClientHeight = 700  ClientWidth = 860
  Font.Name = 'Segoe UI'  Font.Height = -13
  Position = poOwnerFormCenter  OnCreate = FormCreate
  object pnlTopo: TPanel
    Left=0 Top=0 Width=860 Height=40 Align=alTop BevelOuter=bvNone Color=$00993300
    object lblTitulo: TLabel
      Left=12 Top=10 Caption='CADASTRO DE PRODUTOS'
      Font.Color=clWhite Font.Style=[fsBold] Font.Height=-14 ParentFont=False
    end
  end
  object pnlFiltro: TPanel
    Left=0 Top=40 Width=860 Height=44 Align=alTop BevelOuter=bvNone TabOrder=1
    object edtFiltro: TEdit Left=8 Top=10 Width=260 Height=25 TabOrder=0 end
    object chkSoAtivos: TCheckBox Left=280 Top=13 Width=80 Caption='S'#243' ativos' Checked=True State=cbChecked TabOrder=1 end
    object btnBuscar: TButton Left=368 Top=9 Width=80 Height=27 Caption='Buscar' TabOrder=2 OnClick=btnBuscarClick end
    object btnNovo: TButton   Left=456 Top=9 Width=80 Height=27 Caption='Novo'   TabOrder=3 OnClick=btnNovoClick end
  end
  object sgdLista: TStringGrid
    Left=0 Top=84 Width=860 Height=200 Align=alTop
    ColCount=8 DefaultRowHeight=22 RowCount=2 FixedRows=1
    Options=[goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goColSizing,goRowSelect]
    TabOrder=2 OnClick=sgdListaClick
  end
  object pnlEdicao: TPanel
    Left=0 Top=284 Width=860 Height=416 Align=alTop
    BevelOuter=bvNone Color=$00FAFAFA TabOrder=3 Visible=False
    object lblCodigo: TLabel Left=8 Top=8 Caption='C'#243'digo: *' end
    object edtCodigo: TEdit Left=8 Top=26 Width=120 Height=25 MaxLength=20 TabOrder=0 end
    object lblCodBar: TLabel Left=140 Top=8 Caption='C'#243'd. Barras' end
    object edtCodBar: TEdit Left=140 Top=26 Width=150 Height=25 TabOrder=1 end
    object lblDesc: TLabel Left=302 Top=8 Caption='Descri'#231#227'o: *' end
    object edtDesc: TEdit Left=302 Top=26 Width=420 Height=25 MaxLength=100 TabOrder=2 end
    object lblCategoria: TLabel Left=8 Top=62 Caption='Categoria' end
    object cboCategoria: TComboBox Left=8 Top=80 Width=200 Height=25 Style=csDropDownList TabOrder=3 end
    object lblUnidade: TLabel Left=220 Top=62 Caption='Unidade: *' end
    object cboUnidade: TComboBox Left=220 Top=80 Width=150 Height=25 Style=csDropDownList TabOrder=4 end
    object lblPrecoCusto: TLabel Left=382 Top=62 Caption='Pre'#231'o Custo' end
    object edtPrecoCusto: TEdit Left=382 Top=80 Width=110 Height=25 Text='0,00' TabOrder=5 OnChange=edtPrecoCustoChange end
    object lblPrecoVenda: TLabel Left=504 Top=62 Caption='Pre'#231'o Venda: *' end
    object edtPrecoVenda: TEdit Left=504 Top=80 Width=110 Height=25 Text='0,00' TabOrder=6 OnChange=edtPrecoVendaChange end
    object lblMargem: TLabel Left=626 Top=62 Caption='Margem:' end
    object lblMargemVal: TLabel Left=626 Top=80 Caption='0,00%' Font.Style=[fsBold] Font.Color=clGreen ParentFont=False end
    object lblEstAtual: TLabel Left=8 Top=116 Caption='Est. Atual' end
    object edtEstAtual: TEdit Left=8 Top=134 Width=100 Height=25 Text='0,000' TabOrder=7 end
    object lblEstMin: TLabel Left=120 Top=116 Caption='Est. M'#237'n.' end
    object edtEstMin: TEdit Left=120 Top=134 Width=100 Height=25 Text='0,000' TabOrder=8 end
    object lblEstMax: TLabel Left=232 Top=116 Caption='Est. M'#225'x.' end
    object edtEstMax: TEdit Left=232 Top=134 Width=100 Height=25 Text='0,000' TabOrder=9 end
    object lblNCM: TLabel Left=344 Top=116 Caption='NCM' end
    object edtNCM: TEdit Left=344 Top=134 Width=100 Height=25 MaxLength=10 TabOrder=10 end
    object lblCFOP: TLabel Left=456 Top=116 Caption='CFOP' end
    object edtCFOP: TEdit Left=456 Top=134 Width=80 Height=25 MaxLength=6 TabOrder=11 end
    object lblAtivo: TLabel Left=548 Top=116 Caption='Ativo' end
    object cboAtivo: TComboBox Left=548 Top=134 Width=60 Height=25 Style=csDropDownList TabOrder=12 end
    object lblDescComp: TLabel Left=8 Top=170 Caption='Descri'#231#227'o Completa' end
    object mmoDescComp: TMemo Left=8 Top=188 Width=700 Height=60 TabOrder=13 end
    object lblObs: TLabel Left=8 Top=258 Caption='Observa'#231#245'es' end
    object mmoObs: TMemo Left=8 Top=276 Width=700 Height=50 TabOrder=14 end
    object btnSalvar: TButton Left=8 Top=336 Width=100 Height=32 Caption='Salvar' TabOrder=15 OnClick=btnSalvarClick end
    object btnExcluir: TButton Left=116 Top=336 Width=100 Height=32 Caption='Excluir' Enabled=False TabOrder=16 OnClick=btnExcluirClick end
    object btnCancelar: TButton Left=224 Top=336 Width=100 Height=32 Caption='Cancelar' TabOrder=17 OnClick=btnCancelarClick end
  end
end
