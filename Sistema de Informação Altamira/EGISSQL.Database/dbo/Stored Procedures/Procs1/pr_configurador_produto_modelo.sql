
-------------------------------------------------------------------------------------------------------
--sp_helptext pr_configurador_produto_modelo
-------------------------------------------------------------------------------------------------------
--pr_configurador_produto_modelo
-------------------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Cadastro do Configurador de Produtos
--
--Data             : 22.04.2008
--Alteração        : 25.05.2008
-- 28.04.2008 - Flag para controle da seleção - Carlos Fernandes
-- 06.05.2008 - Modificação para checar a tabela de resultados - Carlos Fernandes
-- 
-------------------------------------------------------------------------------------------------------
create procedure pr_configurador_produto_modelo
@cd_resultado_montagem int = 0
as

--select * from grupo_modelo_produto
--select * from grupo_modelo_composicao
--select * from modelo_produto

select 
  identity(int,1,1)          as cd_controle,
  c.cd_grupo_modelo_pai,
  g.cd_grupo_modelo_produto,
  g.nm_grupo_modelo_produto,
  g.cd_ref_grupo_modelo,
  g.cd_mascara_grupo_modelo,
  g.cd_ordem_grupo_modelo,

  --Composição

  c.cd_item_composicao,
  c.nm_item_composicao,
  c.cd_mascara_composicao,
  'N'                        as ic_selecao,

  --Verifica se houve seleção
  isnull( ( select top 1 1 from Resultado_Montagem rm 
            where
               rm.cd_resultado_montagem   = @cd_resultado_montagem    and
               rm.cd_grupo_modelo_produto = g.cd_grupo_modelo_produto and
               rm.cd_item_composicao      = c.cd_item_composicao ),0)                 as Sel

  --0                          as Sel

  --Modelo Produto

into
  #ConsultaProduto
  
from 
  grupo_modelo_produto g                    with (nolock)
  left outer join grupo_modelo_composicao c with (nolock) on c.cd_grupo_modelo_produto = g.cd_grupo_modelo_produto
--  left outer join resultado_montagem     rm with
order by
  g.cd_ordem_grupo_modelo,
  c.cd_mascara_composicao


select
  *
from
  #ConsultaProduto
order by
  cd_mascara_composicao,
  cd_grupo_modelo_produto

--select * from resultado_montagem
--select * from resultado_montagem_produto
--select * from resultado_montagem_composicao
--select * from montagem_produto
--select * from montagem_produto_composicao
--select * from modelo_produto

