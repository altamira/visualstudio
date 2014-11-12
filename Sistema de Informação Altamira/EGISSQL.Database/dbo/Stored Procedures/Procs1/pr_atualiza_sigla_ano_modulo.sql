
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Atualização da Sigla do módulo com o Ano Correto
--Data             : 02.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_atualiza_sigla_ano_modulo
@sg_ano      char(4) = '', 
@sg_ano_novo char(4) = ''
as

if @sg_ano_novo = ''
   set @sg_ano_novo = cast( year(getdate()) as char(4) )


if @sg_ano      = ''
   set @sg_ano = cast( year(getdate())-1 as char(4) )  

--select @sg_ano, @sg_ano_novo

-- select
--   sg_modulo,
--   stuff(sg_modulo,charindex(@sg_ano,sg_modulo),4,@sg_ano_novo) as siglanova,
--   charindex(@sg_ano,sg_modulo) as posicao
-- from
--   Modulo
-- where
--   sg_modulo like '%'+@sg_ano+'%'

update
  Modulo
set
  sg_modulo = stuff(sg_modulo,charindex(@sg_ano,sg_modulo),4,@sg_ano_novo)
where
  sg_modulo like '%'+@sg_ano+'%'


--select * from modulo

