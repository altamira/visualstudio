
-------------------------------------------------------------------------------
--pr_comissao_agente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Comissão de Agentes 
--Data             : 16.08.2005
--Atualizado       : 16.08.2005
--Alteração	   : 19.08.2005 - Wellington Souza Fagundes
--Desc. Alteração  : Acréscimo dos campos cd_DDD_Agente e cd_fone_agente da
--                   tabela agente
--                 : 25.08.2005 - Soma da Nota Fiscal de Saída / Entrada
--------------------------------------------------------------------------------------------------
create procedure pr_comissao_agente
@cd_agente  int = 0,
@dt_inicial datetime,
@dt_final   datetime

as

--select * from agente
--select * from agente_produto
--select * from nota_saida_item
--select * from nota_entrada_item

select
  ag.cd_agente,
  ag.nm_agente          as agente,
  ag.nm_fantasia_agente as fantasia,
  ag.cd_DDD_agente      as DDD,
  ag.cd_fone_agente     as fone, 
  ta.nm_tipo_agente,
  ag.pc_comissao_agente,
  ap.cd_produto,
   p.cd_mascara_produto,
   p.nm_fantasia_produto,
   p.nm_produto,
  um.sg_unidade_medida,
  ap.pc_comissao_agente_produto,
  qt_faturada = ( select 
                  sum(qt_item_nota_saida) 
                from nota_saida_item 
                where cd_produto = ap.cd_produto and
                      dt_cancel_item_nota_saida is null and
                      dt_nota_saida between @dt_inicial and @dt_final
                group by
                  cd_produto ),
  vl_faturado = ( select 
                  sum(qt_item_nota_saida * vl_unitario_item_nota) 
                from nota_saida_item 
                where cd_produto = ap.cd_produto and
                      dt_cancel_item_nota_saida is null and
                      dt_nota_saida between @dt_inicial and @dt_final
                group by
                  cd_produto ),
  qt_entrada = ( select 
                  sum(qt_item_nota_entrada) 
                from nota_entrada_item 
                where cd_produto = ap.cd_produto and
                      dt_item_receb_nota_entrad between @dt_inicial and @dt_final
                group by
                  cd_produto ),
  vl_entrada = ( select 
                  sum( qt_item_nota_entrada * vl_item_nota_entrada ) 
                from nota_entrada_item 
                where cd_produto = ap.cd_produto and
                      dt_item_receb_nota_entrad between @dt_inicial and @dt_final
                group by
                  cd_produto ),
  case when isnull(ag.pc_comissao_agente,0)=0 then isnull(ap.pc_comissao_agente_produto,0) else ag.pc_comissao_agente end as pc_comissao
   
into #ComissaoAgente
from
  Agente ag
  left outer join Tipo_Agente ta    on ta.cd_tipo_agente    = ag.cd_tipo_agente
  left outer join Agente_Produto ap on ap.cd_agente         = ag.cd_agente
  left outer join Produto p         on p.cd_produto         = ap.cd_produto
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
where
  isnull(ag.ic_ativo_agente,'N') = 'S' 
  and ag.cd_agente =  case when isnull(@cd_agente,0) = 0
				then
					isnull(ag.cd_agente,0)
				else
					@cd_agente
				end	

select
  *,
  vl_comissao = vl_entrada * (pc_comissao/100) 
from
  #ComissaoAgente
 

