
CREATE PROCEDURE pr_consulta_saldo_produto_fase
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Saldo de Estoque
--Data          : 25/03/2002
--Atualizado    : 24/07/2002
--                22/04/2003 - Formatação da Máscara do Produto - ELIAS
--                             Novo atributo na fn_produto_localização, alterado a chamada - ELIAS
--                02.09.2005 - Consulta de Qtd. de Produto de Importação - Carlos Fernandes 
--                13/04/2006 - Paulo Souza
--                             Acrescentado à coluna Requisição de compras a quantidade de requisição
--                             de importação e uma nova coluna para quantidade em pedido de importação
-----------------------------------------------------------------------------------------------------
@ic_parametro         int, 
@nm_fantasia_produto  varchar(40),
@cd_grupo_produto     int,
@cd_serie_produto     int
AS

declare
  @SQL_Produto           as varchar(8000),
  @SQL_Produto_Saldos    as varchar(8000),
  @cd_fase_produto       as int,
  @cd_produto            as int,
  @qt_req_compra_produto as float,
  @qt_pd_compra_produto  as float,
  @SQL_Req_Compra        as varchar(8000),
  @SQL_Ped_Compra        as varchar(8000),
  @SQL_Total             as varchar(8000),
  @grupo_produto         as varchar(40),
  @serie_produto         as varchar(40),
  @SQL_Ped_Importacao    as varchar(8000)

set @SQL_Produto        = ''
set @SQL_Produto_Saldos = ''
set @SQL_Req_Compra     = ''
set @SQL_Ped_Compra     = ''
Set @SQL_Total          = ''
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
                     cast(@cd_fase_produto as varchar)+') LOCALIZACAO, '+  -- 22/04/2003
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
      set @SQL_Produto = @SQL_Produto + '(select distinct cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) '+
                                         'from Produto_Saldo x '+ 
                                         'where '+ 
                                           'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                           'x.cd_produto=p.cd_produto)'+                                              
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase) + '''' + ','

/*      set @SQL_Req_Compra = 
             @SQL_Req_Compra + ' (select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) '+
                                      'from Produto_Saldo x '+ 
                                      'where '+ 
                                      'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                      'x.cd_produto=p.cd_produto) +'
 
      set @SQL_Ped_Compra = 
             @SQL_Ped_Compra + ' (select distinct cast( isnull(sum(x.qt_pd_compra_produto),0.00 )+isnull(sum(x.qt_importacao_produto),0.00 ) as decimal(25,2)) '+
                                      'from Produto_Saldo x '+ 
                                      'where '+ 
                                      'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                      'x.cd_produto=p.cd_produto) +'

      set @SQL_Total = 
             @SQL_Total + ' (select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + '+
                             'cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + '+
                             'cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2)) )'+
                             'from Produto_Saldo x '+ 
                             'where '+ 
                             'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                             'x.cd_produto=p.cd_produto) +'
*/
      delete from #Fase where cd_fase_produto = @cd_fase_produto
    end

/*    set @SQL_Req_Compra = '(select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) ' +
                          'from Produto_Saldo x ' +
                          'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and  ' +
                          '      x.cd_produto = p.cd_produto) as ''Requisicao_de_Compra'','
*/
--    set @SQL_Ped_Compra = '(select distinct cast( isnull(sum(x.qt_pd_compra_produto),0.00 )+isnull(sum(x.qt_importacao_produto),0.00 ) as decimal(25,2)) ' +
 
--     set @SQL_Req_Compra = '(select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) ' +
--                           'from Produto_Saldo x ' +
--                           'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and  ' +
--                           '      x.cd_produto = p.cd_produto) as ''Requisicao_de_Compra'','

    set @SQL_Req_Compra = '(select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
                          '                 Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
                          '                              from requisicao_compra_item rci ' +
                          '                                   left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
                          '                                                                                 rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
                          '                                                                                 pii.dt_cancel_item_ped_imp is null ' +
                          '                              where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2)) ' +
                          ' from Produto_Saldo x ' +
                          ' where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                          '       x.cd_produto = p.cd_produto) as ''Requisicao_de_Compra'','

    set @SQL_Ped_Compra = '(select distinct cast( isnull(sum(x.qt_pd_compra_produto),0.00 ) as decimal(25,2)) ' +
                          'from Produto_Saldo x ' +
                          'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                          '      x.cd_produto = p.cd_produto) as ''Pedido_de_Compra'','

--     set @SQL_Total = '(select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + ' +
--                      '         cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
--                      '         cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2)) ) ' +
--                      'from Produto_Saldo x ' +
--                      'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
--                      '      x.cd_produto=p.cd_produto) as ''Total'''

--     set @SQL_Req_Compra = '(select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) ' +
--                           '                 Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
--                           '                              from requisicao_compra_item rci ' +
--                           '                                   left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
--                           '                                                                          rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
--                           '                                                                          pii.dt_cancel_item_ped_imp is null ' +
--                           '                              where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2))) as Requisicao_de_Compra,' 

    Set @SQL_Ped_Importacao = 'IsNull((select Sum(pii.qt_saldo_item_ped_imp) ' +
                              '        from pedido_importacao_item pii ' +
                              '        where pii.cd_produto = p.cd_produto and ' +
                              '              pii.qt_saldo_item_ped_imp > 0 and ' +
                              '              pii.dt_cancel_item_ped_imp is null ' +
                              '        group by pii.cd_produto),0) as Pedido_Importacao,'

    set @SQL_Total = '(select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + ' + 
                     '         cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
                     '         cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2))) + ' +
                     '         Cast(IsNull((select Sum(pii.qt_saldo_item_ped_imp) ' +
                     '                      from pedido_importacao_item pii ' +
                     '                      where pii.cd_produto = p.cd_produto and ' +
                     '                            pii.qt_saldo_item_ped_imp > 0 and ' +
                     '                            pii.dt_cancel_item_ped_imp is null),0.00) as decimal(25,2)) + ' +
                     '         Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
                     '                     from requisicao_compra_item rci ' +
                     '                     left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
                     '                                                                   rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
                     '                                                                   pii.dt_cancel_item_ped_imp is null ' +
                     '                     where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2)) ' +
                     'from Produto_Saldo x ' +
                     'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                     '      x.cd_produto=p.cd_produto) as ''Total'''


    set @SQL_Req_Compra     = LTRim(RTrim(@SQL_Req_Compra))
    set @SQL_Ped_Compra     = LTRim(RTrim(@SQL_Ped_Compra))
    set @SQL_Ped_Importacao = LTRim(RTrim(@SQL_Ped_Importacao))
    set @SQL_Total          = LTRim(RTrim(@SQL_Total))

--    set @SQL_Req_Compra = LTRim(RTrim(@SQL_Req_Compra)) + '0'
 
--    set @SQL_Ped_Compra = LTRim(RTrim(@SQL_Ped_Compra)) + '0'

--    set @SQL_Total      = LTRim(RTrim(@SQL_Total)) + '0'

--     Print( @SQL_Produto + '(' + @SQL_Ped_Compra + ') as qt_req_compra_produto,' + '(' + @SQL_Req_Compra + ') as pd_compra_produto')
--     Print('  from Produto p '+                                    
--           '  left outer join '+
--           '  Grupo_Produto g '+
--           '  on p.cd_grupo_produto = g.cd_grupo_produto '+
--           'where p.nm_fantasia_produto like ' + QuoteName(@nm_fantasia_produto+'%',''''))

--    Exec( @SQL_Produto + '(' + @SQL_Req_Compra + ') as ''Requisição_de_Compra'',' + 
--          '(' + @SQL_Ped_Compra + ') as ''Pedido_de_Compra'',' + 
--          '(' + @SQL_Total + ') as Total' + 
    Exec( @SQL_Produto +  @SQL_Req_Compra  + 
          @SQL_Ped_Compra + 
          @SQL_Ped_Importacao +
          @SQL_Total + 
          '  from Produto p  ' +                                    
          '  left outer join ' +
          '  Grupo_Produto g ' +
          '  on p.cd_grupo_produto = g.cd_grupo_produto '+
          'where p.nm_fantasia_produto like ' +'''' + @nm_fantasia_produto + '%' + '''')

--    exec (@SQL_Produto)
--    drop table #Fase
  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Saldo Geral do Produto de Acordo com a Fase
                        --(Filtro por Grupo)
-------------------------------------------------------------------------------
  begin
    select cd_fase_produto,nm_fase_produto into #Fase1 from Fase_Produto

    set @SQL_Produto='select distinct '+
                       'dbo.fn_produto_localizacao(p.cd_produto,'+
                       cast(@cd_fase_produto as varchar)+') LOCALIZACAO, '+  -- 22/04/2003
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
      set @SQL_Produto = @SQL_Produto + '(select distinct cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) '+
                                         'from Produto_Saldo x '+ 
                                         'where '+ 
                                           'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                           'x.cd_produto = p.cd_produto)'+                                              
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase1) + '''' +','
                      
--       set @SQL_Req_Compra = 
--              @SQL_Req_Compra + ' (select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) '+
--                                       'from Produto_Saldo x '+ 
--                                       'where '+ 
--                                       'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
--                                       'x.cd_produto=p.cd_produto) +'
 
--       set @SQL_Ped_Compra = 
--              @SQL_Ped_Compra + ' (select distinct cast(isnull(sum(x.qt_pd_compra_produto),0.00)+isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2)) '+
--                                       'from Produto_Saldo x '+ 
--                                       'where '+ 
--                                       'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
--                                       'x.cd_produto=p.cd_produto) +'

--       set @SQL_Total = 
--              @SQL_Total + ' (select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + '+
--                              'cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + '+
--                              'cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2)) )'+
--                              'from Produto_Saldo x '+ 
--                              'where '+ 
--                              'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
--                              'x.cd_produto=p.cd_produto) +'

      delete from #Fase1 where cd_fase_produto = @cd_fase_produto
    end

    set @SQL_Req_Compra = '(select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
                          '                 Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
                          '                              from requisicao_compra_item rci ' +
                          '                                   left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
                          '                                                                                 rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
                          '                                                                                 pii.dt_cancel_item_ped_imp is null ' +
                          '                              where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2)) ' +
                          ' from Produto_Saldo x ' +
                          ' where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                          '       x.cd_produto = p.cd_produto) as ''Requisicao_de_Compra'','

    set @SQL_Ped_Compra = '(select distinct cast( isnull(sum(x.qt_pd_compra_produto),0.00 ) as decimal(25,2)) ' +
                          'from Produto_Saldo x ' +
                          'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                          '      x.cd_produto = p.cd_produto) as ''Pedido_de_Compra'','

    Set @SQL_Ped_Importacao = 'IsNull((select Sum(pii.qt_saldo_item_ped_imp) ' +
                              '        from pedido_importacao_item pii ' +
                              '        where pii.cd_produto = p.cd_produto and ' +
                              '              pii.qt_saldo_item_ped_imp > 0 and ' +
                              '              pii.dt_cancel_item_ped_imp is null ' +
                              '        group by pii.cd_produto),0) as Pedido_Importacao,'

    set @SQL_Total = '(select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + ' + 
                     '         cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
                     '         cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2))) + ' +
                     '         Cast(IsNull((select Sum(pii.qt_saldo_item_ped_imp) ' +
                     '                      from pedido_importacao_item pii ' +
                     '                      where pii.cd_produto = p.cd_produto and ' +
                     '                            pii.qt_saldo_item_ped_imp > 0 and ' +
                     '                            pii.dt_cancel_item_ped_imp is null),0.00) as decimal(25,2)) + ' +
                     '         Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
                     '                     from requisicao_compra_item rci ' +
                     '                     left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
                     '                                                                   rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
                     '                                                                   pii.dt_cancel_item_ped_imp is null ' +
                     '                     where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2)) ' +
                     'from Produto_Saldo x ' +
                     'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                     '      x.cd_produto=p.cd_produto) as ''Total'''

--     set @SQL_Req_Compra = LTRim(RTrim(@SQL_Req_Compra)) + '0'
--     set @SQL_Ped_Compra = LTRim(RTrim(@SQL_Ped_Compra)) + '0'
--     set @SQL_Total      = LTRim(RTrim(@SQL_Total)) + '0'

    set @SQL_Req_Compra     = LTRim(RTrim(@SQL_Req_Compra))
    set @SQL_Ped_Compra     = LTRim(RTrim(@SQL_Ped_Compra))
    set @SQL_Ped_Importacao = LTRim(RTrim(@SQL_Ped_Importacao))
    set @SQL_Total          = LTRim(RTrim(@SQL_Total))

--     Exec( @SQL_Produto + '(' + @SQL_Req_Compra + ') as ''Requisição_de_Compra'',' + 
--           '(' + @SQL_Ped_Compra + ') as ''Pedido_de_Compra'',' + 
--           '(' + @SQL_Total + ') as Total' + 
    Exec( @SQL_Produto + @SQL_Req_Compra +
          @SQL_Ped_Compra + 
          @SQL_Ped_Importacao +
          @SQL_Total +
          '  from Produto p  ' +                                    
          '  left outer join ' +
          '  Grupo_Produto g ' +
          '  on p.cd_grupo_produto = g.cd_grupo_produto '+
          'where p.cd_grupo_produto= ' + @grupo_produto )


--     set @SQL_Produto = @SQL_Produto +' p.nm_produto '+ 
--                                      ' from Produto p '+                                    
--                                      ' left outer join '+
--                                      ' Grupo_Produto g '+
--                                      ' on p.cd_grupo_produto = g.cd_grupo_produto '+
--                                      'where p.cd_grupo_produto='+cast(@cd_grupo_produto as varchar)
                                    

--     print @SQL_Produto
--     exec (@SQL_Produto)
--     drop table #Fase1
         
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
      set @SQL_Produto = @SQL_Produto + '(select distinct cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) '+
                                         'from Produto_Saldo x '+ 
                                         'where '+ 
                                           'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
                                           'x.cd_produto=p.cd_produto)'+                                              
                                         ' as ' + '''' + (select top 1 Replace(nm_fase_produto,' ','_') from #Fase2) + '''' +','

--       set @SQL_Req_Compra = 
--              @SQL_Req_Compra + ' (select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) '+
--                                       'from Produto_Saldo x '+ 
--                                       'where '+ 
--                                       'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
--                                       'x.cd_produto=p.cd_produto) +'
--  
--       set @SQL_Ped_Compra = 
--              @SQL_Ped_Compra + ' (select distinct cast(isnull(sum(x.qt_pd_compra_produto),0.00)+isnull(sum(x.qt_importacao_produto),0.00) as decimal(25,2)) '+
--                                       'from Produto_Saldo x '+ 
--                                       'where '+ 
--                                       'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
--                                       'x.cd_produto=p.cd_produto) +'
-- 
--       set @SQL_Total = 
--              @SQL_Total + ' (select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + '+
--                              'cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + '+
--                              'cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2)) )'+
--                              'from Produto_Saldo x '+ 
--                              'where '+ 
--                              'x.cd_fase_produto= '+cast(@cd_fase_produto as varchar)+' and '+
--                              'x.cd_produto=p.cd_produto) +'
                     
      delete from #Fase2 where cd_fase_produto = @cd_fase_produto
    end

    set @SQL_Req_Compra = '(select distinct cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
                          '                 Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
                          '                              from requisicao_compra_item rci ' +
                          '                                   left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
                          '                                                                                 rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
                          '                                                                                 pii.dt_cancel_item_ped_imp is null ' +
                          '                              where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2)) ' +
                          ' from Produto_Saldo x ' +
                          ' where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                          '       x.cd_produto = p.cd_produto) as ''Requisicao_de_Compra'','

    set @SQL_Ped_Compra = '(select distinct cast( isnull(sum(x.qt_pd_compra_produto),0.00 ) as decimal(25,2)) ' +
                          'from Produto_Saldo x ' +
                          'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                          '      x.cd_produto = p.cd_produto) as ''Pedido_de_Compra'','

    Set @SQL_Ped_Importacao = 'IsNull((select Sum(pii.qt_saldo_item_ped_imp) ' +
                              '        from pedido_importacao_item pii ' +
                              '        where pii.cd_produto = p.cd_produto and ' +
                              '              pii.qt_saldo_item_ped_imp > 0 and ' +
                              '              pii.dt_cancel_item_ped_imp is null ' +
                              '        group by pii.cd_produto),0) as Pedido_Importacao,'

    set @SQL_Total = '(select (cast(isnull(sum(x.qt_saldo_atual_produto),0.00) as decimal(25,2)) + ' + 
                     '         cast(isnull(sum(x.qt_req_compra_produto),0.00) as decimal(25,2)) + ' +
                     '         cast(isnull(sum(x.qt_pd_compra_produto),0.00) as decimal(25,2))) + ' +
                     '         Cast(IsNull((select Sum(pii.qt_saldo_item_ped_imp) ' +
                     '                      from pedido_importacao_item pii ' +
                     '                      where pii.cd_produto = p.cd_produto and ' +
                     '                            pii.qt_saldo_item_ped_imp > 0 and ' +
                     '                            pii.dt_cancel_item_ped_imp is null),0.00) as decimal(25,2)) + ' +
                     '         Cast(IsNull((select Sum(rci.qt_item_requisicao_compra) ' +
                     '                     from requisicao_compra_item rci ' +
                     '                     left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and ' +
                     '                                                                   rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and ' +
                     '                                                                   pii.dt_cancel_item_ped_imp is null ' +
                     '                     where rci.cd_produto = p.cd_produto), 0.00) as decimal(25,2)) ' +
                     'from Produto_Saldo x ' +
                     'where x.cd_fase_produto in (select cd_fase_produto from Fase_Produto) and ' +
                     '      x.cd_produto=p.cd_produto) as ''Total'''

--     set @SQL_Req_Compra = LTRim(RTrim(@SQL_Req_Compra)) + '0'
--     set @SQL_Ped_Compra = LTRim(RTrim(@SQL_Ped_Compra)) + '0'
--     set @SQL_Total      = LTRim(RTrim(@SQL_Total)) + '0'

    set @SQL_Req_Compra     = LTRim(RTrim(@SQL_Req_Compra))
    set @SQL_Ped_Compra     = LTRim(RTrim(@SQL_Ped_Compra))
    set @SQL_Ped_Importacao = LTRim(RTrim(@SQL_Ped_Importacao))
    set @SQL_Total          = LTRim(RTrim(@SQL_Total))

--     Exec( @SQL_Produto + '(' + @SQL_Req_Compra + ') as ''Requisição_de_Compra'',' + 
--           '(' + @SQL_Ped_Compra + ') as ''Pedido_de_Compra'',' + 
--           '(' + @SQL_Total + ') as Total' + 
    Exec( @SQL_Produto +  @SQL_Req_Compra  + 
          @SQL_Ped_Compra + 
          @SQL_Ped_Importacao +
          @SQL_Total + 
          '  from Produto p  ' +                                    
          '  left outer join ' +
          '  Grupo_Produto g ' +
          '  on p.cd_grupo_produto = g.cd_grupo_produto '+
          'where p.cd_serie_produto= ' + @serie_produto )


--     set @SQL_Produto = @SQL_Produto +' p.nm_produto '+ 
--                                      ' from Produto p '+                                    
--                                      ' left outer join '+
--                                      ' Grupo_Produto g '+
--                                      ' on p.cd_grupo_produto = g.cd_grupo_produto '+
--                                      'where p.cd_serie_produto='+cast(@cd_serie_produto as varchar)
                                    
--     print @SQL_Produto
--     exec (@SQL_Produto)
--     drop table #Fase2    
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

--     print @SQL_Produto
    exec (@SQL_Produto)
    drop table #Fase3
  end

