
--sp_helptext pr_razao_auxiliar_ativo_fixo

-------------------------------------------------------------------------------
--pr_razao_auxiliar_ativo_fixo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Razão Auxiliar do Ativo Fixo
--Data             : 22.01.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_razao_auxiliar_ativo_fixo
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_grupo_bem int      = 0

as

--select * from plano_conta

--Montagem da Tabela Auxiliar com Aquisições

select
  b.cd_grupo_bem,
  b.dt_aquisicao_bem      as DataCalculo,
  sum(vb.vl_original_bem) as ValorCalculo,
  max('Aquisição')        as Historico,
  max('A')                as Tipo
into
  #Aquisicao
from
  Bem b
  inner join Grupo_Bem g  on g.cd_grupo_bem  = b.cd_grupo_bem
  inner join Valor_Bem vb on vb.cd_bem       = b.cd_bem
where
  b.cd_grupo_bem = case when @cd_grupo_bem = 0 then b.cd_grupo_bem else b.cd_grupo_bem end and
  b.dt_aquisicao_bem between @dt_inicial and @dt_final

group by
  b.cd_grupo_bem,
  b.dt_aquisicao_bem

--select * from #aquisicao

--Montagem da Tabela Auxiliar com Baixas

select
  b.cd_grupo_bem,
  b.dt_baixa_bem        as DataCalculo,
  sum(vb.vl_baixa_bem)  as ValorCalculo,
  max('Baixa')          as Historico,
  max('B')              as Tipo

into
  #Baixa
from
  Bem b
  inner join Grupo_Bem g  on g.cd_grupo_bem  = b.cd_grupo_bem
  inner join Valor_Bem vb on vb.cd_bem       = b.cd_bem
where
  b.cd_grupo_bem = case when @cd_grupo_bem = 0 then b.cd_grupo_bem else @cd_grupo_bem end and
  b.dt_baixa_bem between @dt_inicial and @dt_final

group by
  b.cd_grupo_bem,
  b.dt_baixa_bem

--select * from #baixa

--Montagem da Tabela Auxiliar de com Cálculo

--select * from calculo_bem

select
  cd_grupo_bem,
  dt_calculo_bem        as DataCalculo,
  sum(vl_calculo_bem)   as ValorCalculo,
  max('Depreciação')    as Historico,
  max('C')              as Tipo

into
  #Calculo
from
  Calculo_Bem c 
where
  c.cd_grupo_bem = case when @cd_grupo_bem = 0 then c.cd_grupo_bem else @cd_grupo_bem end

group by
  cd_grupo_bem,
  dt_calculo_bem

--select * from #Calculo

--Montagem da Tabela Geral

select
  *
into
  #Geral
from
  #Aquisicao
union all
  ( select * from #Baixa )
union all
  ( select * from #Calculo )

--select * from #Geral

--Razão Auxiliar

select
  g.cd_grupo_bem,
  g.nm_grupo_bem,
  pc.cd_mascara_conta,
  pc.nm_conta,
  x.DataCalculo,
  x.ValorCalculo,
  x.Historico,
  x.ValorCalculo    as Saldo,
  case when x.Tipo='A' 
  then
    x.ValorCalculo 
  else 0.00 end     as Debito,

  case when x.Tipo='B' 
  then
    x.ValorCalculo 
  else 0.00 end     as Credito  

  
from
  Grupo_bem g
  left outer join Plano_Conta pc      on pc.cd_conta    = g.cd_conta
  left outer join #Geral      x       on x.cd_grupo_bem = g.cd_grupo_bem
where
   g.cd_grupo_bem = case when @cd_grupo_bem = 0 then g.cd_grupo_bem else @cd_grupo_bem end

order by
  g.nm_grupo_bem


