
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
-- 21.07.2009 - Carlos Fernandes
-- ---------------------------------------------------------------------------------------
-- 
create view vw_inventario_produto_reg74
as

  select distinct
    vw.RECEBTOSAIDA,

    CASE WHEN ISNULL(vw.produto,'')<>'' then
       vw.PRODUTO
    else
       '999999999'
    end                                              as PRODUTO,
    CASE WHEN ISNULL(p.nm_fantasia_produto,'') <> '' then
       p.nm_fantasia_produto
    else
       '999999999'
    end                                              as FANTASIA,

--    VW.PRODUTO,
--    p.nm_fantasia_produto,

    ISNULL(pf.dt_produto_fechamento,vw.RECEBTOSAIDA) as DATAINVENTARIO,

    isnull(pf.qt_atual_prod_fechamento,0)	     as QUANTIDADE,
    isnull(pf.qt_atual_prod_fechamento,0) * 
    isnull(pf.vl_custo_prod_fechamento,0)	     as VALOR,

    1                                                as CODPOSSE, -- Em propriedade do Informante

    e.cd_cgc_empresa                                 as CNPJPOSSE,
    cast('' as varchar(14))                          as IEPOSSE,
--    replace(e.cd_iest_empresa,'.','')                as IEPOSSE,

--  replace(e.cd_iest_empresa,'.','')                as IEPOSSE,
-- Se CODPOSSE for = 1 entao IEPOSSE = 14 espaços em branco
--    '              '                                 as IEPOSSE,  
    isnull(est.sg_estado,'SP')                       as UFPOSSE,
    cast('' as char(45))                             as Brancos

  from      
    vw_produto_registro_geral vw

  inner join Produto p                on p.cd_mascara_produto = vw.PRODUTO
  inner join Produto_Fechamento pf    on pf.cd_produto       = p.cd_produto and
                                         pf.cd_fase_produto  = case when isnull(p.cd_fase_produto_baixa,3) > 0
                                                               then
                                                                 p.cd_fase_produto_baixa
                                                               else 
                                                                 isnull(( select cd_fase_produto 
                                                                   from 
                                                                     parametro_comercial
                                                                   where
                                                                     cd_empresa = dbo.fn_empresa() ),3)  --Acabado
                                                               end               and
 
                                         --pf.cd_fase_produto                = 3 and -- SOMENTE ACABADO

                                         Year( pf.dt_produto_fechamento )  = Year( vw.RECEBTOSAIDA ) and --Fechamentos no mesmo mês
                                         Month( pf.dt_produto_fechamento ) = Month( vw.RECEBTOSAIDA )

  left outer join egisadmin.dbo.empresa e  on e.cd_empresa   = dbo.fn_empresa()
  left outer join estado est               on est.cd_estado = e.cd_estado

  where    
    isnull(pf.qt_atual_prod_fechamento,0) > 0 -- SOMENTE COM SALDO POSITIVO DE ESTOQUE

