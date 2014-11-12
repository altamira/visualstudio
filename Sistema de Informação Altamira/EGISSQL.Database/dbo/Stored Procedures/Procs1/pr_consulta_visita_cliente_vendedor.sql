
-------------------------------------------------------------------------------
--pr_consulta_visita_cliente_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta da Clientes para de Visita do Vendedor
--Data             : 16/01/2005
--Atualizado       : 23/11/2006 - Modificado esquema da consulta:
-- Quando houver visitas para um vendedor em um cliente na data escolhida, trazer também o cliente que ele
-- vai fazer visita, mesmo que não faça parte da carteira normal do vendedor. 
--                              - Daniel C. Neto.
-- 28.07.2008 - Cálculo do Atraso de Visita - Carlos Fernandes
-- 16.03.2009 - Ajustes Diversos - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_visita_cliente_vendedor
@cd_vendedor    int      = 0,   -- Vendedor
@dt_inicial     datetime = '',  -- Data Inicial
@dt_final       datetime = '',  -- Data Final
@ic_tipo_filtro int      = 0    -- 0 para Geral, 1 para Somente Visitados, 2 Visitas Atrasadas

as

select
  v.nm_fantasia_vendedor                     as Vendedor,
  isnull(v.qt_visita_diaria_vendedor,0)      as QtdVisita,
  c.nm_fantasia_cliente                      as Cliente,
  cv.nm_criterio_visita                      as CriterioVisita,

  UltimaVisita = ( select max(dt_visita)
                   from 
                    visita with (nolock) 
                   where 
                    cd_vendedor = v.cd_vendedor and
                    cd_cliente  = c.cd_cliente  ),

  --cv.qt_dia_criterio_visita
  AtrasoVisita = case when 
                 ( select max(dt_visita) 
                   from 
                    visita with (nolock) 
                   where 
                    cd_vendedor = v.cd_vendedor and
                    cd_cliente  = c.cd_cliente  ) + isnull(cv.qt_dia_criterio_visita,0) < getdate() then 'S' ELSE 'N' END,

  ProximaVisita = isnull(( select max(dt_visita)
                   from 
                    visita with (nolock) 
                   where 
                    cd_vendedor = v.cd_vendedor and
                    cd_cliente  = c.cd_cliente  ),getdate()) + isnull(cv.qt_dia_criterio_visita,0),

  QtdVisitaAgendada = ( select count(*)
                        from
                          Visita with (nolock) 
                        where
                          cd_vendedor = v.cd_vendedor and
                          cd_cliente  = c.cd_cliente  and
                          dt_visita between @dt_inicial and @dt_final  ),

  QtdVisitaRealizada = ( select count(*)
                        from
                          Visita with (nolock) 
                        where
                          cd_vendedor = v.cd_vendedor      and
                          cd_cliente  = c.cd_cliente       and
                          (dt_retorno_visita is not null or cd_visita in ( select cd_visita from visita_baixa )) and 
                          dt_visita between @dt_inicial and @dt_final),

  --select * from visita_baixa

  c.cd_ddd                          as ddd,
  c.cd_telefone                     as Telefone,
  c.nm_dominio_cliente              as Site,
  cast(getdate() - c.dt_cadastro_cliente as int ) as Tempo, 
  ra.nm_ramo_atividade              as Segmento,
  st.nm_status_cliente              as Status,
  p.nm_pais                         as Pais,
  e.sg_estado                       as Estado,
  ci.nm_cidade                      as Cidade,
  c.dt_cadastro_cliente             as DataCadastro,
  cr.nm_cliente_regiao              as Regiao,

  UltimaProposta = ( select max(dt_consulta)
                    from
                       Consulta with (nolock) 
                    where
                       cd_vendedor = v.cd_vendedor and
                       cd_cliente  = c.cd_cliente ),

  UltimaCompra = ( select max(dt_pedido_venda)
                    from
                       Pedido_venda with (nolock) 
                    where
                       cd_vendedor = v.cd_vendedor and
                       cd_cliente  = c.cd_cliente ),

  UltimaNotaFiscal = ( select max(dt_nota_saida)
                    from
                       Nota_Saida with (nolock) 
                    where
                       cd_vendedor = v.cd_vendedor and
                       cd_cliente  = c.cd_cliente ),

  VolumeFaturamento = ( select isnull(sum(ns.vl_total),0.00)
                    from
                       Nota_Saida ns with (nolock) 
                       left outer join operacao_fiscal ofi on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
                    where
                       ns.cd_vendedor = v.cd_vendedor and
                       ns.cd_cliente  = c.cd_cliente  and 
                       isnull(ofi.ic_comercial_operacao,'N') = 'S' and
                       ns.dt_cancel_nota_saida is null )



from
  Vendedor v  with (nolock) 
  inner join (select distinct *
              from (
                     select cd_vendedor, cd_cliente
                     from Visita with (nolock) 
                     where 
    		       dt_visita between @dt_inicial and @dt_final and cd_vendedor is not null
	             union all
	             select cd_vendedor, cd_cliente
	             from Cliente 
	             where 
		       cd_vendedor is not null and
		       @ic_tipo_filtro <> 1 ) a 
	     where
   	       cd_vendedor = case when @cd_vendedor = 0 then cd_vendedor else @cd_vendedor end )  vis on vis.cd_vendedor = v.cd_vendedor

  inner join  Cliente         c      with (nolock) on c.cd_cliente        = vis.cd_cliente
  left outer join Criterio_Visita cv with (nolock) on cv.cd_criterio_visita = c.cd_criterio_visita
  left outer join Status_Cliente  st with (nolock) on st.cd_status_cliente  = c.cd_status_cliente
  left outer join Ramo_atividade  ra with (nolock) on ra.cd_ramo_atividade  = c.cd_ramo_atividade
  left outer join Pais            p  with (nolock) on p.cd_pais             = c.cd_pais 
  left outer join Estado          e  with (nolock) on e.cd_pais             = p.cd_pais and
                                                      e.cd_estado           = c.cd_estado

  left outer join Cidade          ci with (nolock) on c.cd_pais             = ci.cd_pais   and
                                                      c.cd_estado           = ci.cd_estado and
                                                      c.cd_cidade           = ci.cd_cidade 
  left outer join Cliente_Regiao  cr with (nolock) on cr.cd_cliente_regiao  = c.cd_regiao

order by
  v.nm_fantasia_vendedor,
  c.nm_fantasia_cliente

--select * from pais
--select * from estado
--select * from Cidade
--select * from cliente
--select * from vendedor
--select * from criterio_visita
--select * from nota_saida
--select * from operacao_fiscal
--select * from visita

