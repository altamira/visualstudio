
CREATE PROCEDURE pr_consulta_pedidos_programar  
  
@dt_inicial      datetime,  
@dt_final        datetime,
@cd_pedido_venda int = null,
@cd_usuario    int = 0
AS  
  
declare @v_qt_dia_processo_aguardo int  
declare @v_dt_atraso datetime  
declare @cd_vendedor int
  
--Define o vendedor para o cliente
Select 
  @cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario)

 

Select @v_qt_dia_processo_aguardo = qt_dia_processo_aguardo  
from parametro_manufatura  
where cd_empresa = 1 -- Polimold  
  
select distinct  
       d.qt_saldo_pedido_venda as 'QtdeSaldo',  
       d.qt_item_pedido_venda  as 'Qtde',  
       case  
          when a.cd_tipo_pedido = 1 then 'PV'   
          when a.cd_tipo_pedido = 2 then 'PVE'   
          else NULL  
       end as TipoPedido,  
       a.cd_pedido_venda          as 'Pedido',  
       d.cd_item_pedido_venda     as 'Item',  
       d.cd_consulta              as 'Consulta',  
       d.cd_item_consulta         as 'ItemConsulta',  
       b.nm_fantasia_cliente      as 'Cliente',  
      (d.qt_item_pedido_venda *   
       d.vl_unitario_item_pedido) as 'Venda',  
       a.dt_pedido_venda          as 'Emissao',  
       d.dt_entrega_vendas_pedido as 'Comercial',  
       d.nm_produto_pedido        as 'Descricao',  
       MateriaPrima =  
      (select top 1 max(rci.dt_item_nec_req_compra)  
       from requisicao_compra_item rci  
       where rci.cd_pedido_venda = a.cd_pedido_venda and  
             rci.cd_item_pedido_venda = d.cd_item_pedido_venda and  
             rci.cd_mat_prima > 0),  
       MascaraProduto =  
       case  
          when (a.cd_tipo_pedido = 1) or (d.cd_produto > 0) then  
             (select dbo.fn_mascara_produto(cd_produto) from Produto where cd_produto = d.cd_produto)
          when a.cd_tipo_pedido = 2 then    
             (cast(d.cd_grupo_produto as char(2)) + '.99.99.999')  
          else NULL  
       end,  
       Atraso =  
       case  
          when dbo.fn_data_apos_duteis(a.dt_pedido_venda, @v_qt_dia_processo_aguardo) > GETDATE() then  
             CAST((dbo.fn_data_apos_duteis(a.dt_pedido_venda, @v_qt_dia_processo_aguardo) - GETDATE()) as int)  
          else null  
       end,  
       case  
          when rtrim(d.nm_observacao_fabrica1) = '' then NULL  
          else d.nm_observacao_fabrica1  
       end as Observacao1,  
       case  
          when rtrim(d.nm_observacao_fabrica2) = '' then null  
          else d.nm_observacao_fabrica2  
       end as Observacao2,  
       d.dt_entrega_fabrica_pedido as 'Fabrica',  
       d.dt_reprog_item_pedido     as 'Reprogramacao',  
       d.cd_produto,  
       d.cd_grupo_produto,  
       d.cd_consulta,  
       d.cd_item_consulta,  
       d.ic_fatura_item_pedido as 'LibFat'  
  
-------  
into #TmpPedidosGeral  
-------  
  
from Pedido_Venda a   with (nolock)
  
inner Join Cliente b  with (nolock) on   
a.cd_cliente = b.cd_cliente  
  
inner Join Pedido_Venda_Item d  with (nolock) on   
a.cd_pedido_venda = d.cd_pedido_venda   
  
left Join Produto p  with (nolock) on  
d.cd_produto = p.cd_produto  
  
where a.dt_pedido_venda between @dt_inicial and @dt_final  
      and d.dt_entrega_fabrica_pedido is null  
      and d.qt_saldo_pedido_venda > 0  
      and d.dt_cancelamento_item is null  
      and d.ic_controle_pcp_pedido = 'S'  
      and (d.dt_entrega_vendas_pedido <> a.dt_pedido_venda)  
      and d.ic_controle_mapa_pedido = 'S'  
      --Implementada a filtragem das consultas por vendedor para os casos de conexão remota de vendedor/usuário
      --Fabio 24.01.2006
      and IsNull(a.cd_vendedor,0) = ( case @cd_vendedor
                                          when 0 then IsNull(a.cd_vendedor,0)
                                          else @cd_vendedor
                                        end )
      and (a.cd_status_pedido not in (3, 4, 5) or (a.cd_status_pedido = 3 and isnull(d.ic_fatura_item_pedido, 'N') = 'N'))  
  
-- Variáveis para alimentar data de emissão de primeiro e último pedidos  
declare @dt_inicial_emissao datetime  
declare @dt_final_emissao   datetime  
    
select @dt_inicial_emissao = min(Emissao),  
       @dt_final_emissao   = max(Emissao)  
from #TmpPedidosGeral   
where LibFat <> 'S'  
  
------------------------------  
--TEMPOS DE FASES DE ORÇAMENTO  
------------------------------  
  
-- Horas de MO (Fases)  
select a.cd_consulta,  
       a.cd_item_consulta,  
       qt_hora_convencional_fase  = (case when tmo.cd_tipo_mao_obra = 1 then a.qt_hora_item_orcamento  else 0 end),  
       qt_hora_refrigeracao_fase  = (case when tmo.cd_tipo_mao_obra = 4 then a.qt_hora_item_orcamento  else 0 end),  
       qt_hora_CNC_fase           = (case when tmo.cd_tipo_mao_obra = 2 then a.qt_hora_item_orcamento  else 0 end)  
----  
into #TmpConsultaItemOrcamentoCat  
----  
from consulta_item_orcamento_cat a with (nolock),  
     consulta_item_orcamento b with (nolock),  
     #TmpPedidosGeral pg,  
     categoria_orcamento co with (nolock),  
     grupo_orcamento go with (nolock),  
     mao_obra mo with (nolock),  
     tipo_mao_obra tmo  with (nolock) 
where a.cd_consulta            = pg.consulta and  
      a.cd_item_consulta       = pg.itemconsulta and  
      a.cd_consulta            = b.cd_consulta and  
      a.cd_item_consulta       = b.cd_item_consulta and  
      a.cd_item_orcamento      = b.cd_item_orcamento and  
      a.cd_categoria_orcamento = co.cd_categoria_orcamento and  
      co.cd_grupo_orcamento    = go.cd_grupo_orcamento and  
      go.cd_mao_obra           = mo.cd_mao_obra and  
      mo.cd_tipo_mao_obra      = tmo.cd_tipo_mao_obra   
  
-- Totaliza todas as fases  
select cd_consulta,  
       cd_item_consulta,  
       sum(qt_hora_convencional_fase) as qt_hora_convencional_fase,  
       sum(qt_hora_refrigeracao_fase) as qt_hora_refrigeracao_fase,  
       sum(qt_hora_CNC_fase)          as qt_hora_CNC_fase  
into #TmpConsultaItemOrcamento  
from #TmpConsultaItemOrcamentoCat  
group by cd_consulta,  
         cd_item_consulta  
  
-- Horas de mandrilhadora em Refrigeração  
select a.cd_consulta,  
       a.cd_item_consulta,  
       qt_hora_mandrilhadora_refrig = sum((case when isnull(qt_hora_mandrilhadora,0) > 0 then qt_hora_mandrilhadora else 0 end))  
into #TmpConsultaItemOrcamentoRefrigeracao  
from consulta_item_orcamento_refrigeracao a with (nolock),  
     #TmpPedidosGeral pg  
where a.cd_consulta      = pg.consulta and  
      a.cd_item_consulta = pg.itemconsulta  
group by a.cd_consulta,  
         a.cd_item_consulta  
  
-- Horas de mandrilhadora em Alojamento  
select a.cd_consulta,  
       a.cd_item_consulta,  
       qt_hora_mandrilhadora_aloj = sum((case when isnull(qt_hora_mandrilhadora,0) > 0 then qt_hora_mandrilhadora else 0 end))  
into #TmpConsultaItemOrcamentoAlojamento  
from consulta_item_orcamento_alojamento a with (nolock),  
     #TmpPedidosGeral pg  
where a.cd_consulta      = pg.consulta and  
      a.cd_item_consulta = pg.itemconsulta  
group by a.cd_consulta,  
         a.cd_item_consulta  
  
-- Seleciona (por Placa) total de horas : CNC, Convencional, Refrigeração e Mandrilhadora (Agregadas)  
select a.cd_consulta,  
       a.cd_item_consulta,  
       qt_hora_convencional =  case when cd_tipo_mao_obra = 1  then isnull(qt_hora_item_serv_manual,0) else 0 end,   
       qt_hora_CNC =           case when cd_tipo_mao_obra = 2  then isnull(qt_hora_item_serv_manual,0) else 0 end,  
       qt_hora_refrigeracao =  case when cd_tipo_mao_obra = 4   then isnull(qt_hora_item_serv_manual,0) else 0 end,   
       qt_hora_mandrilhadora = case when ic_tipo_mao_obra = 'M' then isnull(qt_hora_item_serv_manual,0) else 0 end  
into #TmpServicoManual  
from consulta_item_orcamento_servico_manual a with (nolock),  
     #TmpPedidosGeral pg  
where a.cd_consulta      = pg.consulta and  
      a.cd_item_consulta = pg.itemconsulta  
  
-- Variáveis referente serviços agregados  
declare @qt_hora_CNC            float  
declare @qt_hora_convencional   float  
declare @qt_hora_refrigeracao   float  
declare @qt_hora_mandrilhadora  float  
  
-- Seleciona TOTAL de horas agregadas em SERVIÇOS MANUAIS  
select cd_consulta,  
       cd_item_consulta,  
       sum(isnull(qt_hora_CNC,0))           as qt_hora_CNC,  
       sum(isnull(qt_hora_convencional,0))  as qt_hora_convencional,  
       sum(isnull(qt_hora_refrigeracao,0))  as qt_hora_refrigeracao,  
       sum(isnull(qt_hora_mandrilhadora,0)) as qt_hora_mandrilhadora  
into #TmpConsultaItemOrcamentoServicoManual  
from #TmpServicoManual  
group by cd_consulta,  
         cd_item_consulta  
  
select  
   a.cd_consulta,  
   a.cd_item_consulta,   
   round(isnull(qt_hora_CNC,0) + isnull(qt_hora_CNC_fase,0),2) as AG_H_Cnc,  
   round(isnull(qt_hora_convencional,0) + isnull(qt_hora_convencional_fase,0),2) as AG_H_Convencional,  
   round(isnull(qt_hora_refrigeracao,0) + isnull(qt_hora_refrigeracao_fase,0),2) as AG_H_Refrigeracao,  
   round(isnull(qt_hora_mandrilhadora,0) + isnull(qt_hora_mandrilhadora_refrig,0) +  
      isnull(qt_hora_mandrilhadora_aloj,0),2)                   as AG_H_Mandrilhadora  
-------  
into #TmpTemposFases  
-------  
from #TmpConsultaItemOrcamento a  
-------  
left outer join #TmpConsultaItemOrcamentoRefrigeracao ref  on  
a.cd_consulta = ref.cd_consulta and  
a.cd_item_consulta = ref.cd_item_consulta  
  
left outer join #TmpConsultaItemOrcamentoAlojamento aloj   on  
a.cd_consulta = aloj.cd_consulta and  
a.cd_item_consulta = aloj.cd_item_consulta  
  
left outer join #TmpConsultaItemOrcamentoServicoManual man on  
a.cd_consulta = man.cd_consulta and  
a.cd_item_consulta = man.cd_item_consulta  
  
------------------  
--FIM TEMPOS FASES  
------------------  
  
select a.*,  
       d.AG_H_Cnc           as CNC,  
       d.AG_H_Convencional  as Conv,  
       d.AG_H_Refrigeracao  as Refrig,  
       d.AG_H_Mandrilhadora as Mandr,  
       IsNull(a.Observacao1, '') + IsNull(a.Observacao2, '') as ObservacaoCompEspecial,  
       @dt_inicial_emissao as 'EmissaoInicial',  
       @dt_final_emissao   as 'EmissaoFinal',  
       isnull(b.ic_orcamento_consulta, 'S') as 'Orcamento',  
       c.nm_processista  
-------  
from #TmpPedidosGeral a  
-------  
left join Consulta_Itens b with (nolock) on  
a.cd_consulta = b.cd_consulta and  
a.cd_item_consulta = b.cd_item_consulta   
  
left join #TmpTemposFases d on  
a.cd_consulta = d.cd_consulta and  
a.cd_item_consulta = d.cd_item_consulta   
  
left outer join Processo_Producao c with (nolock) on  
a.Pedido = c.cd_pedido_venda and   
a.Item = c.cd_item_pedido_venda  
  
where a.LibFat <> 'S'  
  
order by isnull(a.Reprogramacao, a.Fabrica),  
         Year(a.Emissao),  
         a.Observacao1,  
         a.TipoPedido,  
         a.MascaraProduto,  
         a.Emissao,  
         a.Comercial  
  
drop table #TmpPedidosGeral  

