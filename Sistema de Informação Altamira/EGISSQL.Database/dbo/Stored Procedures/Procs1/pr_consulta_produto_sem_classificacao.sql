
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_produto_sem_classificacao
-------------------------------------------------------------------------------
--pr_consulta_produto_sem_classificacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta de Produtos sem Classificação
--                   Ministério da Agricultura / Abisolo
--
--Data             : 01/11/2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_produto_sem_classificacao
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--Tabelas

--> Produto
--> Produto_Classificacao
--> Status_Produto

select
  p.cd_mascara_produto                    as Codigo,
  p.nm_fantasia_produto                   as Fantasia,
  p.nm_produto                            as Descricao,
  sp.nm_status_produto                    as Status,

  case when isnull(pc.cd_classificacao,0)=0 
  then 
    'N' 
  else
    'S'
  end                                      as Ministerio,

  case when isnull(pc.cd_classificacao_abisolo,0)=0 
  then 
    'N' 
  else
    'S'
  end                                       as Abisolo 
  
from
  Produto p                                 with (nolock) 
  inner join       Status_Produto sp        with (nolock) on sp.cd_status_produto = p.cd_status_produto
  left  outer join Produto_Classificacao pc               on pc.cd_produto        = p.cd_produto

where
  isnull(sp.ic_bloqueia_uso_produto,'N')='N'   --> Status do Produto, para não Bloquear sua Utilização
  and
  ( isnull(pc.cd_classificacao,0)=0 or isnull(pc.cd_classificacao_abisolo,0)=0 )

order by

  p.nm_fantasia_produto
 

