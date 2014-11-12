
--sp_helptext pr_gera_contabilizacao_ativo_fixo
-------------------------------------------------------------------------------
--pr_contabilizacao_ativo_fixo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática de Contabilização do Ativo Fixo
--Data             : 22.01.2007
--Alteração        : 30.01.2007 - Acertos - Carlos Fernandes
--                 : 28.04.2007 - Gravação do Centro de Custo - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_contabilizacao_ativo_fixo
@dt_final                 datetime    = '',
@cd_lancamento_padrao     int         = 0,                 
@cd_conta_debito          int         = 0,                  
@cd_conta_credito         int         = 0,                 
@cd_historico_contabil    int         = 0,             
@nm_historico_ativo       varchar(40) = '',                 
@vl_ativo_contabilizacao  float       = 0,                 
@nm_complemento_ativo     varchar(40) = '',                 
@cd_usuario               int         = 0,
@cd_centro_custo          int         = 0

as

--select * from ativo_contabilizacao
--select * from plano_conta
declare @cd_ativo_contabilizacao int

select @cd_ativo_contabilizacao = isnull(max(cd_ativo_contabilizacao),0) + 1 from Ativo_Contabilizacao

if @cd_ativo_contabilizacao = 0 or @cd_ativo_contabilizacao is null
   set @cd_ativo_contabilizacao = 1
-- 
-- declare @ic_verificacao int
-- 
-- set @ic_verificacao = 0
-- 
-- while @ic_verificacao=0
-- begin
--   if exists( select cd_ativo_contabilizacao from Ativo_contabilizacao where
--              @cd_ativo_contabilizacao = cd_ativo_contabilizacao )
--   begin
--     set @ic_verificacao = 1
--   end
--   else
--     set @cd_ativo_contabilizacao = @cd_ativo_contabilizacao + 1
-- 
-- end

--select @cd_ativo_contabilizacao

select
  @cd_ativo_contabilizacao                   as cd_ativo_contabilizacao,
  @dt_final                                  as dt_ativo_contabilizacao,
  @cd_lancamento_padrao                      as cd_lancamento_padrao,
  @cd_conta_debito                           as cd_conta_debito,
  @cd_conta_credito                          as cd_conta_credito,
  @cd_historico_contabil                     as cd_historico_contabil,
  @nm_historico_ativo                        as nm_historico_ativo,
  @vl_ativo_contabilizacao                   as vl_ativo_contabilizacao,
  @cd_usuario                                as cd_usuario,
  getdate()                                  as dt_usuario,
  @nm_complemento_ativo                      as nm_complemento_ativo,
  @cd_centro_custo                           as cd_centro_custo
into
  #Ativo_Contabilizacao

insert into
  Ativo_Contabilizacao
select
  *
from
  #Ativo_Contabilizacao

drop table #ativo_contabilizacao

