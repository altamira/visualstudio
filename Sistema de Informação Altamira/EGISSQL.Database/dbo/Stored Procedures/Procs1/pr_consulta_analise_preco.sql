Create procedure pr_consulta_analise_preco
----------------------------------------------------------------
--pr_consulta_analise_preco
----------------------------------------------------------------
--GBS - Global Business Sollution Ltda                      2004
----------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Banco de Dados      : Sql Server 2000
--Autor               : Igor Augusto C. Gama
--Data                : 08.03.2004
--Objetivo            : Listar dados necessários para efetuar a análise de preços
--Atualização         : 04/01/2005 - Acerto do Cabeçalçho - Sérgio Cardoso
--                    : 20/01/2005 - Incluído o campo pc_imposto_importacao - Clelson Camargo
-----------------------------------------------------------------------------------
@nm_fantasia_produto varchar(20) = '',
@cd_produto int = 0,
@cd_grupo_produto float = 0,
@cd_serie_produto float = 0,
@cd_grupo_preco_produto float = 0,
@cd_fase_produto integer,
@ic_atual_maior_ideal char(1) = 'N',
@ic_saldo_maior_zero char(1) = 'N',
@ic_gm_parametro char(1) = 'N',
@ic_venda_menor_bns char(1) = 'N',
@vl_gm_filtro float = 0,
@dt_cotacao datetime
as
  --Declarar as variáveis da procedure
  declare
    @pc_coef_int float,
    @pc_bns      float,
    @cd_moeda    float,
    @codigo      float

	Declare
	  @Session  varchar(100),
    @sg_moeda varchar(30)

  --Seleciona sessão para gerar tabela
--  Select @Session = suser_sname()
  Set @Session = ''


  --Seleciona o coeficiente de internação do parâmetro importação para efetuar cálculos
  select @pc_coef_int = IsNull(pc_coeficiente_internacao, 1)
  from Parametro_Importacao
  where cd_empresa = dbo.fn_empresa()

  --Pegar a fase padrão do estoque por empresa, caso fase = null
  If @cd_fase_produto = null
    Select @cd_fase_produto = cd_fase_produto
    From Parametro_Comercial
    Where cd_empresa = dbo.fn_empresa()

  --Seleciona o % do Base net Sales (BNS) do parametro BI
  select @pc_bns = dbo.fn_pc_bns()

	select 
    identity(int, 1,1) as 'cd_identificador',
    p.cd_produto,
		p.cd_mascara_produto,
		p.nm_produto,
		p.nm_fantasia_produto,
	  ps.qt_saldo_atual_produto,
    --Valor Fob
	  IsNull(pim.vl_produto_importacao, 0) vl_fob_original,
    pa.nm_pais,
    pa.sg_pais,
    pim.cd_moeda,
    m.sg_moeda,
    IsNull(m.qt_num_digitos,0) qt_num_digitos,
    --Valor Fob Reais
	  IsNull(pim.vl_produto_importacao, 1) * IsNull(dbo.fn_vl_moeda_periodo(pim.cd_moeda, @dt_cotacao),1) vl_fob_convertido,
    @pc_coef_int pc_coef_inter,
    (@pc_bns * 100) pc_bns,
    --Custo Cont. Reposição
    (IsNull(pim.vl_produto_importacao, 1) * IsNull(dbo.fn_vl_moeda_periodo(pim.cd_moeda, @dt_cotacao),1)) * @pc_coef_int vl_custo_cont_rep,
    --Custo Cont. Real
    IsNull(pc.vl_custo_contabil_produto,0) vl_custo_contabil_produto,
    -- BNS R$
    Cast(
     ((IsNull(pim.vl_produto_importacao, 1) * IsNull(dbo.fn_vl_moeda_periodo(pim.cd_moeda, @dt_cotacao),1)) * @pc_coef_int)
     / @pc_bns 
     as numeric(25,6)) vl_bns,
	  --Valor Venda Atual
		p.vl_produto,
    --G.M. Atual
    ((p.vl_produto - ((IsNull(pim.vl_produto_importacao, 1) * IsNull(dbo.fn_vl_moeda_periodo(pim.cd_moeda, @dt_cotacao),1)) * @pc_coef_int)) /
     case When len(IsNull(p.vl_produto,1)) = 1 then Replace(IsNull(p.vl_produto,1),0,1) else IsNull(p.vl_produto,1) end * 100) vl_gm_atual,
    --Fator Multipli
    Cast(
     IsNull(pc.vl_custo_contabil_produto,1) /
       (Case When len(IsNull(pim.vl_produto_importacao,1)) = 1 then Replace(IsNull(pim.vl_produto_importacao,1),0,1) else pim.vl_produto_importacao end) *
        Cast(IsNull(dbo.fn_vl_moeda_periodo(pim.cd_moeda, @dt_cotacao),1) as numeric(25,6)) 
     as numeric(25,6)) vl_fator_mult,
    --G.M. Ideal
    (Select pc_tipo_lucro from Tipo_Lucro where cd_tipo_lucro = IsNull(pc.cd_tipo_lucro, gpc.cd_tipo_lucro)) vl_gm_ideal,
    --Valor de Mercado
    p.vl_produto_mercado,
    --Valor de venda ideal
    ((IsNull(pim.vl_produto_importacao, 1) * IsNull(dbo.fn_vl_moeda_periodo(pim.cd_moeda, @dt_cotacao),1)) * @pc_coef_int / 
     ((100 - 
       IsNull((Select pc_tipo_lucro from Tipo_Lucro where cd_tipo_lucro = IsNull(pc.cd_tipo_lucro, gpc.cd_tipo_lucro)),0)) / 
       100)) vl_venda_ideal,
    --Simulação de Desconto
    --(%)
    Cast(null as float) pc_desconto,
    --Valor
    cast(null as float) vl_produto_desc,
    --G.M. Estimativa
    Cast(null as float) vl_gm_estimat,
    --G.M. Real
    Cast(null as float) vl_gm_real
  Into
    #Produto
  from
 	  Produto p
	    Left Outer Join
    Produto_Importacao pim
	    on p.cd_produto = pim.cd_produto
	    Left Outer Join
	  Produto_Custo pc
	    on p.cd_produto = pc.cd_produto
	    Left Outer Join
	  Produto_Saldo ps
	    on p.cd_produto = ps.cd_produto and
	      ps.cd_fase_produto = @cd_fase_produto
	    Left Outer Join
	  Grupo_Preco_Produto gpc
	    on pc.cd_grupo_preco_produto = gpc.cd_grupo_preco_produto
	    Left Outer Join
    Moeda m
      on pim.cd_moeda = m.cd_moeda
      Left Outer Join
    Pais pa
      on pim.cd_pais = pa.cd_pais
	where
    p.nm_fantasia_produto like @nm_fantasia_produto + '%' and
    (p.cd_produto = @cd_produto or @cd_produto = 0) and
    (p.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0) and
    (p.cd_serie_produto = @cd_serie_produto or @cd_serie_produto = 0) and
    (gpc.cd_grupo_preco_produto = @cd_grupo_preco_produto or @cd_grupo_preco_produto = 0)


  CREATE TABLE #Analise_Preco
   ( cd_identificador            int,
     cd_produto                  integer,
     cd_mascara_produto          varchar(20) NULL,
     nm_produto                  varchar(50) NULL,
     nm_fantasia_produto         varchar(30) NULL,
     qt_saldo_atual_produto      float NULL,
     vl_fob_original             float NULL,
     vl_fob_convertido           float NULL,
     pc_imposto_importacao       float NULL, -- Imposto de importacao (Clelson 20.01.2005)
     pc_coef_inter               float NULL,
     pc_bns                      float NULL,
     vl_custo_cont_rep           float NULL,
     vl_custo_contabil_produto   float NULL,
     vl_bns                      float NULL,
     nm_pais                     varchar(30) NULL,
     sg_pais                     varchar(10) NULL,
     cd_moeda                    float NULL,
     sg_moeda                    varchar(20) NULL,
     qt_num_digitos              integer,
     vl_produto                  float NULL,
     vl_gm_atual                 float NULL,
     vl_fator_mult               float NULL,
     vl_gm_ideal                 float NULL,
     vl_produto_mercado          float NULL,
     vl_venda_ideal              float NULL,
     pc_desconto                 float NULL,
     vl_produto_desc             float NULL,
     vl_gm_estimat               float NULL,
     vl_gm_real                  float NULL)

  insert into #analise_preco(
    cd_identificador,
    cd_produto,
    cd_mascara_produto,
    nm_produto,
    nm_fantasia_produto,
    qt_saldo_atual_produto,
    vl_fob_original,
    vl_fob_convertido,
    pc_imposto_importacao, -- Imposto de importacao (Clelson 20.01.2005)
    pc_coef_inter,
    pc_bns,
    vl_custo_cont_rep,
    vl_custo_contabil_produto,
    vl_bns,
    nm_pais,
    sg_pais,
    sg_moeda,
    cd_moeda,
    qt_num_digitos,
    vl_produto,
    vl_gm_atual,
    vl_fator_mult,
    vl_gm_ideal,
    vl_produto_mercado,
    vl_venda_ideal,
		pc_desconto,
    vl_produto_desc,
    vl_gm_estimat,
    vl_gm_real
  ) select
    p.cd_identificador,
    p.cd_produto,
    p.cd_mascara_produto,
    p.nm_produto,
    p.nm_fantasia_produto,
    IsNull(p.qt_saldo_atual_produto,0),
		IsNull(p.vl_fob_original,0),
    IsNull(p.vl_fob_convertido,0),
    cf.pc_importacao,  -- Imposto de importacao (Clelson 20.01.2005)
    IsNull(p.pc_coef_inter,0),
    IsNull(p.pc_bns,0),
    IsNull(p.vl_custo_cont_rep,0),
    IsNull(p.vl_custo_contabil_produto,0),
    IsNull(p.vl_bns,0),
    p.nm_pais,
    p.sg_pais,
    p.sg_moeda,
    IsNull(p.cd_moeda,0),
    IsNull(p.qt_num_digitos,0),
    IsNull(p.vl_produto,0),
    IsNull(p.vl_gm_atual,0),
    IsNull(p.vl_fator_mult,0),
    IsNull(p.vl_gm_ideal,0),
    IsNull(p.vl_produto_mercado,0),
    IsNull(p.vl_venda_ideal,0),
    IsNull(p.pc_desconto,0),
    IsNull(p.vl_produto_desc,0),
    IsNull(p.vl_gm_estimat,0),
    IsNull(p.vl_gm_real,0)
  from #Produto p
   left outer join produto_fiscal pf
     on (pf.cd_produto = p.cd_produto)
   left outer join classificacao_fiscal cf
     on (cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal)

  Select * from #analise_preco
  Where vl_gm_atual < (Case When @ic_atual_maior_ideal = 'S' then vl_gm_ideal
                            Else vl_gm_atual + 1 end)
        and qt_saldo_atual_produto > (Case When @ic_saldo_maior_zero = 'S' then 0
                                       Else qt_saldo_atual_produto - 1 end)
        and vl_gm_atual < (Case When @ic_gm_parametro = 'S' then @vl_gm_filtro
                            Else vl_gm_atual + 1 end)
        and vl_produto < (Case When @ic_venda_menor_bns = 'S' then vl_bns
                           Else vl_produto + 1 end)

