----------------------------------------------------------------------
--pr_codigo_reduzido_vagos_plano_conta
----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                             2004
----------------------------------------------------------------------                     
--Stored Procedure      : SQL Server Microsoft 2000  
--Autor(es)             : Carlos Cardoso Fernandes
--                      : 
--Objetivo              : Consulta dos Códigos Reduzidos Vagos no
--                        Plano de contas da Empresa
--Data                  : 29.12.2004
--Atualizado            : 
--Alteração             : 
--                      : 
-----------------------------------------------------------------------------------
create  procedure pr_codigo_reduzido_vagos_plano_conta
@dt_inicial datetime,
@dt_final   datetime
as

declare @cd_reduzido_inicial int
declare @cd_reduzido_final   int
declare @cd_reduzido_aux     int
declare @cd_reduzido         int

select
  @cd_reduzido_inicial = cd_reduzido_inicial,
  @cd_reduzido_final   = cd_reduzido_final
from
  Parametro_Contabilidade
where
  cd_empresa = dbo.fn_empresa()

-- select
--   @cd_reduzido_inicial,
--   @cd_reduzido_final

--Montagem de uma tabela Auxiliar

create table #Reduzido (
  cd_reduzido int )


set @cd_reduzido_aux = @cd_reduzido_inicial

while @cd_reduzido_aux <= @cd_reduzido_final
begin

  --Verifica se o Reduzido existe no plano

  select @cd_reduzido = isnull(cd_conta_reduzido,0) from plano_conta where cd_conta_reduzido = @cd_reduzido_aux
  if @cd_reduzido <> @cd_reduzido_aux
  begin
    insert into #Reduzido select @cd_reduzido_aux
  end

  set @cd_reduzido_aux = @cd_reduzido_aux + 1

end

select 
 cd_reduzido as Reduzido
from 
 #Reduzido  

--select * from plano_conta order by cd_conta_reduzido
  

