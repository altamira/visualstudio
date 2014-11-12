


CREATE PROCEDURE pr_consulta_programacao_periodo

--sp_helptext pr_consulta_programacao_periodo
------------------------------------------------------------------------------------------------------
--pr_consulta_programacao_periodo
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2007
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Carlos Cardoso Fernandes
--Banco de Dados  : EgisSQL
--Objetivo        : Consultar Operações Programadas por Período
--Data            : 02/09/2007
--09.10.2008 - Consulta da Sequência do Período - Carlos Fernandes
--10.10.2008 - Campo única para consulta - Carlos Fernandes
--19.05.2009 - Verificação e Ajustes - Carlos Fernandes
--15.03.2010 - Não Mostrar OP's canceladas e Op's Encerradas - Carlos Fernandes/Luis
------------------------------------------------------------------------------------------------------

@dt_inicial       datetime,
@dt_final         datetime,
@ic_tipo_consulta char(1) = 'T'  --(A) Aberta / (C) Concluídas / (T) Todas

AS

--Todas

if @ic_tipo_consulta is null
   set @ic_tipo_consulta = 'T' 

SELECT     

  identity(int,1,1)                                              as cd_controle,
  case when p.dt_programacao<getdate() then 'Sim' else 'Não' end as ic_Atraso,
  p.dt_programacao,
  m.cd_maquina,
  m.nm_fantasia_maquina,
  m.nm_maquina,
  o.nm_fantasia_operacao, 
  pp.cd_identifica_processo, 
  pp.cd_pedido_venda, 
  pp.cd_item_pedido_venda, 
  ppc.dt_ini_prod_operacao,
  cast(GetDate() as integer) - cast(ppc.dt_ini_prod_operacao as integer) as 'Atraso',
  ppc.cd_processo, 
  ppc.cd_item_processo,
  ppc.qt_hora_prog_operacao, 
  ppc.nm_obs_operacao, 
  ppc.cd_ordem_fab,
  pvi.nm_produto_pedido as Descricao,
  ppc.ic_cnc_operacao,
  c.nm_fantasia_cliente,
  prod.cd_mascara_produto,
  prod.nm_fantasia_produto,
  isnull(prod.nm_produto,pvi.nm_produto_pedido) as nm_produto,
  um.sg_unidade_medida,
  pj.cd_interno_projeto,
  pjc.nm_projeto_composicao,
  pjm.nm_esp_projeto_material,
  fp.nm_fase_produto,
  sp.nm_status_processo,
  ppc.dt_fim_prod_operacao,
  pp.dt_canc_processo,
  pp.cd_status_processo

--select * from programacao_composicao

into
  #Consulta_Mapa_Periodo

FROM 

  Programacao p                               with (nolock)
  inner join       Programacao_Composicao ppc with (nolock) on p.cd_programacao    = ppc.cd_programacao 
  left outer join  Maquina m                  with (nolock) on p.cd_maquina        = m.cd_maquina 
  left outer join  Operacao o                 with (nolock) ON o.cd_operacao       = ppc.cd_operacao
  left outer join  Processo_Producao pp       with (nolock) ON ppc.cd_processo     = pp.cd_processo
  left outer join  Pedido_Venda pv            with (nolock) ON pp.cd_pedido_venda  = pv.cd_pedido_venda 
  left outer join  Pedido_venda_item pvi      with (nolock) on pvi.cd_pedido_venda = pp.cd_pedido_venda and
                                                               pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
  left outer join  Cliente c                  with (nolock) on c.cd_cliente = pv.cd_cliente
  left outer join  Produto prod               with (nolock) on prod.cd_produto = pp.cd_produto
  left outer join  Unidade_Medida um          with (nolock) on um.cd_unidade_medida = prod.cd_produto
  left outer join Projeto         pj              with (nolock) on pj.cd_projeto            = pp.cd_projeto
  left outer join Projeto_Composicao pjc          with (nolock) on pjc.cd_projeto           = pp.cd_projeto and
                                                                   pjc.cd_item_projeto      = pp.cd_item_projeto    
  left outer join Projeto_Composicao_Material pjm with (nolock) on pjm.cd_projeto           = pp.cd_projeto and
                                                                   pjm.cd_item_projeto      = pp.cd_item_projeto and
                                                                   pjm.cd_projeto_material  = pp.cd_projeto_material
   left outer join Fase_Produto fp          with (nolock)       on fp.cd_fase_produto       = pp.cd_fase_produto
   left outer join Status_Processo sp       with (nolock)       on sp.cd_status_processo    = pp.cd_status_processo 

WHERE
  p.dt_programacao between @dt_inicial and @dt_final and  
  --(ppc.dt_fim_prod_operacao is null) and
  IsNull(o.nm_fantasia_operacao,'') <> ''

--Deleta as OP's Canceladas e Encerradas

   delete from #Consulta_Mapa_Periodo
   where
      cd_processo <> 0 and
      ( dt_canc_processo is not null or cd_status_processo = 5 )


------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

--select * from programacao

if @ic_tipo_consulta =  'A' --Abertas
begin
  select
    *
  from
    #Consulta_Mapa_Periodo
  where
   (dt_fim_prod_operacao is null) 

  order by
    dt_programacao desc
end

if @ic_tipo_consulta =  'C' --Abertas
begin
  select
    *
  from
    #Consulta_Mapa_Periodo
  where
   (dt_fim_prod_operacao is not null) 

  order by
    dt_programacao desc
end

if @ic_tipo_consulta =  'T' --Abertas
begin
  select
    *
  from
    #Consulta_Mapa_Periodo

  order by
    dt_programacao desc
end
  

