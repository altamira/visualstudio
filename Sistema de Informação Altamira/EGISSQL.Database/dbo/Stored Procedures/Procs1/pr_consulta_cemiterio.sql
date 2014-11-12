

/****** Object:  Stored Procedure dbo.pr_consulta_cemiterio    Script Date: 13/12/2002 15:08:17 ******/

CREATE PROCEDURE pr_consulta_cemiterio
@ic_parametro integer,
@nm_cemiterio varchar(15)

AS

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta Todos Cemitérios
-------------------------------------------------------------------------------------------
begin
  select
    c.*, 
    ci.nm_cidade,
    e.sg_estado,
    p.sg_pais
  from Cemiterio c
  left outer join Cep cep on
    cep.cd_cep=c.cd_cep
  left outer join Cidade ci on
    ci.cd_cidade=cep.cd_cidade
  left outer join Estado e on
    e.cd_estado=cep.cd_estado
  left outer join Pais p on
    p.cd_pais=cep.cd_pais
  order by c.nm_cemiterio
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 2 --Consulta Somente Cemitérios que começa com o nome informado
-------------------------------------------------------------------------------------------
begin
  select
    c.*, 
    ci.nm_cidade,
    e.sg_estado,
    p.sg_pais
  from Cemiterio c
  left outer join Cep cep on
    cep.cd_cep=c.cd_cep
  left outer join Cidade ci on
    ci.cd_cidade=cep.cd_cidade
  left outer join Estado e on
    e.cd_estado=cep.cd_estado
  left outer join Pais p on
    p.cd_pais=cep.cd_pais
  where 
    c.nm_cemiterio like @nm_cemiterio + '%'
  order by c.nm_cemiterio
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum Cemitérios
-------------------------------------------------------------------------------------------
begin
  select
    c.*, 
    ci.nm_cidade,
    e.sg_estado,
    p.sg_pais
  from (select * from Cemiterio where 1=2) as  c
  left outer join Cep cep on
    cep.cd_cep=c.cd_cep
  left outer join Cidade ci on
    ci.cd_cidade=cep.cd_cidade
  left outer join Estado e on
    e.cd_estado=cep.cd_estado
  left outer join Pais p on
    p.cd_pais=cep.cd_pais
  order by c.nm_cemiterio
end



