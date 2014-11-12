
-------------------------------------------------------------------------------
--pr_fechamento_calculo_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 31.01.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_fechamento_calculo_ativo
@ic_parametro       int      = 0,
@dt_base_fechamento datetime = '',
@cd_usuario         int      = 0
as

--select * from calculo_bem
--select * from valor_bem

if @ic_parametro = 9
begin
  delete from valor_bem_fechamento
end

delete from valor_bem_fechamento where dt_bem_fechamento = @dt_base_fechamento

declare @cd_bem_fechamento int

select @cd_bem_fechamento = isnull(max(cd_bem_fechamento),0) + 1 from Valor_Bem_Fechamento

if @cd_bem_fechamento = 0 or @cd_bem_fechamento is null
begin
   set @cd_bem_fechamento = 1
end

select
  0                                                          as cd_bem_fechamento,
  cb.cd_bem                                                  as cd_bem,
  @dt_base_fechamento                                        as dt_bem_fechamento,
  vb.vl_original_bem,
  vb.vl_residual_bem,
  cb.vl_calculo_bem                                          as vl_depreciacao_bem,
  vb.vl_deprec_acumulada_bem                                 as vl_dep_acumulada_bem,
  'Fechamento Ativo : '+cast(@dt_base_fechamento as varchar) as nm_obs_bem_fechamento,
  @cd_usuario                                                as cd_usuario,
  getdate()                                                  as dt_usuario,
  vb.vl_baixa_bem                                            as vl_baixa_bem,
  identity(int,1,1)                                          as cd_bem_fechamento_auxiliar                                 
into
  #Valor_Bem_Fechamento
from
  Calculo_Bem cb 
  inner join Valor_Bem vb on vb.cd_bem = cb.cd_bem
where
  cb.dt_calculo_bem = @dt_base_fechamento

--Acerta o Código do Bem

update
  #Valor_Bem_Fechamento
set
  cd_bem_fechamento = @cd_bem_fechamento + cd_bem_fechamento_auxiliar 

insert into
  Valor_Bem_Fechamento
select
  * 
from
  #Valor_Bem_Fechamento  

drop table #Valor_Bem_Fechamento

