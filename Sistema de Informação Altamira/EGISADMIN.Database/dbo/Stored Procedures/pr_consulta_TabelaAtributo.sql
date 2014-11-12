
CREATE PROCEDURE pr_consulta_TabelaAtributo
-------------------------------------------------------------------------------
-- sp_view_TabelaAtributo : Lista as Tabelas e Atributos criados no periodo
--                          especificado
-- Data : 02/08/2002
-- Autor : Adriano Levy Barbosa

-------------------------------------------------------------------------------


@ic_parametro int,
@dt_inicial DateTime,
@dt_final DateTime
AS
SELECT 
   t.nm_tabela    as 'Tabela', 
   a.nm_atributo  as 'Atributo',
   a.dt_usuario   as 'Data'
from 
   Atributo a
inner join Tabela t
   on (t.cd_tabela=a.cd_tabela)
where 
   convert(varchar,a.dt_usuario,103) between @dt_inicial and @dt_final and
   IsNull(t.ic_inativa_tabela,'N') = 'N'
order by 
   a.dt_usuario desc,
   t.nm_tabela



