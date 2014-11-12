
CREATE PROCEDURE pr_consulta_saldo_inventario

@ic_parametro         int, 
@nm_fantasia_produto  varchar(40),
@cd_grupo_produto     int,
@cd_serie_produto     int,
@dt_fechamento        datetime
AS

declare
  @SQL_Produto            as varchar(8000),
  @SQL_Produto_Fechamento as varchar(8000),
  @cd_fase_produto        as int,
  @cd_produto             as int,
  @qt_req_compra_produto  as float,
  @qt_pd_compra_produto   as float,
  @SQL_Total              as varchar(8000),
  @grupo_produto          as varchar(40),
  @serie_produto          as varchar(40)

set @SQL_Produto        = ''
set @SQL_Produto_Fechamento = ''
set @SQL_Total          = ''
set @cd_fase_produto    = 0
set @cd_produto         = 0
set @grupo_produto      = Str(@cd_grupo_produto)
set @serie_produto      = Str(@cd_serie_produto)


select @cd_fase_produto = cd_fase_produto from parametro_comercial
where cd_empresa = dbo.fn_empresa()


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Saldo Geral do Produto de Acordo com a Fase
                        --(Filtro por Fantasia)
-------------------------------------------------------------------------------
  begin
    select cd_fase_produto, nm_fase_produto into #Fase from Fase_Produto

    set @SQL_Produto='select distinct '+
                     'dbo.fn_produto_localizacao(p.cd_produto,'+
                     cast(@cd_fase_produto as varchar)+') LOCALIZACAO, '+
                     'p.cd_produto,'+
                     'Case
                        When IsNull(g.cd_mascara_grupo_produto, '''') <> ''''
                        then dbo.fn_formata_mascara(IsNull(g.cd_mascara_grupo_produto, ''''), IsNull(p.cd_mascara_produto,''''))
                        Else IsNull(p.cd_mascara_produto, '''')
                      End as cd_mascara_produto,
                      p.nm_fantasia_produto,
                      p.nm_produto,'
 
   while exists(select 'X' from #Fase)
    begin
      select top 1 @cd_fase_produto = cd_fase_produto from #Fase

      set @SQL_Produto = @SQL_Produto + '(select distinct cast(isnull(sum(x.qt_atual_prod_fechamento),0.00) as decimal(25,2)) '+
                                         'from Produto_Fechamento x '+ 
                                         'where '+ 
                                           'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                           'x.cd_produto=p.cd_produto and '+                                              
                                           'x.dt_produto_fechamento=''' + convert( varchar, @dt_fechamento, 1 ) +''' )'+                                              
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase) + '''' + ','

      set @SQL_Total = 
             @SQL_Total + ' (select (cast(isnull(sum(x.qt_atual_prod_fechamento),0.00) as decimal(25,2)) ) '+
                             'from Produto_Fechamento x '+ 
                             'where '+ 
                             'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                             'x.dt_produto_fechamento=''' + convert( varchar, @dt_fechamento, 1 ) +''' and '+
                             'x.cd_produto=p.cd_produto ) +'

      delete from #Fase where cd_fase_produto = @cd_fase_produto
    end


    set @SQL_Total = LTRim(RTrim(@SQL_Total)) + '0'

    Exec( @SQL_Produto +
          '(' + @SQL_Total + ') as Total' + 
          '  from Produto p  ' +                                    
          '  left outer join ' +
          '  Grupo_Produto g ' +
          '  on p.cd_grupo_produto = g.cd_grupo_produto '+
          'where p.nm_fantasia_produto like ' +'''' + @nm_fantasia_produto + '%' + '''')

    drop table #Fase

  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Saldo Geral do Produto de Acordo com a Fase
                        --(Filtro por Grupo)
-------------------------------------------------------------------------------
  begin
    select cd_fase_produto,nm_fase_produto into #Fase1 from Fase_Produto

    set @SQL_Produto='select distinct '+
                       'dbo.fn_produto_localizacao(p.cd_produto,'+
                       cast(@cd_fase_produto as varchar)+') LOCALIZACAO, '+
                       'p.cd_produto,'+
                       'Case
                          When IsNull(g.cd_mascara_grupo_produto, '''') <> ''''
                          then dbo.fn_formata_mascara(IsNull(g.cd_mascara_grupo_produto, ''''), IsNull(p.cd_mascara_produto,''''))
                          Else IsNull(p.cd_mascara_produto, '''')
                        End as cd_mascara_produto,
                        p.nm_fantasia_produto,
                        p.nm_produto,'
 
   while exists(select 'X' from #Fase1)
    begin
      select top 1 @cd_fase_produto = cd_fase_produto 
      from #Fase1
      set @SQL_Produto = @SQL_Produto + '(select distinct cast(isnull(sum(x.qt_atual_prod_fechamento),0.00) as decimal(25,2)) '+
                                         'from Produto_Fechamento x '+ 
                                         'where '+ 
                                           'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                           'x.cd_produto=p.cd_produto and '+                                              
                                           'x.dt_produto_fechamento=''' + convert( varchar, @dt_fechamento, 1 ) +''' )'+
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase1) + '''' +','                     

      set @SQL_Total = 
             @SQL_Total + ' (select (cast(isnull(sum(x.qt_atual_prod_fechamento),0.00) as decimal(25,2)) ) '+
                             'from Produto_Fechamento x '+ 
                             'where '+ 
                             'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                             'x.dt_produto_fechamento=''' + convert( varchar, @dt_fechamento, 1 ) +''' and '+
                             'x.cd_produto=p.cd_produto ) +'

      delete from #Fase1 where cd_fase_produto = @cd_fase_produto
    end


    set @SQL_Total = LTRim(RTrim(@SQL_Total)) + '0'

    Exec( @SQL_Produto +
          '(' + @SQL_Total + ') as Total' + 
          '  from Produto p  ' +                                    
          '  left outer join ' +
          '  Grupo_Produto g ' +
          '  on p.cd_grupo_produto = g.cd_grupo_produto '+
          'where p.cd_grupo_produto= ' + @grupo_produto )

    drop table #Fase1
         
  end
  
-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta Saldo Geral do Produto de Acordo com a Fase
                        --(Filtro por Série)
-------------------------------------------------------------------------------
  begin
    select cd_fase_produto,nm_fase_produto into #Fase2 from Fase_Produto

    set @SQL_Produto='select distinct '+
                       'dbo.fn_produto_localizacao(p.cd_produto,'+
                       cast(@cd_fase_produto as varchar)+') LOCALIZACAO, '+
                       'p.cd_produto,'+
                       'Case
                          When IsNull(g.cd_mascara_grupo_produto, '''') <> ''''
                          then dbo.fn_formata_mascara(IsNull(g.cd_mascara_grupo_produto, ''''), IsNull(p.cd_mascara_produto,''''))
                          Else IsNull(p.cd_mascara_produto, '''')
                        End as cd_mascara_produto,
                        p.nm_fantasia_produto,
                        p.nm_produto,'
 
   while exists(select 'X' from #Fase2)
    begin
      select top 1 @cd_fase_produto = cd_fase_produto from #Fase2
      set @SQL_Produto = @SQL_Produto + '(select distinct cast(isnull(sum(x.qt_atual_prod_fechamento),0.00) as decimal(25,2)) '+
                                         'from Produto_Fechamento x '+ 
                                         'where '+ 
                                           'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                           'x.cd_produto=p.cd_produto and '+                                              
                                           'x.dt_produto_fechamento=''' + convert( varchar, @dt_fechamento, 1 ) +''' )'+                                              
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase2) + '''' +','

      set @SQL_Total = 
             @SQL_Total + ' (select (cast(isnull(sum(x.qt_atual_prod_fechamento),0.00) as decimal(25,2)) ) '+
                             'from Produto_Fechamento x '+ 
                             'where '+ 
                             'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                             'x.dt_produto_fechamento=''' + convert( varchar, @dt_fechamento, 1 ) +''' and '+
                             'x.cd_produto=p.cd_produto ) +'
                      
      delete from #Fase2 where cd_fase_produto = @cd_fase_produto
    end


    set @SQL_Total = LTRim(RTrim(@SQL_Total)) + '0'

    Exec( @SQL_Produto +
          '(' + @SQL_Total + ') as Total' + 
          '  from Produto p  ' +                                    
          '  left outer join ' +
          '  Grupo_Produto g ' +
          '  on p.cd_grupo_produto = g.cd_grupo_produto '+
          'where p.cd_serie_produto= ' + @serie_produto )

    drop table #Fase2

  end

-------------------------------------------------------------------------------
if @ic_parametro = 4    -- Zera a Consulta
-------------------------------------------------------------------------------
  begin

    select cd_fase_produto,nm_fase_produto into #Fase3 from Fase_Produto

    set @SQL_Produto='select distinct '+
                      ''''' LOCALIZACAO, 
                      0 as cd_produto,
                      '''' as cd_mascara_produto,
                      '''' as nm_fantasia_produto,
                      '''' as nm_produto,'
 
   while exists(select 'X' from #Fase3)
    begin
      select top 1 @cd_fase_produto = cd_fase_produto from #Fase3
      set @SQL_Produto = @SQL_Produto + '0 ' +                                              
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase3) + '''' + ','
                      
      delete from #Fase3 where cd_fase_produto = @cd_fase_produto
    end

    set @SQL_Produto = @SQL_Produto+' 0 as cd_produto'

    exec (@SQL_Produto)

    drop table #Fase3

  end

