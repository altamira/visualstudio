
CREATE PROCEDURE pr_rel_produto_caracteristica_critica
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
      pc.cd_produto, 
      p.nm_produto,
      RTrim(Cast(pc.cd_caracteristica_critica as Char(10))) + ' - ' + c.nm_caracteristica_critica as Caracteristica_Critica,
      nm_obs_produto_critica,
      ds_produto_caracteristica
    from 
      produto p 
      Inner Join Produto_Caracteristica_Critica pc on (p.cd_produto = pc.cd_produto)
      Inner Join Caracteristica_Critica c on (pc.cd_caracteristica_critica = c.cd_caracteristica_critica)
    where p.cd_mascara_produto = @cd_mascara_produto
  end

--***-

else
-------------------------  Realiza Pesquisa por Descrição----------------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
    Select 
      pc.cd_produto, 
      p.nm_produto,
      RTrim(Cast(pc.cd_caracteristica_critica as Char(10))) + ' - ' + c.nm_caracteristica_critica as Caracteristica_Critica,
      nm_obs_produto_critica,
      ds_produto_caracteristica
    from 
      produto p 
      Inner Join Produto_Caracteristica_Critica pc on (p.cd_produto = pc.cd_produto)
      Inner Join Caracteristica_Critica c on (pc.cd_caracteristica_critica = c.cd_caracteristica_critica)
    where p.nm_produto like @nm_produto + '%'
  end

--***-

else
-----------------------------  Realiza Pesquisa por Fantasia---------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
    Select 
      pc.cd_produto, 
      p.nm_produto,
      RTrim(Cast(pc.cd_caracteristica_critica as Char(10))) + ' - ' + c.nm_caracteristica_critica as Caracteristica_Critica,
      nm_obs_produto_critica,
      ds_produto_caracteristica
    from 
      produto p 
      Inner Join Produto_Caracteristica_Critica pc on (p.cd_produto = pc.cd_produto)
      Inner Join Caracteristica_Critica c on (pc.cd_caracteristica_critica = c.cd_caracteristica_critica)
    where nm_fantasia_produto like @nm_fantasia_produto + '%'
  end
end

