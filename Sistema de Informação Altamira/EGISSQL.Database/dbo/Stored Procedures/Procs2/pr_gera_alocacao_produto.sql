
-------------------------------------------------------------------------------
--sp_helptext pr_gera_alocacao_produto
-------------------------------------------------------------------------------
--pr_gera_alocacao_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Alocação de Disponibilidade do Produto
--                   Todos os Produtos do Cadastro
--Data             : 08.11.2008
--Alteração        : 26.11.2008 - Ajustes Diversos - Carlos Fernandes
--
-- 20.02.2009 - Acerto na Tabela de Atendimento do Pedido de Venda
-- 30.04.2009 - Período - Carlos Fernandes
-- 07.05.2009 - Ordem da Alocação - Carlos Fernandes
-- 30.09.2009 - Flag para Não deletar Alocação - Carlos Fernandes
-- 02.10.2009 - Performance - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_alocacao_produto
@cd_usuario         int      = 0,
@dt_inicial         datetime = null,
@dt_final           datetime = null,
@ic_deleta_alocacao char(1) = 'S'

as

--delete from atendimento_pedido_venda

select
  p.cd_produto,
  p.cd_mascara_produto
into
  #Alocacao

from
  produto p                    with (nolock) 
  inner join status_produto sp with (nolock) on sp.cd_status_produto = p.cd_status_produto
where
  isnull(sp.ic_bloqueia_uso_produto,'N') = 'N'

order by
  p.cd_mascara_produto

--select * from #Alocacao
  

declare @cd_produto int
set @cd_produto = 0

while exists( select top 1 cd_produto from #alocacao with (nolock) )
begin

  select top 1 
    @cd_produto = cd_produto
  from 
    #Alocacao with (nolock) 
  order by
    cd_mascara_produto

--  print @cd_produto
--  select @cd_produto

  --Tabela de Atendimento
  --delete from atendimento_pedido_venda where cd_produto = @cd_produto

  --Tabela de Estoque 
  --delete from estoque_pedido_venda     where cd_produto = @cd_produto

  ------------------------------------------------------------------------------
  --Gera a Alocação de Disponibilidade
  ------------------------------------------------------------------------------
  --print @cd_produto,@cd_usuario,@dt_inicial, @dt_final

  exec pr_geracao_alocacao_disponibilidade 
       0,
       @cd_produto,
       @cd_usuario,
       @dt_inicial,
       @dt_final,
       @ic_deleta_alocacao
  
  delete from #Alocacao where cd_produto = @cd_produto

end

drop table #Alocacao

--select * from status_produto

