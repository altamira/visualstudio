
CREATE PROCEDURE pr_cliente_cidade_feriado
@ic_parametro as int,
@cd_estado as int,
@cd_cidade as int

as

begin
-----------------------------  Realiza Pesquisa Geral  -----------------------------------------
if @ic_parametro = 1
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.nm_pais,
     e.sg_estado,  
     c.cd_cidade,
     c.nm_cidade,
     cl.nm_fantasia_cliente,
     cl.cd_ddd,
     cl.cd_telefone,
     f.nm_feriado,
     cf.dt_cidade_feriado,
     cf.nm_obs_cidade_feriado,
     Isnull(Cast(cf.dt_cidade_feriado- GetDate() as Integer),0) as Dias
   from 
     cidade c
     inner join cidade_feriado cf on (c.cd_cidade = cf.cd_cidade) 
     inner join cliente cl on (c.cd_cidade = cl.cd_cidade)
     inner join estado e on (c.cd_estado = e.cd_estado) 
     left outer join pais p on (e.cd_pais = p.cd_pais)
     inner join feriado f on (cf.cd_feriado = f.cd_feriado)
   Order By c.nm_cidade, e.sg_estado, cl.nm_fantasia_cliente
  end

--***-

else
-------------------------  Realiza Pesquisa por Estado  ----------------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.nm_pais,
     e.sg_estado,  
     c.cd_cidade,
     c.nm_cidade,
     cl.nm_fantasia_cliente,
     cl.cd_ddd,
     cl.cd_telefone,
     f.nm_feriado,
     cf.dt_cidade_feriado,
     cf.nm_obs_cidade_feriado,
     Isnull(Cast(cf.dt_cidade_feriado- GetDate() as Integer),0) as Dias
   from 
     cidade c
     inner join cidade_feriado cf on (c.cd_cidade = cf.cd_cidade) 
     inner join cliente cl on (c.cd_cidade = cl.cd_cidade)
     inner join estado e on (c.cd_estado = e.cd_estado) 
     left outer join pais p on (e.cd_pais = p.cd_pais)
     inner join feriado f on (cf.cd_feriado = f.cd_feriado)
   where c.cd_estado = @cd_estado
   Order By c.nm_cidade, e.sg_estado, cl.nm_fantasia_cliente
  end

--***-

else
-----------------------------  Realiza Pesquisa por Cidade  ---------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.nm_pais,
     e.sg_estado,  
     c.cd_cidade,
     c.nm_cidade,
     cl.nm_fantasia_cliente,
     cl.cd_ddd,
     cl.cd_telefone,
     f.nm_feriado,
     cf.dt_cidade_feriado,
     cf.nm_obs_cidade_feriado,
     Isnull(Cast(cf.dt_cidade_feriado- GetDate() as Integer),0) as Dias
   from 
     cidade c
     inner join cidade_feriado cf on (c.cd_cidade = cf.cd_cidade) 
     inner join cliente cl on (c.cd_cidade = cl.cd_cidade)
     inner join estado e on (c.cd_estado = e.cd_estado) 
     left outer join pais p on (e.cd_pais = p.cd_pais)
     inner join feriado f on (cf.cd_feriado = f.cd_feriado)
   where c.cd_cidade = @cd_cidade
   Order By c.nm_cidade, e.sg_estado, cl.nm_fantasia_cliente
  end

end

