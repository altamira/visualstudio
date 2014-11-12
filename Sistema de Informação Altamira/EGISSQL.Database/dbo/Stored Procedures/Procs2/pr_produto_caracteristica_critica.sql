
CREATE PROCEDURE pr_produto_caracteristica_critica
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
   p.cd_versao_produto,
   um.sg_unidade_medida

   from 
   produto p left outer join
   Unidade_Medida um on (p.cd_unidade_medida = um.cd_unidade_medida) 

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
   p.cd_versao_produto,
   um.sg_unidade_medida

   from 
   produto p left outer join
   unidade_medida um on (p.cd_unidade_medida = um.cd_unidade_medida) 

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
   p.cd_versao_produto,
   um.sg_unidade_medida
   from 
   produto p left outer join
   unidade_medida um on (p.cd_unidade_medida = um.cd_unidade_medida) 

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
   p.cd_versao_produto,
   um.sg_unidade_medida

   from 
   produto p left outer join
   unidade_medida um on (p.cd_unidade_medida = um.cd_unidade_medida) 

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
   p.cd_versao_produto,
   um.sg_unidade_medida

   from 
   produto p left outer join
   unidade_medida um on (p.cd_unidade_medida = um.cd_unidade_medida) 

  end

end

