
-------------------------------------------------------------------------------
--pr_acompanhamento_meta_prospeccao_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de prospeccao realizadas por período por Operador
--Data             : 14/01/2005
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_acompanhamento_meta_prospeccao_vendedor
@dt_inicial datetime,
@dt_final   datetime --,
as

--select * from cliente_prospeccao
--select * from prospeccao
--select * from vendedor
--select * from operador_telemarketing
--select * from meta_prospeccao_vendedor

select
  max(o.nm_operador_telemarketing)                      as Operador,
  isnull(count(*),0)                                    as Realizado,
  MetaProspect = ( select isnull(m.qt_ligacao_meta,0) from  Meta_Prospeccao_Vendedor m 
                                                      where m.cd_operador_telemarketing = o.cd_operador_telemarketing and m.dt_inicio=@dt_inicial and m.dt_final=@dt_final )
into
  #AuxMetaProspeccao
from
  Prospeccao p left outer join
  Operador_Telemarketing o on o.cd_operador_telemarketing = p.cd_operador_telemarketing
where
  p.dt_prospeccao between @dt_inicial and @dt_final
group by
  o.cd_operador_telemarketing


--Apresenta a Tabela Final

select *,
  cast( (Realizado/MetaProspect)*100 as decimal(25,2) ) as  PercRealizado,
  0.00 as Projecao,
  0.00 as Necessario,
  0.00 as Posicao
from 
  #AuxMetaProspeccao
 
