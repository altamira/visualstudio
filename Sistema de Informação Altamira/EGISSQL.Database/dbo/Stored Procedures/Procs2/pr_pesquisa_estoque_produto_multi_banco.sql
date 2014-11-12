
CREATE PROCEDURE pr_pesquisa_estoque_produto_multi_banco
------------------------------------------------------------------------------------
--pr_pesquisa_estoque_produto_multi_banco
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo	        : Consulta de Estoque do Produto em todos os Bancos de Dados
--Data                  : 17.08.2005  
--Atualização           : 27.03.2006 - Ajustes Gerais - Carlos Fernandes
--                                   - Empresa que não possui banco cadastrado 
--                                   - Produto não localizado em outros bancos 
------------------------------------------------------------------------------------
@cd_produto      int = 0,
@cd_fase_produto int = 0

as

declare @cd_empresa        int
declare @nm_banco_empresa  varchar(40)
declare @sql               varchar(8000)

--select nm_banco_empresa,* from empresa

 select
   e.cd_empresa,
   e.nm_empresa,
   e.nm_fantasia_empresa,
   e.nm_banco_empresa
 into #Empresa
 from
    egisadmin.dbo.empresa e
 where
    exists ( select name from master.dbo.sysdatabases where name = e.nm_banco_empresa )  

--select * from #Empresa
--drop table egissql.carlos.consultaestoque

  if exists(Select * from sysobjects
            where name = 'ConsultaEstoque' and
                  xtype = 'U' AND
                  uid in ( USER_ID(), 1 ) )
  begin
    set @SQL = ' DROP TABLE ' + USER_NAME() + '.' + 'ConsultaEstoque'
    exec(@SQL)
  end

--Criação da tabela temporária
select @sql = 'create table '+user_name()+'.ConsultaEstoque(
 cd_produto               int,
 cd_fase_produto          int,
 qt_saldo_reserva_produto float       null,
 qt_saldo_atual_produto   float       null,
 nm_banco_empresa         varchar(40),
 cd_empresa               int )'

exec (@sql)

 while exists ( select top 1 cd_empresa from #Empresa )
 begin

   select
     @cd_empresa        = cd_empresa,
     @nm_banco_empresa  = nm_banco_empresa
   from 
     #Empresa
   order by cd_empresa

   set @Sql = 'insert into ' + user_name()+'.ConsultaEstoque '
	  + 'select ps.cd_produto, '
     	  + 'ps.cd_fase_produto, '
     	  + 'ps.qt_saldo_reserva_produto, '
     	  + 'ps.qt_saldo_atual_produto,  '
          + ''''+@nm_banco_empresa+''''+' as nm_banco_empresa, '
          + ''''+cast(@cd_empresa as varchar)+''''+' as cd_empresa '
     	  + ' from '
      	  + @nm_banco_empresa+'.dbo.produto_saldo ps '
    	  + 'where '
      	  + 'ps.cd_produto      = '           + cast(@cd_produto as varchar) + ' and '
      	  + 'ps.cd_fase_produto = case when ' + cast( @cd_fase_produto as varchar) + '= 0 then ps.cd_fase_produto else '+ cast( @cd_fase_produto as varchar) +' end'

--     print @sql

     exec (@Sql)

     delete from #Empresa where cd_empresa = @cd_empresa
    
 end

 set @Sql = 'select ce.*, e.nm_fantasia_empresa, dbo.fn_mascara_produto(p.cd_produto) as mascara, p.nm_fantasia_produto, p.nm_produto, fp.nm_fase_produto from ' + 
             user_name() + '.ConsultaEstoque ce '+	
            'left outer join Produto p       on p.cd_produto       = ce.cd_produto '+
            'left outer join Fase_Produto fp on fp.cd_fase_produto = ce.cd_fase_produto '+
						'left outer join EGISADMIN.dbo.Empresa e on ce.cd_empresa = e.cd_empresa '+
            'where isnull(qt_saldo_reserva_produto, 0) <> 0 '+
            'order by ce.cd_empresa'

 exec (@Sql)

-- select 
--   ps.cd_produto,
--   p.cd_mascara_produto,
--   p.nm_fantasia_produto,
--   p.nm_produto,
--   ps.cd_fase_produto,
--   fp.nm_fase_produto,
--   ps.qt_saldo_reserva_produto,
--   ps.qt_saldo_atual_produto
-- 
-- from 
--   produto_saldo ps
--   left outer join Produto p       on p.cd_produto       = ps.cd_produto
--   left outer join Fase_Produto fp on fp.cd_fase_produto = ps.cd_fase_produto
-- where
--   ps.cd_produto      = @cd_produto and
--   ps.cd_fase_produto = case when @cd_fase_produto = 0 then ps.cd_fase_produto else @cd_fase_produto end
-- 
-- union all
-- 
-- ( select
--   ps.cd_produto,
--   p.cd_mascara_produto,
--   p.nm_fantasia_produto,
--   p.nm_produto,
--   ps.cd_fase_produto,
--   fp.nm_fase_produto,
--   ps.qt_saldo_reserva_produto,
--   ps.qt_saldo_atual_produto
-- 
-- from 
--   teste.dbo.produto_saldo ps
--   left outer join Produto p       on p.cd_produto       = ps.cd_produto
--   left outer join Fase_Produto fp on fp.cd_fase_produto = ps.cd_fase_produto
-- where
--   ps.cd_produto      = @cd_produto and 
--   ps.cd_fase_produto = case when @cd_fase_produto = 0 then ps.cd_fase_produto else @cd_fase_produto end )
-- set @nm_banco_empresa = 'EGISSQL'
-- Select
--    @Sql = 'insert into ' + user_name()+'.ConsultaEstoque '
-- 	  + 'select ps.cd_produto, '
--      	  + 'ps.cd_fase_produto, '
--      	  + 'ps.qt_saldo_reserva_produto, '
--      	  + 'ps.qt_saldo_atual_produto  '
--      	  + 'from '
--       	  + @nm_banco_empresa+'.dbo.produto_saldo ps '
--     	  + 'where '
--       	  + 'ps.cd_produto      = ' + cast(@cd_produto as varchar) + ' and '
--       	  + 'ps.cd_fase_produto = case when ' + cast( @cd_fase_produto as varchar) + '= 0 then ps.cd_fase_produto else '+ cast( @cd_fase_produto as varchar) +' end'
-- 
-- set @nm_banco_empresa = 'teste'
-- Select
--    @Sql = 'insert into ' + user_name()+'.ConsultaEstoque '
-- 	  + 'select ps.cd_produto, '
--      	  + 'ps.cd_fase_produto, '
--      	  + 'ps.qt_saldo_reserva_produto, '
--      	  + 'ps.qt_saldo_atual_produto  '
--      	  + 'from '
--       	  + @nm_banco_empresa+'.dbo.produto_saldo ps '
--     	  + 'where '
--       	  + 'ps.cd_produto      = ' + cast(@cd_produto as varchar) + ' and '
--       	  + 'ps.cd_fase_produto = case when ' + cast( @cd_fase_produto as varchar) + '= 0 then ps.cd_fase_produto else '+ cast( @cd_fase_produto as varchar) +' end'
-- 
-- exec (@Sql)


