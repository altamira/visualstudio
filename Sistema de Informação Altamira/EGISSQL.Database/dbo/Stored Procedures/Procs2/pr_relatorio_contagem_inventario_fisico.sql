
CREATE PROCEDURE pr_relatorio_contagem_inventario_fisico

@dt_inventario   datetime,
@cd_fase_produto int 		= 0,
@nm_modulo	 varchar(10) 	= '',
@cd_contagem	 int		= 1

AS


declare @SEL   as varchar(8000)
declare @WHE   as varchar(8000)
declare @ORD as varchar(8000)

set @SEL = 'select ' +
             'fp.nm_fase_produto, ' +
             'isnull(i.nm_modulo_localizacao,'''+''') as nm_modulo, ' +
    	     'isnull(i.nm_localizacao_produto,'''+''') as nm_endereco, ' +
             --'ltrim(rtrim(isnull(p.nm_fantasia_produto,'''+'''))) as nm_fantasia_produto, ' +
             'ltrim(rtrim(isnull(p.nm_fantasia_produto,isnull(p.cd_mascara_produto,'''+''')))) as nm_fantasia_produto, ' +
             'i.cd_produto as cd_produto, ' +
             'um.sg_unidade_medida as sg_unidade, ' +
             'i.qt_atual_sistema as qt_sistema, ' +
             'i.qt_contagem1 as qt_contagem1, ' +
             'i.qt_contagem2 as qt_contagem2, ' +
             'i.qt_contagem3 as qt_contagem3, ' +
             'i.qt_contagem4 as qt_contagem4, ' +
             'i.qt_contagem5 as qt_contagem5, ' +
             'i.qt_real as qt_real, ' +
             'i.cd_fase_produto, ' +
             'i.dt_inventario ' +
           'from ' +
             'Inventario_Fisico 	i  	left outer join ' +
             'Fase_Produto		fp 	on i.cd_fase_produto = fp.cd_fase_produto left outer join ' +
             'Produto		p	on i.cd_produto = p.cd_produto left outer join ' +
             'Unidade_Medida	um	on p.cd_unidade_medida = um.cd_unidade_medida '

set @WHE = ' where ' +
               'i.cd_fase_produto is not null and '+
               'i.dt_inventario 		= '''+cast(@dt_inventario as varchar)+''' and ' +
               'i.cd_fase_produto 		= case when isnull('+cast(@cd_fase_produto as varchar)+',0) > 0 then '+cast(@cd_fase_produto as varchar)+ ' else i.cd_fase_produto end and ' +
               'i.nm_modulo_localizacao	= case when ltrim(rtrim(isnull('+''''+@nm_modulo+''''+','+'''''))) <> '''' then ltrim(rtrim(isnull('+''''+@nm_modulo+''''+','+'''''))) else i.nm_modulo_localizacao end '

if @cd_contagem = 2
  set @WHE = @WHE + ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem1,0) '

if @cd_contagem = 3
  set @WHE = @WHE + ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem1,0)  ' + 
                    ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem2,0) ' +
                    ' and (isnull(qt_contagem1,0)       <> isnull(qt_contagem2,0)  ' +
                    ' or qt_contagem1 is null or qt_contagem2 is null ) '

if @cd_contagem = 4
  set @WHE = @WHE + ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem1,0)  ' + 
                    ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem2,0) ' +
                    ' and (isnull(qt_atual_sistema,0) <> isnull(qt_contagem3,0) ' +
                    ' or qt_contagem3 is null) ' +
                    ' and (isnull(qt_contagem1,0)       <> isnull(qt_contagem2,0)  ' +
                    ' or qt_contagem1 is null or qt_contagem2 is null) ' +
                    ' and (isnull(qt_contagem1,0)       <> isnull(qt_contagem3,0)  ' +
                    ' or qt_contagem1 is null or qt_contagem3 is null) ' +
                    ' and (isnull(qt_contagem2,0)       <> isnull(qt_contagem3,0)  ' +
                    ' or qt_contagem2 is null or qt_contagem3 is null) ' 

if @cd_contagem = 5
  set @WHE = @WHE + ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem1,0)  ' + 
                    ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem2,0) ' +
                    ' and isnull(qt_atual_sistema,0) <> isnull(qt_contagem3,0) ' +
                    ' and (isnull(qt_atual_sistema,0) <> isnull(qt_contagem4,0) ' +
                    ' or qt_contagem4 is null) ' +
                    ' and (isnull(qt_contagem1,0)       <> isnull(qt_contagem2,0)  ' +
                    ' or qt_contagem1 is null or qt_contagem2 is null) ' +
                    ' and (isnull(qt_contagem1,0)       <> isnull(qt_contagem3,0)  ' +
                    ' or qt_contagem1 is null or qt_contagem3 is null) ' +
                    ' and (isnull(qt_contagem1,0)       <> isnull(qt_contagem4,0)  ' +
                    ' or qt_contagem1 is null or qt_contagem4 is null) ' +
                    ' and (isnull(qt_contagem2,0)       <> isnull(qt_contagem3,0)  ' +
                    ' or qt_contagem2 is null or qt_contagem3 is null) ' +
                    ' and (isnull(qt_contagem2,0)       <> isnull(qt_contagem4,0)  ' +
                    ' or qt_contagem2 is null or qt_contagem4 is null) ' +
                    ' and (isnull(qt_contagem3,0)       <> isnull(qt_contagem4,0)  ' +
                    ' or qt_contagem3 is null or qt_contagem4 is null) ' 

set @ORD = ' order by ' +
              'fp.nm_fase_produto, ' +
    	      'isnull(i.nm_modulo_localizacao,''''), ' +
    	      'isnull(i.nm_localizacao_produto,''''), ' +
    	      'ltrim(rtrim(isnull(p.nm_fantasia_produto,''''))) '

exec (@SEL + @WHE + @ORD)

