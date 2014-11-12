
-------------------------------------------------------------------------------
--pr_consulta_produto_producao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Produtos em Produção
--Data             : 03.09.2005
--Atualizado       : 03.09.3005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_produto_producao
@dt_inicial datetime,
@dt_final   datetime

as

 select
   gp.nm_grupo_produto       as Grupo,
    p.cd_produto             as Codigo,
    p.cd_mascara_produto     as CodigoProduto, 
    p.nm_fantasia_produto    as Fantasia,
    p.nm_produto             as Descricao,
   um.sg_unidade_medida      as Unidade,
    p.ic_producao_produto    as Producao,
    pro.cd_processo_padrao   as Numero,
    pro.nm_processo_padrao   as Processo,
    pro.qt_producao_processo as Tempo,
    up.sg_unidade_medida     as Un,
    pro.qt_processo_padrao   as Qtd    

 from
    Produto p
    left outer join Grupo_Produto gp            on gp.cd_grupo_produto    = p.cd_grupo_produto
    left outer join Unidade_Medida um           on um.cd_unidade_medida   = p.cd_unidade_medida
    left outer join Produto_Producao pp         on pp.cd_produto          = p.cd_produto
    left outer join Processo_Padrao         pro on pro.cd_processo_padrao = pp.cd_processo_padrao
    left outer join Unidade_Medida up           on up.cd_unidade_medida   = pro.cd_unidade_producao
    
 where
    isnull(p.ic_producao_produto,'N') = 'S'

