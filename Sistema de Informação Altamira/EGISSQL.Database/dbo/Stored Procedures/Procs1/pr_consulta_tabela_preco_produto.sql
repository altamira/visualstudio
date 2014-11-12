
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_tabela_preco_produto
-------------------------------------------------------------------------------
--pr_consulta_tabela_preco_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Tabela de Preço de Produto - Carlos Fernandes
--Data             : 20.09.2008
--Alteração        : 
--
--19.11.2008 - Ajustes Diversos - Carlos Fernandes 
------------------------------------------------------------------------------
create procedure pr_consulta_tabela_preco_produto

@nm_fantasia_produto varchar(80) = '' 

as

select 
  p.cd_produto, 
  tp.cd_tabela_preco, 
  gp.cd_grupo_produto,
  um.cd_unidade_medida,
  cp.cd_condicao_pagamento,
  p.cd_mascara_produto,  
  p.nm_fantasia_produto,  
  p.nm_produto,  
  um.sg_unidade_medida,  
  p.qt_multiplo_embalagem,  
  tp.sg_tabela_preco,  
  tpp.qt_tabela_produto,  
  tpp.vl_tabela_produto,  
  tpp.pc_comissao_tabela_produto, 
  tp.nm_tabela_preco, 
  cp.nm_condicao_pagamento,  
  tpp.nm_obs_tabela_produto,  
  gp.nm_grupo_produto,  
  isnull(ic_exporta_tabela_preco,'N') as ic_exporta_tabela_preco

into
  #produto
from  
  produto                              p   with(nolock)
  inner      join tabela_preco_produto tpp with(nolock) on tpp.cd_produto           = p.cd_produto
  left outer join tabela_preco         tp  with(nolock) on tp.cd_tabela_preco       = tpp.cd_tabela_preco
  left outer join grupo_produto        gp  with(nolock) on gp.cd_grupo_produto      = p.cd_grupo_produto
  left outer join unidade_medida       um  with(nolock) on um.cd_unidade_medida     = p.cd_unidade_medida
  left outer join condicao_pagamento   cp  with(nolock) on cp.cd_condicao_pagamento = tpp.cd_condicao_pagamento
order by
  p.cd_produto,
  tpp.qt_tabela_produto 

if @nm_fantasia_produto is null or isnull(@nm_fantasia_produto,'0') = '0'  
  begin
    select * from #produto
    order by
      sg_tabela_preco

  end
else
  select * from #produto where nm_fantasia_produto = @nm_fantasia_produto
  order by
     sg_tabela_preco


--     if isnull(@nm_fantasia_produto,'0') = '0'  
--       begin  
--         select * from #produto order by cd_produto, cd_tabela_preco  
--       end  
--     else  
--       select * from #produto where nm_fantasia_produto = @nm_fantasia_produto order by cd_produto, cd_tabela_preco 
-- 

--select * from tabela_preco

