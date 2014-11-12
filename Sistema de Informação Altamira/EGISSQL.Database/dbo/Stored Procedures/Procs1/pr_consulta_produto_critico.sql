
CREATE PROCEDURE pr_consulta_produto_critico
@ic_parametro as int,
@nm_produto as varchar(30),
@nm_fantasia_produto as varchar(30),
@cd_mascara_produto as varchar(50)

as

begin
-----------------------------  Realiza Pesquisa por mascara -----------------------------------------
if @ic_parametro = 1
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.cd_produto ,
     p.cd_mascara_produto,
     p.nm_produto,
     p.nm_fantasia_produto,
     p.cd_unidade_medida,
     um.dt_produto_critico,
     um.nm_obs_produto_critico

   from 
     produto p inner join
     produto_critico um on (p.cd_produto = um.cd_produto) 

   where p.cd_mascara_produto = @cd_mascara_produto

  end

--***-

else
-------------------------  Realiza Pesquisa por Descrição----------------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.cd_produto ,
     p.cd_mascara_produto,
     p.nm_produto,
     p.nm_fantasia_produto,
     p.cd_unidade_medida,
     um.dt_produto_critico,
     um.nm_obs_produto_critico

   from 
     produto p inner join
     produto_critico um on (p.cd_produto = um.cd_produto) 

   where p.nm_produto like @nm_produto + '%'
  end

--***-

else
-----------------------------  Realiza Pesquisa por Fantasia---------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.cd_produto ,
     p.cd_mascara_produto,
     p.nm_produto,
     p.nm_fantasia_produto,
     p.cd_unidade_medida,
     um.dt_produto_critico,
     um.nm_obs_produto_critico

   from 
     produto p inner join
     produto_critico um on (p.cd_produto = um.cd_produto) 

   where nm_fantasia_produto like @nm_fantasia_produto + '%'
  end

else
-----------------------------  Realiza Pesquisa mais traz nada---------------------------------
if @ic_parametro = 4
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.cd_produto ,
     p.cd_mascara_produto,
     p.nm_produto,
     p.nm_fantasia_produto,
     p.cd_unidade_medida,
     um.dt_produto_critico,
     um.nm_obs_produto_critico

   from 
     produto p inner join
     produto_critico um on (p.cd_produto = um.cd_produto) 

   where 1=2
  end

else
-----------------------------  Realiza Pesquisa Geral---------------------------------
if @ic_parametro = 5
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     p.cd_produto ,
     p.cd_mascara_produto,
     p.nm_produto,
     p.nm_fantasia_produto,
     p.cd_unidade_medida,
     um.dt_produto_critico,
     um.nm_obs_produto_critico

   from 
     produto p inner join
     produto_critico um on (p.cd_produto = um.cd_produto) 
  end

end

