
-------------------------------------------------------------------------------
--pr_gera_tabela_valor_bem_implantacao_mes_11_2006_sulzer
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Gerar tabela de Valor_bem_implantacao sulzer
--Data             : 12/02/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_tabela_valor_bem_implantacao_mes_11_2006_sulzer
  @cd_usuario int = 0
as

--select * from sulzer.dbo.AtivoMigJan2007
--select * from bem
--select * from valor_bem
--select * from valor_bem_implantacao
--select * from valor_bem_fechamento

-- Limpando Valor de Implantação
delete from Valor_Bem_Implantacao

-- Gerando Tabela
insert into
  Valor_Bem_Implantacao
select
  b.cd_bem,
  cast('2006/11/30' as datetime ) as dt_implantacao_valor_bem,
  [residual]                      as vl_residual_bem,
  [valor de compra]               as vl_original,
  [f30]                           as vl_depreciacao_bem,
  0.00                            as vl_dep_acumulada_bem, 
  ''                              as nm_obs_bem_implantacao,
  @cd_usuario                     as cd_usuario,
  dbo.fn_data(getdate())          as dt_usuario,
  0.00                            as vl_baixa_bem  
from
  sulzer.dbo.AtivoMigJan2007 o
  inner join bem b on b.cd_patrimonio_bem = o.[ativo fixo]


-- Limpando Valor de Implantação
delete from Valor_Bem_Fechamento

select
  IDENTITY(int, 1,1 )             as cd_bem_fechamento,
  b.cd_bem,
  cast('2006/11/30' as datetime ) as dt_bem_fechamento,
  [valor de compra]               as vl_original_bem,
  [residual]                      as vl_residual_bem,
  [f30]                           as vl_depreciacao_bem,
  0.00                            as vl_dep_acumulada_bem, 
  ' '                             as nm_obs_bem_fechamento,
  223                             as cd_usuario,
  dbo.fn_data(getdate())          as dt_usuario,
  0.00                            as vl_baixa_bem,
  0                               as cd_bem_fechamento_auxiliar
into
  #Valor_Bem_Fechamento  
from
  sulzer.dbo.AtivoMigJan2007 o
  inner join bem b on b.cd_patrimonio_bem = o.[ativo fixo]


-- Gerando Tabela
insert into
  Valor_Bem_Fechamento
select
  *
from
  #Valor_Bem_Fechamento
