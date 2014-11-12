
CREATE   VIEW dbo.vw_Tabelas
AS
SELECT     dbo.Tabela.cd_tabela,
           isnull(dbo.Tabela.ic_nucleo_tabela,'N')     as ic_nucleo_tabela,
           dbo.Tabela.nm_tabela,
           dbo.Tabela.ic_fixa_tabela,
           dbo.Tabela.cd_usuario, 
           dbo.Tabela.dt_usuario, 
           dbo.Menu.nm_menu,
           dbo.Usuario.nm_fantasia_usuario,
           isnull(dbo.Tabela.ic_implantacao_tabela,'N') as ic_implantacao_tabela,
           bd.nm_banco_dados,
           dbo.Tabela.ds_tabela 

FROM       
   Tabela                         with (nolock) 
   Left Outer Join Menu_Tabela    with (nolock) 
              on Menu_Tabela.cd_tabela = Tabela.cd_tabela
   Left Outer Join Menu           with (nolock) 
              on Menu.cd_menu = Menu_Tabela.cd_menu
   Left Outer Join Usuario        with (nolock) 
              on Usuario.cd_usuario = Tabela.cd_usuario
   Left Outer Join Banco_Dados bd with (nolock) 
              on bd.cd_banco_dados  = Tabela.cd_banco_dados

--select * from banco_dados

