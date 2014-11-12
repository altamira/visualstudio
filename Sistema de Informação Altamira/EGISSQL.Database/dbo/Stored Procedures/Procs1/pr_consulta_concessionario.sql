
CREATE PROCEDURE pr_consulta_concessionario
@ic_parametro integer,
@nm_concessionario varchar(15)

AS

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta Todos Concessionários
-------------------------------------------------------------------------------------------
begin
  select
    c.*, 
    pf.nm_profissao,     
    nc.nm_nacionalidade,
    ec.nm_estado_civil,
    ci.nm_cidade,
    e.sg_estado,
    p.sg_pais

  from Concessionario c
  left outer join Profissao pf on
    pf.cd_profissao=c.cd_profissao
  left outer join Estado_Civil ec on
    c.cd_estado_civil=ec.cd_estado_civil
  left outer join Nacionalidade nc on
    c.cd_nacional=nc.cd_nacionalidade
  left outer join Cep cep on
    cep.cd_cep=c.cd_cep
  left outer join Cidade ci on
    cep.cd_cidade=cep.cd_cidade
  left outer join Estado e on
    e.cd_estado=ci.cd_estado
  left outer join Pais p on
    p.cd_pais=e.cd_pais
  
  order by c.nm_conc
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 2 --Consulta Somente Concessionário que começa com o nome informado
-------------------------------------------------------------------------------------------
begin
  select
    c.*, 
    pf.nm_profissao,     
    nc.nm_nacionalidade,
    ec.nm_estado_civil,
    ci.nm_cidade,
    e.sg_estado,
    p.sg_pais

  from Concessionario c
  left outer join Profissao pf on
    pf.cd_profissao=c.cd_profissao
  left outer join Estado_Civil ec on
    c.cd_estado_civil=ec.cd_estado_civil
  left outer join Nacionalidade nc on
    c.cd_nacional=nc.cd_nacionalidade
  left outer join Cep cep on
    cep.cd_cep=c.cd_cep
  left outer join Cidade ci on
    cep.cd_cidade=cep.cd_cidade
  left outer join Estado e on
    e.cd_estado=ci.cd_estado
  left outer join Pais p on
    p.cd_pais=e.cd_pais  
  where 
    c.nm_conc like @nm_concessionario + '%'
  order by c.nm_conc
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum Concessionário
-------------------------------------------------------------------------------------------
begin
  select
    c.*, 
    pf.nm_profissao,     
    nc.nm_nacionalidade,
    ec.nm_estado_civil,
    ci.nm_cidade,
    e.sg_estado,
    p.sg_pais
  from (select * from Concessionario where 1=2) as  c  
  left outer join Profissao pf on
    pf.cd_profissao=c.cd_profissao
  left outer join Estado_Civil ec on
    c.cd_estado_civil=ec.cd_estado_civil
  left outer join Nacionalidade nc on
    c.cd_nacional=nc.cd_nacionalidade
  left outer join Cep cep on
    cep.cd_cep=c.cd_cep
  left outer join Cidade ci on
    cep.cd_cidade=cep.cd_cidade
  left outer join Estado e on
    e.cd_estado=ci.cd_estado
  left outer join Pais p on
    p.cd_pais=e.cd_pais

  order by c.nm_conc
end

