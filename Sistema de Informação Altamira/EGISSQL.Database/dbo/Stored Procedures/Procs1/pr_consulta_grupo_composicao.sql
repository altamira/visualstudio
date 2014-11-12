

/****** Object:  Stored Procedure dbo.pr_consulta_grupo_composicao    Script Date: 13/12/2002 15:08:20 ******/

CREATE PROCEDURE pr_consulta_grupo_composicao
@ic_parametro integer,
@ds_grupo_composicao varchar(15)

AS

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta Todos Cemitérios
-------------------------------------------------------------------------------------------
begin
  select *
  from Grupo_Composicao gc
  order by gc.ds_grupo_composicao
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 2 --Consulta Somente Cemitérios que começa com o nome informado
-------------------------------------------------------------------------------------------
begin
  select *
  from Grupo_Composicao gc
  where 
    gc.ds_grupo_composicao like @ds_grupo_composicao + '%'
  order by gc.ds_grupo_composicao
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum Cemitérios
-------------------------------------------------------------------------------------------
begin
  select *
  from (select * from Grupo_Composicao where 1=2) as gc
  order by gc.ds_grupo_composicao
end



