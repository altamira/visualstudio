
CREATE    PROCEDURE pr_altera_classificacao_fiscal
---------------------------------------------------------
-- pr_altera_classificacao_fiscal
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)		     : Rafael Marin Santiago
--Banco de Dados	 : EGISSQL
--Objetivo		     : Alterar a Classificação Fiscal
--Data		      	 : 22/01/2003
--Alteração	    	 : 
--Desc. Alteração	 : 
---------------------------------------------------

@ic_atualiza char(1),
@ic_parametro int,
@cd_codigo int,
@cd_class_antiga int,
@cd_class_nova int,
@nm_historico varchar(40),
@cd_usuario int


as
declare @SQL varchar(8000)
declare @SQLA varchar(8000)
declare @SQLB varchar(8000)
--------------------------------------------------
if @ic_atualiza = 'N' -- Não Atualizar a Tabela
--------------------------------------------------
begin



set @SQL = 'SELECT     
             pf.cd_produto,
             pf.cd_classificacao_fiscal,
             cfh.cd_usuario, cfh.dt_usuario, 
             p.nm_fantasia_produto,
             p.cd_mascara_produto,
             (SELECT
                x.cd_mascara_classificacao
              FROM
                Classificacao_Fiscal x
              WHERE
                x.cd_classificacao_fiscal = cfh.cd_classificacao_fiscal) as ClassAntiga,
              (SELECT
                x.cd_mascara_classificacao
              FROM
                Classificacao_Fiscal x
              WHERE
                x.cd_classificacao_fiscal = pf.cd_classificacao_fiscal) as ClassNova
           FROM
             Produto_Fiscal pf
           LEFT OUTER JOIN
             Classificacao_Fiscal_Historico cfh
           ON
             cfh.cd_produto = pf.cd_produto
           LEFT OUTER JOIN
             Produto p
           ON
             pf.cd_produto = p.cd_produto 
           WHERE '

-- Grupo Produto
if @ic_parametro = 1
set @SQL = @SQL + 'p.cd_grupo_produto = ' + cast(@cd_codigo as varchar(40))

-- Série Produto
if @ic_parametro = 2
set @SQL = @SQL + 'p.cd_serie_produto = ' + cast(@cd_codigo as varchar(40))

-- Classificação Atual
if @ic_parametro = 3
set @SQL = @SQL + 'pf.cd_classificacao_fiscal = ' + cast(@cd_codigo as varchar(40))

print ( @SQL )
exec  ( @SQL )

end
----------------------------------------------------------
else  -- ROTINA PARA ATUALIZAR A TABELA
----------------------------------------------------------
  begin

    set @SQLA = ''    
    set @SQLA =' select distinct p.cd_produto ' +
      ' into #Tabela ' +
      ' from Produto p ' +
      ' LEFT OUTER JOIN '+
      ' Produto_Fiscal pf '+
      ' ON p.cd_produto = pf.cd_produto'+
      ' where '

    if @ic_parametro = 1    
      set @SQLA = @SQLA + 'cd_grupo_produto = ' + cast(@cd_codigo as varchar(40))

		if @ic_parametro = 2
      set @SQLA = @SQLA + 'cd_serie_produto = ' + cast(@cd_codigo as varchar(40))

    if @ic_parametro = 3
      set @SQLA = @SQLA + 'pf.cd_classificacao_fiscal = ' + cast(@cd_codigo as varchar(40))

     
     set @SQLB = ' declare @cd_produto int ' +
     ' while exists (select top 1 * from #Tabela) ' + 
     '  begin ' + 
 
         'set @cd_Produto = (select top 1 cd_produto from #Tabela) ' +
         'insert into Classificacao_Fiscal_Historico( ' +
         'dt_historico_classifica, '+
         'cd_produto, '+
         'cd_classificacao_fiscal, ' +
         'nm_historico_classifica, ' +
         'cd_usuario, '+
         'dt_usuario) '+
         'values ' +
         '( GetDate(), ' +   
           '@cd_produto , ' +
           cast (@cd_class_antiga as varchar(40)) + ', ' +
           '''' + @nm_historico + '''' +  ', ' +
           cast (@cd_usuario as varchar(40)) + ', ' +
           'GetDate()) ' +
         'update Produto_Fiscal ' +
         'set cd_classificacao_fiscal = ' + cast (@cd_class_nova as varchar(40)) + ', ' + 
             'cd_usuario = ' + cast (@cd_usuario as varchar(40)) + ', ' +
             'dt_usuario = GetDate() ' +
         'where ' +
             'cd_produto = @cd_produto ' +
         'delete #Tabela '+
           'where ' +
             'cd_produto = @cd_produto ' +
       'end ' 

print (@SQLA)
print (@SQLB)
exec  (@SQLA + @SQLB)

end 

   
