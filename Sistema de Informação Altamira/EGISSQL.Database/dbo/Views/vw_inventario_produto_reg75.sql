
-- ---------------------------------------------------------------------------------------
-- vw_inventario_produto_reg74
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure : Microsoft SQL Server 2000
-- Autor(es)        : Alexandre Del Soldato
-- Banco de Dados   : EgisSql
-- Objetivo         : Lista Regitro de Invetário de Produto utilizado nos Arquivos Magnéticos
-- Data             : 22/03/2004
-- Atualizado       : 14.08.2007 - Acertos Diversos - Carlos Fernandes
-- ---------------------------------------------------------------------------------------
-- 

--sp_helptext vw_inventario_produto_reg75

create view vw_inventario_produto_reg75
as

  select distinct
    '75'                                             as TIPOREG,
    vw.RECEBTOSAIDA,
    ltrim(rtrim(vw.PRODUTO))                         as CODIGOPRODUTO,
    ltrim(rtrim(p.nm_fantasia_produto))              as FANTASIA,
    replace(cf.cd_mascara_classificacao,'.','')      as CLASSIFICACAOFISCAL,
    ltrim(rtrim(p.nm_produto))                       as DESCRICAOPRODUTO,
    um.sg_unidade_medida                             as UNIDADE,
    cf.pc_ipi_classificacao                          as IPI,
    case when isnull(pfi.pc_aliquota_icms_produto,0)>0 
    then
     pfi.pc_aliquota_icms_produto
    else
     ep.pc_aliquota_icms_estado
    end                                              as ICMS,

    case when isnull(cf.ic_subst_tributaria,'N')='S'
    then
     isnull(ep.qt_base_calculo_icms,0)
    else
     0.00
    end                                              as REDUCAOICMS,

    0.00                                             as BASEICMSST    

  from      
    vw_inventario_produto_reg74 vw
    
  inner join Produto p                     with (nolock) on p.cd_mascara_produto              = vw.PRODUTO
  left outer join Produto_Fiscal pfi       with (nolock) on pfi.cd_produto                    = p.cd_produto
  left outer join Classificacao_Fiscal cf  with (nolock) on cf.cd_classificacao_fiscal        = pfi.cd_classificacao_fiscal
  left outer join Unidade_Medida um        with (nolock) on um.cd_unidade_medida              = p.cd_unidade_medida
  left outer join egisadmin.dbo.empresa e  with (nolock) on e.cd_empresa   = dbo.fn_empresa()
  left outer join estado est               with (nolock) on est.cd_estado  = e.cd_estado
  left outer join estado_parametro ep      with (nolock) on ep.cd_pais     = e.cd_pais and
                                                            ep.cd_estado   = e.cd_estado


