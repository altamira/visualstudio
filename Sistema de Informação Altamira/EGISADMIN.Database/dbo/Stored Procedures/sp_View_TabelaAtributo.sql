
CREATE PROCEDURE sp_View_TabelaAtributo
-------------------------------------------------------------------------------
-- sp_view_TabelaAtributo : Lista as Tabelas e Atributos criados no periodo
--                          especificado
-- Data : 02/08/2002
-- Autor : Adriano Levy Barbosa
-------------------------------------------------------------------------------


@ic_parametro int,
@dt_inicial int,
@dt_final int
AS
SELECT t.nm_tabela, a.nm_atributo from Atributo a
left outer join Tabela t
on (t.cd_tabela=a.cd_tabela)
where a.dt_usuario between @dt_inicial and @dt_final
order by t.nm_tabela


