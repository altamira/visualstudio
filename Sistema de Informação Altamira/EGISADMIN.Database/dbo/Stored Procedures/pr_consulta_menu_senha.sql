
-------------------------------------------------------------------------------
--pr_consulta_menu_senha
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de senhas de Menu x Módulo
--Data             : 23/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_menu_senha
@dt_inicial datetime,
@dt_final   datetime

as

select
  m.nm_menu              as Menu,
  m.nm_menu_titulo       as Titulo ,
  m.cd_senha_acesso_menu as Senha,
  m.ic_nucleo_menu       as Nucleo,
  c.nm_classe            as Classe,
  p.nm_procedimento      as Procedimento,
  v.nm_titulo_view       as 'View'
from
  Menu m 
  left outer join Classe c       on c.cd_classe       = m.cd_classe
  left outer join Procedimento p on p.cd_procedimento = m.cd_procedimento
  left outer join View_ v        on v.cd_view         = m.cd_view
where
  isnull(m.cd_senha_acesso_menu,'') <> ''
order by
  m.nm_menu

--select * from menu
--select * from view_
