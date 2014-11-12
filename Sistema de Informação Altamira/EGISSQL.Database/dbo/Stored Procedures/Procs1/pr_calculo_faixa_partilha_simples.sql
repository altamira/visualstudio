
-------------------------------------------------------------------------------
--sp_helptext pr_calculo_faixa_partilha_simples
-------------------------------------------------------------------------------
--pr_calculo_faixa_partilha_simples
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo da Faixa de Faturamento para
--                   Partilha do Simples Nacional
--
--Data             : 06.07.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_calculo_faixa_partilha_simples
@dt_inicial datetime = '',
@dt_final   datetime = '',
--@dt_base    datetime = '',
@cd_usuario int      = 0

as

declare @vl_faturamento_periodo float
declare @cd_imposto_simples     int
declare @cd_empresa             int

set @vl_faturamento_periodo = 0.00

--select * from vw_faturamento

exec pr_resumo_faturamento
     @dt_inicial,
     @dt_final,
     'S',
     1,
     7,
     0,
     @vl_faturamento = @vl_faturamento_periodo OUTPUT
  

--Busca a Faixa de Faturamento

select
  @cd_imposto_simples = isnull(cd_imposto_simples,0)
from
  imposto_simples
where
  @vl_faturamento_periodo between vl_faturamento_inicial and vl_faturamento_final


--select * from parametro_faturamento_imposto

--Empresa
select
  @cd_empresa = dbo.fn_empresa()

--Atualizando a Tabela de Config de Impostos

if @cd_imposto_simples>0 
begin
  delete from parametro_faturamento_imposto
  insert into
     parametro_faturamento_imposto
  select
    @cd_empresa,
    @cd_usuario,
    getdate(),
    @cd_imposto_simples

end

--Mostra a Tabela de Impostos

--select * from parametro_faturamento_imposto

--select * from imposto_simples

