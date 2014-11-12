
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_tabela_preco_periodo
-------------------------------------------------------------------------------
--pr_geracao_tabela_preco_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Geração da Tabela de Preço de Venda por Período
--
--Data             : 05.05.2010
--Alteração        : 
-- 03.06.2010 - Alterado para Valagro cálculo Mês Maio/2010
--
------------------------------------------------------------------------------
create procedure pr_geracao_tabela_preco_periodo
@cd_tabela_preco  int = 0,
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@dt_inicio_tabela datetime = '',
@dt_fim_tabela    datetime = '',
@cd_usuario       int

as

declare @cd_tabela_periodo int
declare @i                 int

select
  @cd_tabela_periodo = isnull(cd_tabela_periodo,0) + 1
from
  tabela_periodo_preco_produto with (nolock) 

set @cd_tabela_preco  = 11
set @dt_inicial       = '05/01/2010'
set @dt_final         = '05/31/2010'

set @dt_inicio_tabela = '05/01/2010'
set @dt_fim_tabela    = '05/31/2010'

select 
  t.cd_tabela_preco,
  isnull(t.vl_fator_imposto_tabela,0)   as vl_fator_imposto_tabela,
  isnull(cg.pc_desconto_tabela_grupo,0) as pc_desconto_tabela_grupo

into
  #TabelaPreco

from 
  tabela_preco t                   with (nolock) 
  left outer join cliente_grupo cg with (nolock) on cg.cd_cliente_grupo = t.cd_cliente_grupo
where
  cd_tabela_preco <> @cd_tabela_preco

--select * from #TabelaPreco

--select * from cliente_grupo
--select * from tabela_preco

declare @cd_tabela_origem         int
declare @vl_fator_imposto_tabela  float
declare @pc_desconto_tabela_grupo float

set @i = 1

while exists ( select top 1 cd_tabela_preco from #TabelaPreco )
begin

  select top 1
     @cd_tabela_origem         = isnull(cd_tabela_preco,0),
     @vl_fator_imposto_tabela  = case when isnull(vl_fator_imposto_tabela,1) <> 0 
                                 then 
                                   vl_fator_imposto_tabela
                                 else
                                   1
                                 end,
     @pc_desconto_tabela_grupo = isnull(pc_desconto_tabela_grupo,0)
  from
    #TabelaPreco

  select 
    @cd_tabela_periodo  as cd_tabela_periodo,
    @dt_inicio_tabela   as dt_inicio_tabela,
    @dt_fim_tabela      as dt_final_tabela,
    @cd_tabela_origem   as cd_tabela_preco,
    cd_produto,
    (vl_tabela_produto/@vl_fator_imposto_tabela)
    -
    ( (vl_tabela_produto/@vl_fator_imposto_tabela) * (@pc_desconto_tabela_grupo/100) ) as vl_tabela_produto,
   cd_moeda,
   cd_aplicacao_markup,
   vl_custo_tabela_produto,
   nm_obs_tabela_produto,
   qt_tabela_produto,
   cd_unidade_medida,
   pc_comissao_tabela_produto,
   cd_condicao_pagamento,
   cd_unidade_unidade,
   @cd_usuario          as cd_usuario,
   getdate()            as  dt_usuario,
   identity(int,1,1)    as cd_interface

   into
    #tabela_periodo_preco_produto 
   from
    tabela_periodo_preco_produto 
   where
    cd_tabela_preco  = @cd_tabela_preco and
    dt_inicio_tabela = @dt_inicial     and
    dt_final_tabela  = @dt_final

    update
      #tabela_periodo_preco_produto 
    set
      cd_tabela_periodo  = cd_tabela_periodo + cd_interface

    select * from #tabela_periodo_preco_produto 

    insert into
       tabela_periodo_preco_produto 
    select 
      *
    from
      #tabela_periodo_preco_produto 
      

    drop table #tabela_periodo_preco_produto 

    delete from #TabelaPreco 
    where
      cd_tabela_preco = @cd_tabela_origem


 
end


-- select
--   *
-- from
--   tabela_periodo_preco_produto 



--delete from tabela_periodo_preco_produto where cd_tabela_periodo > 379

