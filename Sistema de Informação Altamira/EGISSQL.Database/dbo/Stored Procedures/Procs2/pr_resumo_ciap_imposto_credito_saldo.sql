
-------------------------------------------------------------------------------
--pr_resumo_ciap_imposto_credito_saldo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda 2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes --Banco de Dados   : Egissql
--Objetivo         : Resumo de Implantação do CIAP
--                   Imposto, Crédito no Mês, Saldo no Mês
--Data             : 30.11.2006
--Alteração        : 30.11.2006
--                 : 20.12.2006 - Acertos Diversos - Carlos Fernandes.
--                 : 21.12.2006 - Correção da DataBase e do calculo decorrente
--                   desta data
--                 : 02.05.2007 - Acertos Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_resumo_ciap_imposto_credito_saldo
  @dt_inicial         datetime = '',
  @dt_final           datetime = '',
  @dt_base            datetime = '',
  @dt_base_parcela    datetime = '',
  @cd_tipo_ciap       int      = 0,
  @cd_bem             int      = 0,
  @cd_ciap            int      = 0,
  @cd_local           int      = 0
as

-------------------------------------------------------------------------------------------
--Valor do ICMS
-------------------------------------------------------------------------------------------

select
  year(c.dt_entrada_nota_ciap)     as Ano,
  month(c.dt_entrada_nota_ciap)    as Mes,
  sum(isnull(c.vl_icms_ciap,0))    as ValorICMS,
  sum(cast(0.00 as float))         as ValorCreditado,
  sum(cast(0.00 as float))         as ValorSomaCredito,
  sum(cast(0.00 as float))         as ValorSaldoBase
into
  #SomaCiap
from
  Ciap c
where 
  isnull(c.cd_ciap,0)      = case when isnull(@cd_ciap,0)      = 0 then isnull(c.cd_ciap,0)      else isnull(@cd_ciap,0)      end and
  --c.dt_entrada_nota_ciap between @dt_inicial and @dt_final                                                                        and
  isnull(c.cd_tipo_ciap,0) = case when isnull(@cd_tipo_ciap,0) = 0 then isnull(c.cd_tipo_ciap,0) else isnull(@cd_tipo_ciap,0) end and
  isnull(c.cd_bem,0)       = case when isnull(@cd_bem,0)       = 0 then isnull(c.cd_bem,0)       else isnull(@cd_bem,0)       end and
  isnull(c.cd_local_bem,0) = case when isnull(@cd_local,0)     = 0 then isnull(c.cd_local_bem,0) else isnull(@cd_local,0)     end
group by
  year(c.dt_entrada_nota_ciap),
  month(c.dt_entrada_nota_ciap)
order by
  year(c.dt_entrada_nota_ciap),
  month(c.dt_entrada_nota_ciap)

--select * from #SomaCiap  
--select * from ciap_demonstrativo  

-------------------------------------------------------------------------------------------
--Valor de Crédito do ICMS no Período    
-------------------------------------------------------------------------------------------

select
  year(c.dt_entrada_nota_ciap)     as Ano,
  month(c.dt_entrada_nota_ciap)    as Mes,
  sum(isnull(cd.vl_icms,0))        as vl_saldo_ciap
into
  #CreditoPeriodo
from
  Ciap c
  inner join Ciap_Demonstrativo cd on cd.cd_ciap = c.cd_ciap
where
  c.cd_ciap      = case when @cd_ciap      = 0 then c.cd_ciap      else @cd_ciap      end and
  cd.qt_mes = month(@dt_base) and cd.qt_ano = year(@dt_base) and
  isnull(c.cd_tipo_ciap,0) = case when isnull(@cd_tipo_ciap,0) = 0 then isnull(c.cd_tipo_ciap,0) else isnull(@cd_tipo_ciap,0) end and
  isnull(c.cd_bem,0)       = case when isnull(@cd_bem,0)       = 0 then isnull(c.cd_bem,0)       else isnull(@cd_bem,0)       end and
  isnull(c.cd_local_bem,0) = case when isnull(@cd_local,0)     = 0 then isnull(c.cd_local_bem,0) else isnull(@cd_local,0)     end
group by
  year(c.dt_entrada_nota_ciap),
  month(c.dt_entrada_nota_ciap)

--select * from #CreditoPeriodo

update
  #SomaCiap
set
  ValorSomaCredito = isnull(ValorSomaCredito,0) + isnull(c.vl_saldo_ciap,0)
from
  #SomaCiap s
  inner join #CreditoPeriodo c on c.ano = s.ano and c.mes=s.mes


-------------------------------------------------------------------------------------------
--Saldo do Imposto a Créditar
-------------------------------------------------------------------------------------------

--Saldo Cálculo através do crédito

select
  year(c.dt_entrada_nota_ciap)       as Ano,
  month(c.dt_entrada_nota_ciap)      as Mes,
  sum(isnull(round(cd.vl_icms,2),0)) as vl_saldo_ciap
into
  #CiapSaldo
from
  Ciap c
  inner join Ciap_Demonstrativo cd on cd.cd_ciap = c.cd_ciap
where
  c.cd_ciap      = case when @cd_ciap      = 0 then c.cd_ciap      else @cd_ciap      end and
  cd.dt_parcela_ciap >= @dt_base and
  isnull(c.cd_tipo_ciap,0) = case when isnull(@cd_tipo_ciap,0) = 0 then isnull(c.cd_tipo_ciap,0) else isnull(@cd_tipo_ciap,0) end and
  isnull(c.cd_bem,0)       = case when isnull(@cd_bem,0)       = 0 then isnull(c.cd_bem,0)       else isnull(@cd_bem,0)       end and
  isnull(c.cd_local_bem,0) = case when isnull(@cd_local,0)     = 0 then isnull(c.cd_local_bem,0) else isnull(@cd_local,0)     end
group by
  year(c.dt_entrada_nota_ciap),
  month(c.dt_entrada_nota_ciap)


--Saldo do Imposto a Créditar
--Saldo Cálculo 

update
  #SomaCiap
set
  ValorSaldoBase = ValorSaldoBase + isnull(c.vl_saldo_ciap,0)
from
  #SomaCiap s
  inner join #CiapSaldo c on c.ano = s.ano and c.mes=s.mes

-------------------------------------------------------------------------------------------
--Soma do Imposto já Creditado
-------------------------------------------------------------------------------------------

--Terminar CCF - 02.05.2007



-------------------------------------------------------------------------------------------
--Mostra o Cálculo Final
-------------------------------------------------------------------------------------------
select
  Ano,
  Mes,
  cast(ValorCreditado   as decimal(25,2)) as ValorCreditado,
  cast(ValorICMS        as decimal(25,2)) as ValorICMS,
  cast(ValorSomaCredito as decimal(25,2)) as ValorSomaCredito,

  case when isnull(ValorSaldoBase,0)>0 then
  cast(ValorSaldoBase  
                        as decimal(25,2))
  else 0.00 end                           as ValorSaldoBase

--  cast(ValorSaldoBase   as decimal(25,2)) as ValorSaldoBase

from
  #SomaCiap
order by
  Ano,Mes

