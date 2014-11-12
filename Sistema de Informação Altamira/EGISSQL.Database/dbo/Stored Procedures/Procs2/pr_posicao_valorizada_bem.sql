
CREATE PROCEDURE pr_posicao_valorizada_bem
---------------------------------------------------------------------------
--pr_posicao_valorizada_bem
---------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
---------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardlso Fernandes
--Banco de Dados       : EGISSQL 
--Objetivo             : Consulta da Posição Valorizada do Bem
--Data                 : 10.01.2005
--Atualizado           : 24.04.2006
---------------------------------------------------------------------------

@cd_grupo_bem int = 0

as

begin

  --select * from grupo_bem
  --select * from valor_bem

  SELECT
    b.cd_bem,
    b.cd_patrimonio_bem                as Patrimonio,
    b.nm_mascara_bem                   as Mascara,
    b.nm_bem                           as Bem,
    b.dt_aquisicao_bem                 as DataAquisicao,
    vb.vl_original_bem                 as ValorAquisicao,
    vb.vl_residual_bem                 as ValorResidual,
    b.dt_aquisicao_bem                 as DataAquisicao,
    b.dt_baixa_bem                     as DataBaixa,
    vb.vl_baixa_bem                    as ValorBaixa,
    d.cd_departamento, 
    d.nm_departamento                  as Departamento,
    cc.cd_centro_custo,
    cc.nm_centro_custo                 as CentroCusto,
    gb.nm_grupo_bem                    as Grupo,
    gb.ic_depreciacao_grupo_bem,
    gb.qt_vida_util_grupo_bem          as VidaUtil,
    gb.pc_depreciacao_grupo_bem        as TaxaDepreciacao,
    sb.cd_status_bem,
    sb.nm_status_bem                   as StatusBem,
    f.nm_fantasia_fornecedor           as Fornecedor,
    nei.cd_nota_entrada,
    nei.cd_serie_nota_fiscal,
    nei.cd_item_nota_entrada,
    vb.cd_moeda,
    vm.vl_moeda, 
    (vb.vl_original_bem / vm.vl_moeda) as vl_total,
    0                                  as ValorAnual,   --Não Lembro a Fórmula depois acertamos ( Carlos 10/1/2005 )
    vb.vl_deprec_acumulada_bem         as ValorDepreciacaoAcumulada,
    vb.pc_depreciado_bem               as PercDepreciadoBem

  FROM
    Bem b                                                             LEFT OUTER JOIN
    Grupo_bem gb           ON b.cd_grupo_bem = gb.cd_grupo_bem        LEFT OUTER JOIN
    Valor_Bem vb           ON b.cd_bem = vb.cd_bem                    LEFT OUTER JOIN
    Fornecedor f           ON b.cd_fornecedor = f.cd_fornecedor       LEFT OUTER JOIN
    Nota_Entrada_item nei  ON b.cd_nota_entrada = nei.cd_nota_entrada and
         b.cd_item_nota_entrada = nei.cd_item_nota_entrada            LEFT OUTER JOIN  
    Centro_Custo cc        ON b.cd_centro_custo = cc.cd_centro_custo  LEFT OUTER JOIN
    Departamento d         on b.cd_departamento = d.cd_departamento   LEFT OUTER JOIN
    Status_Bem sb          on b.cd_status_bem = sb.cd_status_bem      LEFT OUTER JOIN
    Parametro_Ativo pa     ON vb.cd_moeda = pa.cd_moeda               LEFT OUTER JOIN
    Valor_Moeda vm         ON pa.cd_moeda = vm.cd_moeda
  Where
    gb.cd_grupo_bem = case when isnull(@cd_grupo_bem,0) = 0 then gb.cd_grupo_bem else @cd_grupo_bem end   
  Order by 
    d.nm_departamento,
    gb.nm_grupo_bem,
    b.nm_bem

end

--select * from valor_bem

