
-------------------------------------------------------------------------------
--pr_registro_numeracao_notas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_registro_numeracao_notas
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

declare @ic_entrada_saida      char(1)
declare @cd_serie_nota_entrada int

set  @ic_entrada_saida = 'N'

select
  @ic_entrada_saida = case when isnull(cd_serie_notsaida_empresa,0) = isnull(cd_serie_notent_empresa,0) then 'S'
                                                                                                        else 'N' end,
  @cd_serie_nota_entrada = isnull(cd_serie_notent_empresa,0)
from
  egisadmin.dbo.empresa with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--select * from egisadmin.dbo.empresa
--select * from empresa_serie_nota
--select * from nota_saida

select
  'Saída  '                     as Tipo,
--  ns.cd_nota_saida              as Nota,

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
  end                           as 'Nota',

  ns.dt_nota_saida              as Emissao,
  sn.nm_status_nota             as Status,
  ns.vl_total                   as Total,
  ns.nm_fantasia_nota_saida     as Destinatario
into
  #Saida
from
  Nota_Saida ns
  left outer join status_nota sn on sn.cd_status_nota = ns.cd_status_nota
where
  ns.dt_nota_saida between @dt_inicial and @dt_final
order by
  ns.cd_nota_saida


if @ic_entrada_saida = 'S' 
begin

  --select cd_status_nota,* from nota_entrada

  select
    'Entrada'                     as Tipo,
    ne.cd_nota_entrada            as Nota,
    ne.dt_nota_entrada            as Emissao,
    sn.nm_status_nota             as Status,
    ne.vl_total_nota_entrada      as Total,
    ne.nm_fantasia_destinatario   as Destinatario
  into
    #Entrada
  from
    Nota_Entrada ne
    left outer join status_nota sn on sn.cd_status_nota = ne.cd_status_nota
  where
    ne.dt_nota_entrada between @dt_inicial and @dt_final and
    ne.cd_serie_nota_fiscal = @cd_serie_nota_entrada
  order by
    ne.cd_nota_entrada

  insert into #Saida 
   select * from #Entrada

end

--Mostra todos os Registros

select
  * 
from
  #Saida
order by
  Nota desc
