
CREATE PROCEDURE pr_controle_ativo_fixo

---------------------------------------------------------------------------
--pr_controle_ativo_fixo
---------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
---------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardlso Fernandes
--Banco de Dados       : EGISSQL 
--Objetivo             : Consulta de Controle do Ativo Fixo
--Data                 : 10.01.2005
--Atualizado           : 20.01.2007
--                     : 22.01.2007 - Acertos Diversos na Consulta - Carlos Fernandes
--                     : 28.04.2007 - Contas Contábeis - Carlos/Anderson
--                     : 17.05.2007 - Tipo do Bem, Pis, Cofins na Grid - Carlos Fernandes
--                     : 31.08.2007 - Ajuste na data de aquisição - Carlos Fernandes
-----------------------------------------------------------------------------------------

@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_grupo_bem int      = 0,
@cd_conta     int      = 0

as

begin


--Cálculo

if @ic_parametro = 1 
begin

  SELECT
    case when b.dt_baixa_bem is null 
    then 'N' 
    else 'S' end                        as Legenda_1,          

    case when (b.dt_baixa_bem between @dt_inicial and @dt_final)
    then
      'S' 
    else
      'N' end                           as Legenda_2,

    case when (b.dt_aquisicao_bem between @dt_inicial and @dt_final )
    then
      'S' 
    else
      'N' end                           as Legenda_3,

    ''                                  as Legenda_4,

    ''                                  as Seleciona,

    d.cd_departamento,
    d.nm_departamento                   as Departamento,
    cc.cd_centro_custo,
    cc.nm_centro_custo                  as CentroCusto,
    cc.cd_mascara_centro_custo,
    b.nm_mascara_bem                    as Mascara,
    b.cd_patrimonio_bem                 as Patrimonio,
    gb.nm_grupo_bem                     as Grupo,
    gb.ic_depreciacao_grupo_bem,
    gb.qt_vida_util_grupo_bem           as VidaUtil,
    gb.pc_depreciacao_grupo_bem         as TaxaDepreciacao,
    b.nm_bem                            as Bem,
    sb.cd_status_bem,
    sb.nm_status_bem                    as StatusBem,
    b.dt_aquisicao_bem                  as DataAquisicao,
    b.dt_inicio_uso_bem                 as DataInicioUsoBem,
    vb.vl_original_bem                  as ValorAquisicao,
    f.nm_fantasia_fornecedor            as Fornecedor,
    nei.cd_nota_entrada,
    nei.cd_serie_nota_fiscal,
    nei.cd_item_nota_entrada,
    vb.cd_moeda,
    vm.vl_moeda, 
    (vb.vl_original_bem / vm.vl_moeda)  as vl_total,
    0.00                                as ValorAnual,   --Não Lembro a Fórmula depois acertamos ( Carlos 10/1/2005 )
    vb.vl_deprec_acumulada_bem          as ValorDepreciacaoAcumulada,
    vb.pc_depreciado_bem                as PercDepreciadoBem,
    b.dt_baixa_bem                      as DataBaixa,
    cb.vl_calculo_bem                   as ValorDepPeriodo,
    pc.cd_mascara_conta                 as ContaContabil,
    pc.nm_conta                         as DescricaoConta,
    vb.vl_residual_bem                  as ValorResidual,
    vb.vl_fixo_depreciacao_bem          as ValorFixoDep,
    vbi.vl_depreciacao_bem              as ValorDepImplantacao,
    pcd.cd_mascara_conta                as ContaDebito,
    pcc.cd_mascara_conta                as ContaCredito,
    tb.nm_tipo_bem                      as TipoBem,
    vb.pc_producao_bem              

  FROM
    Bem b                                                                              INNER JOIN
    Calculo_bem cb            on cb.cd_bem         = b.cd_bem                          LEFT OUTER JOIN
    Grupo_bem gb              on b.cd_grupo_bem    = gb.cd_grupo_bem                   LEFT OUTER JOIN
    Valor_Bem vb              on b.cd_bem          = vb.cd_bem                         LEFT OUTER JOIN
    Fornecedor f              on b.cd_fornecedor   = f.cd_fornecedor                   LEFT OUTER JOIN
    Nota_Entrada_item nei     on b.cd_nota_entrada = nei.cd_nota_entrada and
                                 b.cd_item_nota_entrada = nei.cd_item_nota_entrada    
                                                                                       LEFT OUTER JOIN  
    Centro_Custo cc           on b.cd_centro_custo          = cc.cd_centro_custo       LEFT OUTER JOIN
    Departamento d            on b.cd_departamento          = d.cd_departamento        LEFT OUTER JOIN
    Status_Bem sb             on b.cd_status_bem            = sb.cd_status_bem         LEFT OUTER JOIN
    Parametro_Ativo pa        on vb.cd_moeda                = pa.cd_moeda              LEFT OUTER JOIN
    Valor_Moeda vm            on pa.cd_moeda                = vm.cd_moeda              LEFT OUTER JOIN
    Plano_Conta       pc      on pc.cd_conta                = b.cd_conta               LEFT OUTER JOIN
    Valor_Bem_Implantacao vbi on vbi.cd_bem                 = b.cd_bem                 LEFT OUTER JOIN
    Lancamento_Padrao lp      on lp.cd_lancamento_padrao    = gb.cd_lancamento_padrao  LEFT OUTER JOIN
    Plano_Conta pcd           on lp.cd_conta_debito_padrao  = pcd.cd_conta             LEFT OUTER JOIN
    Plano_Conta pcc           on lp.cd_conta_credito_padrao = pcc.cd_conta             LEFT OUTER JOIN
    Tipo_Bem tb               on tb.cd_tipo_bem             = b.cd_tipo_bem

--select * from plano_conta
--select * from lancamento_padrao

  where
    cb.dt_calculo_bem between @dt_inicial and @dt_final and
    isnull(vb.vl_original_bem,0)>0 and
    isnull(b.cd_conta,0)     = case when isnull(@cd_conta,0)     = 0 then isnull(b.cd_conta,0)     else @cd_conta end and
    isnull(b.cd_grupo_bem,0) = case when isnull(@cd_grupo_bem,0) = 0 then isnull(b.cd_grupo_bem,0) else @cd_grupo_bem end and
    b.dt_aquisicao_bem <= @dt_final
  order by 
    gb.nm_grupo_bem,
    b.dt_aquisicao_bem,
    d.nm_departamento,
    b.nm_bem

end

--Aquisição

if @ic_parametro = 2
begin

  SELECT
    case when b.dt_baixa_bem is null 
    then 'N' 
    else 'S' end               as Legenda_1,          

    case when (b.dt_baixa_bem between @dt_inicial and @dt_final)
    then
      'S' 
    else
      'N' end                           as Legenda_2,

    case when (b.dt_aquisicao_bem between @dt_inicial and @dt_final )
    then
      'S' 
    else
      'N' end                           as Legenda_3,

    ''                                  as Legenda_4,

    ''                                  as Seleciona,

    d.cd_departamento,
    d.nm_departamento              as Departamento,
    cc.cd_centro_custo,
    cc.nm_centro_custo             as CentroCusto,
    cc.cd_mascara_centro_Custo,
    b.nm_mascara_bem               as Mascara,
    b.cd_patrimonio_bem            as Patrimonio,
    gb.nm_grupo_bem                as Grupo,
    gb.ic_depreciacao_grupo_bem,
    gb.qt_vida_util_grupo_bem      as VidaUtil,
    gb.pc_depreciacao_grupo_bem    as TaxaDepreciacao,
    b.nm_bem                       as Bem,
    sb.cd_status_bem,
    sb.nm_status_bem               as StatusBem,
    b.dt_aquisicao_bem             as DataAquisicao,
    b.dt_inicio_uso_bem            as DataInicioUsoBem,
    vb.vl_original_bem             as ValorAquisicao,
    f.nm_fantasia_fornecedor       as Fornecedor,

    nei.cd_nota_entrada,
    nei.cd_serie_nota_fiscal,
    nei.cd_item_nota_entrada,
    vb.cd_moeda,
    vm.vl_moeda, 
    (vb.vl_original_bem / vm.vl_moeda)  as vl_total,
    0.00                                as ValorAnual,   --Não Lembro a Fórmula depois acertamos ( Carlos 10/1/2005 )
    vb.vl_deprec_acumulada_bem          as ValorDepreciacaoAcumulada,
    vb.pc_depreciado_bem                as PercDepreciadoBem,
    b.dt_baixa_bem                      as DataBaixa,
    vb.vl_dep_periodo_bem               as ValorDepPeriodo,
    pc.cd_mascara_conta                 as ContaContabil,
    pc.nm_conta                         as DescricaoConta,
    vb.vl_residual_bem                  as ValorResidual,
    vb.vl_fixo_depreciacao_bem          as ValorFixoDep,
    vbi.vl_depreciacao_bem              as ValorDepImplantacao,
    pcd.cd_mascara_conta                as ContaDebito,
    pcc.cd_mascara_conta                as ContaCredito,
    tb.nm_tipo_bem                      as TipoBem,
    vb.pc_producao_bem              

  FROM
    Bem b                                                                        LEFT OUTER JOIN
    Grupo_bem gb           ON b.cd_grupo_bem = gb.cd_grupo_bem                   LEFT OUTER JOIN
    Valor_Bem vb           ON b.cd_bem = vb.cd_bem                               LEFT OUTER JOIN
    Fornecedor f           ON b.cd_fornecedor = f.cd_fornecedor                  LEFT OUTER JOIN
    Nota_Entrada_item nei  ON b.cd_nota_entrada = nei.cd_nota_entrada and
                              b.cd_item_nota_entrada = nei.cd_item_nota_entrada  LEFT OUTER JOIN  
    Centro_Custo cc        ON b.cd_centro_custo = cc.cd_centro_custo             LEFT OUTER JOIN
    Departamento d         on b.cd_departamento = d.cd_departamento              LEFT OUTER JOIN
    Status_Bem sb          on b.cd_status_bem = sb.cd_status_bem                       LEFT OUTER JOIN
    Parametro_Ativo pa     ON vb.cd_moeda = pa.cd_moeda                                LEFT OUTER JOIN
    Valor_Moeda vm         ON pa.cd_moeda = vm.cd_moeda                                LEFT OUTER JOIN
    Plano_Conta       pc   on pc.cd_conta = gb.cd_conta                                LEFT OUTER JOIN
    Valor_Bem_Implantacao vbi on vbi.cd_bem = b.cd_bem                                 LEFT OUTER JOIN
    Lancamento_Padrao lp      on lp.cd_lancamento_padrao    = gb.cd_lancamento_padrao  LEFT OUTER JOIN
    Plano_Conta pcd           on lp.cd_conta_debito_padrao  = pcd.cd_conta             LEFT OUTER JOIN
    Plano_Conta pcc           on lp.cd_conta_credito_padrao = pcc.cd_conta             LEFT OUTER JOIN
    Tipo_Bem tb               on tb.cd_tipo_bem             = b.cd_tipo_bem

  where
    b.dt_aquisicao_bem between @dt_inicial and @dt_final and
   isnull(vb.vl_original_bem,0)>0

  order by 
    gb.nm_grupo_bem,
    b.dt_aquisicao_bem,
    d.nm_departamento,
    b.nm_bem

end

--Baixa

if @ic_parametro = 3
begin

  SELECT
    case when b.dt_baixa_bem is null 
    then 'N' 
    else 'S' end                        as Legenda_1,          

    case when (b.dt_baixa_bem between @dt_inicial and @dt_final)
    then
      'S' 
    else
      'N' end                           as Legenda_2,

    case when (b.dt_aquisicao_bem between @dt_inicial and @dt_final )
    then
      'S' 
    else
      'N' end                           as Legenda_3,

    ''                                  as Legenda_4,

    ''                                  as Seleciona,
    d.cd_departamento,
    d.nm_departamento              as Departamento,
    cc.cd_centro_custo,
    cc.nm_centro_custo             as CentroCusto,
    b.nm_mascara_bem               as Mascara,
    b.cd_patrimonio_bem            as Patrimonio,
    gb.nm_grupo_bem                as Grupo,
    gb.ic_depreciacao_grupo_bem,
    gb.qt_vida_util_grupo_bem      as VidaUtil,
    gb.pc_depreciacao_grupo_bem    as TaxaDepreciacao,
    b.nm_bem                       as Bem,
    sb.cd_status_bem,
    sb.nm_status_bem               as StatusBem,
    b.dt_aquisicao_bem             as DataAquisicao,
    b.dt_inicio_uso_bem            as DataInicioUsoBem,
    vb.vl_original_bem             as ValorAquisicao,
    f.nm_fantasia_fornecedor       as Fornecedor,

    nei.cd_nota_entrada,
    nei.cd_serie_nota_fiscal,
    nei.cd_item_nota_entrada,
    vb.cd_moeda,
    vm.vl_moeda, 
    (vb.vl_original_bem / vm.vl_moeda)  as vl_total,
    0.00                                as ValorAnual,   --Não Lembro a Fórmula depois acertamos ( Carlos 10/1/2005 )
    vb.vl_deprec_acumulada_bem          as ValorDepreciacaoAcumulada,
    vb.pc_depreciado_bem                as PercDepreciadoBem,
    b.dt_baixa_bem                      as DataBaixa,
    vb.vl_dep_periodo_bem               as ValorDepPeriodo,
    pc.cd_mascara_conta                 as ContaContabil,
    pc.nm_conta                         as DescricaoConta,
    vb.vl_residual_bem                  as ValorResidual,
    vb.vl_fixo_depreciacao_bem          as ValorFixoDep,
    vbi.vl_depreciacao_bem              as ValorDepImplantacao,
    pcd.cd_mascara_conta                as ContaDebito,
    pcc.cd_mascara_conta                as ContaCredito,
    tb.nm_tipo_bem                      as TipoBem,
    vb.pc_producao_bem              

  FROM 
    Bem b                                                                            LEFT OUTER JOIN
    Grupo_bem gb              on b.cd_grupo_bem = gb.cd_grupo_bem                    LEFT OUTER JOIN
    Valor_Bem vb              on b.cd_bem = vb.cd_bem                                LEFT OUTER JOIN
    Fornecedor f              on b.cd_fornecedor = f.cd_fornecedor                   LEFT OUTER JOIN
    Nota_Entrada_item nei     on b.cd_nota_entrada = nei.cd_nota_entrada and
                                 b.cd_item_nota_entrada = nei.cd_item_nota_entrada     LEFT OUTER JOIN  
    Centro_Custo cc           on b.cd_centro_custo = cc.cd_centro_custo                LEFT OUTER JOIN
    Departamento d            on b.cd_departamento = d.cd_departamento                 LEFT OUTER JOIN
    Status_Bem sb             on b.cd_status_bem = sb.cd_status_bem                    LEFT OUTER JOIN
    Parametro_Ativo pa        on vb.cd_moeda             = pa.cd_moeda                 LEFT OUTER JOIN
    Valor_Moeda vm            on pa.cd_moeda             = vm.cd_moeda                 LEFT OUTER JOIN
    Lancamento_Padrao lp      on lp.cd_lancamento_padrao = gb.cd_lancamento_padrao     LEFT OUTER JOIN
    Plano_Conta       pc      on pc.cd_conta = gb.cd_conta                             LEFT OUTER JOIN
    Valor_Bem_Implantacao vbi on vbi.cd_bem = b.cd_bem                                 LEFT OUTER JOIN
    Plano_Conta pcd           on lp.cd_conta_debito_padrao  = pcd.cd_conta             LEFT OUTER JOIN
    Plano_Conta pcc           on lp.cd_conta_credito_padrao = pcc.cd_conta             LEFT OUTER JOIN
    Tipo_Bem tb               on tb.cd_tipo_bem             = b.cd_tipo_bem

--select * from lancamento_padrao
--select * from plano_conta
 
  where
    b.dt_baixa_bem between @dt_inicial and @dt_final 
    and
    isnull(vb.vl_original_bem,0)>0

  order by 
    gb.nm_grupo_bem,
    b.dt_aquisicao_bem,
    d.nm_departamento,
    b.nm_bem

end


end

--SELECT * FROM CALCULO_BEM
--select * from plano_conta

