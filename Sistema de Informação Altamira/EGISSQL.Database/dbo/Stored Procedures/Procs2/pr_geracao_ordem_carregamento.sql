
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_ordem_carregamento
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Ordem de Carregamento
--Data             : 04.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_geracao_ordem_carregamento
@dt_inicial    datetime = '',
@dt_final      datetime = '',
@cd_nota_saida int      = 0,
@cd_usuario    int      = 0

as


--Temporário para Demonstração

delete from ordem_carregamento
update nota_saida set cd_ordem_carga = 0

--select * from nota_saida

select
  ns.cd_nota_saida,
  ns.dt_nota_saida,
  ns.dt_nota_saida + 1 as dt_prevista_entrega,
  ns.nm_fantasia_nota_saida,
  ns.nm_razao_social_nota,
  ns.cd_cep_nota_saida,
  ns.qt_peso_liq_nota_saida,
  ns.qt_peso_bruto_nota_saida,
  ns.qt_volume_nota_saida,
  ns.nm_especie_nota_saida,
  ns.nm_marca_nota_saida,
--  ns.cd_cep_nota_saida,
  ns.cd_mascara_operacao,
  ns.nm_operacao_fiscal,
  vd.nm_fantasia_vendedor,
  cr.nm_cliente_regiao,
  i.cd_itinerario,
  i.nm_itinerario,
  m.cd_motorista,
  m.nm_motorista,
  v.cd_veiculo,
  v.nm_veiculo,
  v.cd_placa_veiculo,
  vc.qt_peso_bruto_veiculo,
  vc.qt_volume_veiculo

into
  #Calculo_Ordem

--select * from veiculo
--select * from veiculo_capacidade

from
  nota_saida ns                         with (nolock)
  left outer join vendedor vd           on vd.cd_vendedor = ns.cd_vendedor
  left outer join cliente        c      on c.cd_cliente         = ns.cd_cliente
  left outer join cliente_regiao cr     on cr.cd_cliente_regiao = c.cd_regiao
  left outer join Itinerario     i      on cast(ns.cd_cep_nota_saida as int )
                                           between cast(cd_faixa_cep_inicial as int ) and 
                                                   cast(cd_faixa_cep_final as int )       
  left outer join Motorista          m  on m.cd_motorista = i.cd_motorista
  left outer join Veiculo            v  on v.cd_veiculo   = i.cd_veiculo
  left outer join Veiculo_Capacidade vc on vc.cd_veiculo  = i.cd_veiculo
                        
where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.cd_status_nota <> 7                             and
  isnull(ns.cd_ordem_carga,0) = 0

order by
  i.nm_itinerario,
  ns.dt_nota_saida,
  ns.qt_peso_bruto_nota_saida desc

--ordem_carregamento

select
  identity(int,1,1) as cd_ordem_carga,
  cast(convert(varchar(10),getdate(),103) as datetime)  as dt_ordem_carga,
  min(co.dt_prevista_entrega) as dt_prevista_entrega,
  co.cd_itinerario,
  co.cd_veiculo,
  co.cd_motorista,
  null                as dt_saida_ordem_carga,
  null                as dt_entrega_ordem_carga,
  null                as dt_retorno_ordem_carga,
  null                as qt_km_inicial_veiculo,
  null                as qt_km_final_veiculo,
  cast('' as varchar) as ds_ordem_carga,
  cast('' as varchar) as nm_obs_ordem_carga,
  @cd_usuario         as cd_usuario,
  getdate()           as dt_usuario
into
  #Ordem_Carregamento
from
  #Calculo_Ordem co
group by
  co.cd_itinerario,
  co.cd_veiculo,
  co.cd_motorista
 
insert into
  Ordem_Carregamento
select
  *
from
  #Ordem_Carregamento


--Atualiza as Notas Fiscais

update
  nota_saida
set
  cd_ordem_carga = oc.cd_ordem_carga,
  cd_itinerario  = oc.cd_itinerario
from
  nota_saida ns
  inner join #Calculo_Ordem co     on co.cd_nota_saida = ns.cd_nota_saida
  inner join Ordem_Carregamento oc on oc.cd_itinerario = co.cd_itinerario


select * from #Calculo_Ordem
select * from #Ordem_Carregamento


--select * from itinerario
--select * from cliente_regiao
--select cd_regiao,* from cliente where cd_cliente = 737
--select cd_cep_nota_saida,* from nota_saida

--s

-- update
--  nota_saida
-- set
--  cd_cep_nota_saida = replace(cd_cep_nota_saida,'-','')

-- update
--   nota_saida
-- set
--   cd_cep_nota_saida = c.cd_cep
-- from
--   nota_saida ns
--   inner join cliente c on c.cd_cliente = ns.cd_cliente and cd_tipo_destinatario = 1

--select * from nota_saida  where cd_nota_saida = 500730

