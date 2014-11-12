--pr_consulta_orcamento_aberto_EGIS
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Consultas em aberto para Orçamento
--Data         : 15.05.2001
--Atualizado   : 28.06.2001 - Lucio
--             : 13.11.2002 - Lucio 
--             : 15.12.2004 Lucio
--             : 22.06.2005 Inclusão do Grupo de Produto : Lucio
-----------------------------------------------------------------------------------
create procedure pr_consulta_orcamento_aberto_EGIS

@ic_parametro      int,
@cd_departamento   int,
@dt_inicial        datetime,
@dt_final          datetime

-- Parâmetro 0 = Departamento Selecionado ou GERAL : foi corrigido

as

if ( @ic_parametro = 0 )
begin

   select 
      e.nm_status_proposta         as 'status',
      b.dt_item_consulta           as 'Data',
      f.nm_fantasia_cliente        as 'Cliente',
      b.cd_consulta                as 'Numero',
      b.cd_consulta                as 'cd_consulta',
      b.cd_item_consulta           as 'Item',
      b.cd_item_consulta           as 'cd_item_consulta',
      b.cd_grupo_produto           as 'Grupo',
      b.nm_fantasia_produto        as 'Produto',
      b.nm_produto_consulta        as 'Descricao',
      b.qt_item_consulta           as 'Qtd',
      d.nm_fantasia_vendedor       as 'Setor',
      a.cd_vendedor_interno        as 'Interno',
      b.qt_dia_entrega_consulta    as 'DiasUteis',
      b.dt_entrega_consulta        as 'Entrega',
      b.vl_lista_item_consulta     as 'Lista', 
      b.vl_unitario_item_consulta  as 'Unitario',
      b.cd_consulta_representante  as 'ConsultaRepres',
      b.cd_item_consulta_represe   as 'ItemConsultaRepres'

   from
       consulta a, 
       consulta_itens b, 
       Grupo_Produto_Departamento c,
       vendedor d,
       status_proposta e,
       cliente f 

   where
      (a.dt_consulta between @dt_inicial and 
                             @dt_final)           and 
       a.cd_consulta         = b.cd_consulta      and
       b.dt_perda_consulta_itens is null          and
--     b.dt_fechamento_pedido is null             and
       b.ic_orcamento_consulta = 'S'              and
       isnull(b.dt_orcamento_liberado_con,'') = '' and -- Data de liberação do orçamento
       b.dt_perda_consulta_itens is null          and 
       b.cd_grupo_produto    = c.cd_grupo_produto and
     ((@cd_departamento = 0) or
      (c.cd_departamento = @cd_departamento))     and
       c.ic_orcamento        = 'S'                and
       a.cd_vendedor         = d.cd_vendedor      and
       a.cd_cliente          = f.cd_cliente       and
       a.cd_status_proposta *= e.cd_status_proposta

   order by 
       a.cd_consulta, 
       b.cd_item_consulta

end

