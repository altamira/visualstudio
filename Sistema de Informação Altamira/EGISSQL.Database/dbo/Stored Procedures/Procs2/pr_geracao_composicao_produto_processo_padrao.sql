
--sp_helptext pr_geracao_composicao_produto_processo_padrao

-------------------------------------------------------------------------------
--pr_geracao_composicao_produto_processo_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Composição do Produto com Árvore do Processo
--                   Padrão 
--Data             : 28.04.2007
--Alteração        : 27.07.2007
------------------------------------------------------------------------------
create procedure pr_geracao_composicao_produto_processo_padrao

as

select 
  pp.*,
  p.nm_fantasia_produto,
  p.cd_mascara_produto,
  p.nm_produto,
  p.cd_grupo_produto,
  gp.nm_grupo_produto,
  ppp.cd_produto as cd_produto_componente,
  ppp.cd_fase_produto,
  ppp.qt_produto_processo,
  ppp.cd_ordem,
  pp.cd_produto as cd_produto_pai
into
  #ProdutoProcesso
from 
  Produto_Producao pp
  left outer join Produto p                   on  p.cd_produto=pp.cd_produto 
  left outer join Grupo_Produto gp            on gp.cd_grupo_produto=p.cd_grupo_produto 
  left outer join Processo_Padrao_Produto ppp on ppp.cd_processo_padrao = pp.cd_processo_padrao
where
  isnull(ppp.cd_produto,0)>0 and
  p.cd_mascara_produto is not null

delete from #ProdutoProcesso 
where
  cd_produto_pai in ( select cd_produto_pai from produto_composicao )


select * from #ProdutoProcesso
  
--select * from processo_padrao_produto

--select * from produto_composicao
-- 

select
  cd_produto_pai

into #controle
from
  #ProdutoProcesso
group by 
  cd_produto_pai

select
  * 
from
  #controle


declare @cd_produto_pai int

while exists( select top 1 cd_produto_pai from #controle )
begin
  select top 1
    @cd_produto_pai = cd_produto_pai
  from
    #controle
  order by cd_produto_pai 

  select
  pp.cd_produto_pai,
  pp.cd_produto_componente as cd_produto,
  pp.cd_ordem              as cd_item_produto,
  pp.qt_produto_processo   as qt_item_produto,
  pp.qt_produto_processo   as qt_produto_composicao,
  null                     as qt_peso_liquido_produto,
  null                     as qt_peso_bruto_produto,
  pp.cd_ordem              as cd_ordem_produto,
  pp.cd_fase_produto       as cd_fase_produto,
  null                     as cd_materia_prima,
  null                     as cd_bitola,
  99                       as cd_usuario,
  getdate()                as dt_usuario,
  null                     as nm_obs_produto_composicao,
  null                     as ic_calculo_peso_produto,
  null                     as   pc_composicao_produto,
  null                     as   ic_montagemg_produto,
  null                     as   ic_montagemq_produto,
  null                     as   ic_tipo_montagem_produto,
  1                        as   cd_versao_produto_comp,
  pp.cd_ordem              as   cd_ordem_produto_comp,
  null                     as   cd_produto_composicao,
  1                        as   cd_versao_produto,
  p.cd_mascara_produto     as nm_produto_comp
into
  #Produto_Composicao
from
  #ProdutoProcesso pp
  left outer join produto p on p.cd_produto = pp.cd_produto_componente
where
  pp.cd_produto_pai = @cd_produto_pai
--select * from produto

 insert into
   produto_composicao
 select
   *
 from
   #Produto_Composicao

-- where
--   cd_produto_pai = 5

  drop table #produto_composicao


  delete from #controle where cd_produto_pai = @cd_produto_pai

end


drop table #ProdutoProcesso
  



