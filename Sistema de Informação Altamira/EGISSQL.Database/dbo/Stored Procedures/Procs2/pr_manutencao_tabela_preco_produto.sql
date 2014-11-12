
-------------------------------------------------------------------------------
--sp_helptext pr_manutencao_tabela_preco_produto
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 9.12.2008
--Alteração        : 26.12.2008 - Ajustes Diversos - Parâmetros
--                                Geração da Tabela Automática para todos os produtos
--
--
------------------------------------------------------------------------------
create procedure pr_manutencao_tabela_preco_produto
@cd_produto   int = 0,
@ic_parametro int = 0,
@cd_usuario   int = 0

as  

if @ic_parametro = 0
begin
 
  ------------------------------------------------------------------------------
  --Consulta
  ------------------------------------------------------------------------------

  select   
    p.cd_produto,  
    tpp.cd_usuario,
    tpp.dt_usuario, 
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
  from    
    produto                              p   with(nolock)  
    inner join tabela_preco_produto tpp      with(nolock) on tpp.cd_produto           = p.cd_produto  
    left outer join tabela_preco         tp  with(nolock) on tp.cd_tabela_preco       = tpp.cd_tabela_preco  
    left outer join grupo_produto        gp  with(nolock) on gp.cd_grupo_produto      = p.cd_grupo_produto  
    left outer join unidade_medida       um  with(nolock) on um.cd_unidade_medida     = p.cd_unidade_medida  
    left outer join condicao_pagamento   cp  with(nolock) on cp.cd_condicao_pagamento = tpp.cd_condicao_pagamento  
  where 
    p.cd_produto = case when isnull(@cd_produto,0) = 0 then p.cd_produto else @cd_produto end 
  order by  
    p.cd_produto,  
    tp.nm_tabela_preco,   
    tpp.qt_tabela_produto   

end

------------------------------------------------------------------------------
--Montagem da Tabela de Preço para o Produto com todas as Tabelas
------------------------------------------------------------------------------
if @ic_parametro = 1
begin

  --select * from tabela_preco_produto

  select
    tp.cd_tabela_preco,
    @cd_produto         as cd_produto,
    null                as vl_tabela_produto,
    @cd_usuario         as cd_usuario,
    getdate()           as dt_usuario,
    cast('' as varchar) as nm_obs_tabela_produto,
    null                as cd_aplicacao_markup,
    null                as vl_custo_tabela_produto,
    1                   as cd_moeda,
    null                as qt_tabela_produto,
    null                as cd_unidade_medida,
    null                as pc_comissao_tabela_produto,
    null                as cd_condicao_pagamento
  into
    #Tabela_Preco_Produto
  from
    Tabela_Preco tp
  where
    isnull(tp.ic_status_tabela_preco,'A')='A'

  insert into Tabela_Preco_Produto
  select
    *
  from
    #Tabela_Preco_Produto
    
--select * from tabela_preco
  
end

