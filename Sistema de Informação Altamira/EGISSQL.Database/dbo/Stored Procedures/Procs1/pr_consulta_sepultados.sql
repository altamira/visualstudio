
CREATE PROCEDURE pr_consulta_sepultados
@ic_parametro integer,
@nm_falecimento_reg_obito varchar(40)

AS

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta Todos Sepultados
-------------------------------------------------------------------------------------------
begin
  select
    ro.*

  from Registro_Obito ro

  order by ro.nm_falecimento_reg_obito
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 2 --Consulta Somente Concessionário que começa com o nome informado
-------------------------------------------------------------------------------------------
begin
  select
    ro.*

  from Registro_Obito ro
  where 
    ro.nm_falecimento_reg_obito like @nm_falecimento_reg_obito + '%'
  order by ro.nm_falecimento_reg_obito
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum Concessionário
-------------------------------------------------------------------------------------------
begin
  select
    ro.*

  from (select * from registro_obito where 1=2) as  ro  

  order by ro.nm_falecimento_reg_obito
end

