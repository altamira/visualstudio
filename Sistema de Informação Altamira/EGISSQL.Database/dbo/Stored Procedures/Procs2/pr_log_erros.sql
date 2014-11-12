

/****** Object:  Stored Procedure dbo.pr_log_erros    Script Date: 13/12/2002 15:08:34 ******/
--pr_movimentacao
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton
--Mostra Tabela de Log de Erros
--Data         : 20.03.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_log_erros
@DtIni DATETIME,
@DtFim DATETIME
as
 select a.dt_log   as 'Data',
        a.cd_cone  as 'Cone',
        ferramenta =
           case isnull(a.cd_ferramenta,0) when 0 then 'Nao Associado'
           else b.nm_ferramenta
           end,
       'Ferramenta Sigla' =  
        case isnull(a.cd_ferramenta,0) when 0 then 'Nao Associado'
           else b.nm_fantasia_ferramenta
           end,
        c.nm_tipo_movimento as 'Movimento',
        d.nm_fantasia_maquina        as 'Maquina',
        a.nm_mensagem       as 'Mensagem',
        e.nm_fantasia_usuario as 'Usuario'
 
 from LogErroFerNet a,
      Ferramenta b, 
      Tipo_Movimento_cone c,
      Maquina d,
      SapAdmin.dbo.usuario e
 where a.dt_log between @DtIni and @DtFim            and  
       b.cd_grupo_ferramenta =* a.cd_grupo_ferramenta and
       b.cd_ferramenta =* a.cd_ferramenta             and
       c.cd_tipo_movimento = a.cd_movimento          and
       d.cd_maquina = a.cd_maquina                   and
       e.cd_usuario = a.cd_usuario
 order by a.dt_log desc
   


