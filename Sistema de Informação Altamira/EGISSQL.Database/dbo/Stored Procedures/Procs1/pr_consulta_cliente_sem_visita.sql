
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_cliente_sem_visita
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Cliente sem Visita 
--Data             : 16.03.2009
--Alteração        : 16.03.2009
------------------------------------------------------------------------------
create procedure pr_consulta_cliente_sem_visita
@cd_vendedor int = 0,
@dt_inicial  datetime,
@dt_final    datetime

as

--select * from criterio_visita
--select * from visita
--select * from pedido_venda

select
  identity(int,1,1)    as cd_chave,
  v.cd_vendedor,
  v.nm_fantasia_vendedor,
  c.cd_cliente,
  c.nm_fantasia_cliente,
  cv.nm_criterio_visita,
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
    
into
  #ClienteSemVisita
from
  Cliente c                          with (nolock)
  left outer join Vendedor v         with (nolock) on v.cd_vendedor         = c.cd_vendedor
  left outer join Criterio_Visita cv with (nolock) on cv.cd_criterio_visita = c.cd_criterio_visita
where
  c.cd_vendedor = case when @cd_vendedor = 0 then c.cd_vendedor else @cd_vendedor end 
  and c.cd_cliente not in ( select top 1 cd_cliente from visita where cd_cliente = c.cd_cliente )  

select
  *
from
  #ClienteSemVisita

order by
  nm_fantasia_vendedor,
  6 desc,
  nm_fantasia_cliente  


