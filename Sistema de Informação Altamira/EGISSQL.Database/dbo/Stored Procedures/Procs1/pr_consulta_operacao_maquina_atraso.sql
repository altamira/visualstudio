
create procedure pr_consulta_operacao_maquina_atraso

@nm_maquina varchar(40),
@dt_inicial datetime,
@dt_final datetime

as

 select 
   distinct
   m.nm_maquina,
   m.nm_fantasia_maquina,
   pc.dt_estimada_operacao      as 'DataProducao' ,
   p.cd_processo                as 'Processo',
   p.dt_processo                as 'DataProcesso',
   p.qt_prioridade_processo     as 'Prioridade',
   pc.cd_item_processo          as 'Seq',
   o.nm_operacao                as 'Operacao' ,
   pc.qt_hora_estimado_processo as 'Horas',
   pc.dt_prog_mapa_processo     as 'Prog',
   pa.dt_processo_apontamento   as 'Baixa',
  -- pa.qt_processo_apontamento   as 'HorasBaixa',
   p.cd_pedido_venda            as 'Pedido',
   p.cd_item_pedido_venda       as 'Item',
   case
     when isnull(p.cd_pedido_venda,0) > 0 then 
     ( select c.nm_fantasia_cliente from cliente c, pedido_venda pv where c.cd_cliente = pv.cd_cliente and p.cd_pedido_venda = pv.cd_pedido_venda )
     else '' end                as 'Cliente',
   cast(( GetDate() - pc.dt_estimada_operacao ) as int) as 'Atraso'
 from
   Processo_Producao p 
	 inner join Processo_Producao_Composicao pc
	   on p.cd_processo = pc.cd_processo
   inner join Maquina m
     on pc.cd_maquina = m.cd_maquina
   inner join Operacao o
     on pc.cd_operacao = o.cd_operacao
   left outer join  Processo_Producao_Apontamento pa
     on pc.cd_processo = pa.cd_processo and
   		  pc.cd_item_processo = pa.cd_item_processo     
 where
   nm_fantasia_maquina like @nm_maquina + '%'  and
   cast(( GetDate() - pc.dt_estimada_operacao ) as int) > 0 and
   p.cd_status_processo not in (5,6) and
   dt_processo between @dt_inicial and @dt_final
   
 order by  
   m.nm_maquina,
   pc.dt_estimada_operacao
 
