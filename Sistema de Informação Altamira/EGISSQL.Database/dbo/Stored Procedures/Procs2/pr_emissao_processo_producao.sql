
CREATE PROCEDURE pr_emissao_processo_producao

@ic_liberado    char(1)  = 'N',
@ic_programado  char(1)  = 'N',
@cd_processo    int      = 0,
@dt_inicial     datetime = '',
@dt_final       datetime = '',
@ic_parametro   int      = 1

as

declare @SQL varchar(8000)

------------------------------------------------------------
if @ic_parametro = 1 -- SQL para o Modelo 1
------------------------------------------------------------
begin

set @SQL = ' SELECT DISTINCT    cd_processo, cd_pedido_venda, cd_item_pedido_venda, ' +
           '                    nm_processista, cd_usuario_mapa_processo, nm_numero_apontamento ' +
           ' INTO               #Processo_Producao ' + 
           ' FROM               Processo_Producao ' +
	   ' WHERE ' 

----------------------------------------------------------------------
if @cd_processo = 0  -- Vou querer todos os processos
----------------------------------------------------------------------
  begin
    set @SQL = @SQL + 'dt_processo between ' + '''' + cast(@dt_inicial as varchar(20)) + '''' +
	              ' and ' + '''' + cast(@dt_final as varchar(20)) + ''''

    -----------------------------------------------------------------------------
    if @ic_liberado = 'S' -- Mas só quero que traga os liberados nesse período.
    -----------------------------------------------------------------------------
      set @SQL = @SQL + ' and ic_libprog_processo = ''S'''

    -----------------------------------------------------------------------------
    if @ic_programado = 'S' -- Mas só quero que traga os que tiverem data de programação nesse período.
    -----------------------------------------------------------------------------
      set @SQL = @SQL + ' and dt_prog_processo is not null '

--  print @SQL
  end
-------------------------------------------------
else -- Vou querer apenas o processo digitado.
--------------------------------------------------
  set @SQL = @SQL + 'cd_processo = ' + cast(@cd_processo as varchar(20))

set @SQL = @SQL + ' SELECT Identity(int, 1,1) as cd_chave, ' + 
                          'pp.nm_processista, ' +
	                  'pp.cd_processo, ' +
                          'pp.nm_numero_apontamento, ' +   
		          'ppc.cd_item_processo as cd_seq_processo, ' + 
                          '0 as cd_placa, ' +
			  'op.nm_fantasia_operacao + isnull(ppc.nm_opecompl_processo,'''') as nm_operacao, ' +  -- LUCIO : 07/07/04
			  'ppc.nm_obs_item_processo, ' +
		          'ppc.qt_dia_processo, ' + 
                          'nm_maquina =         ' + 
                          '   case when ppc.dt_programacao_processo is not null then m.nm_fantasia_maquina ' +
                          '        when ppc.dt_programacao_processo is null and isnull(ppc.cd_servico_especial,0) > 0 then se.nm_servico_especial ' +
                          '   else m.nm_fantasia_maquina + ppc.nm_maqcompl_processo end, ' +  
			  'gm.nm_grupo_maquina, ' +  
			  'ppc.qt_seq_ant_processo, ' + 
			  'ppc.qt_hora_estimado_processo, ' + 
			  'ppc.qt_hora_setup_processo, ' + 
			  'qt_tempo_total = isnull(ppc.qt_hora_estimado_processo,0)+isnull(ppc.qt_hora_estimado_processo,0), ' + 
                          'dt_final_programacao = ' +
                          '  (select max(p.dt_programacao) ' + 
                          '   from programacao p inner join ' + 
                          '        programacao_composicao pc on pc.cd_programacao = p.cd_programacao  ' + 
                          '   where pc.cd_processo = ppc.cd_processo and  ' + 
                          '         pc.cd_item_processo = ppc.cd_item_processo), ' + 
                          'usu_prog.nm_fantasia_usuario as UsuarioProgramador, ' + 
			  'ppc.dt_programacao_processo ' +
                  ' ' +
		  'INTO   #Processo_Producao_Composicao ' + 
                  ' ' + 
		  'FROM Processo_Producao_Composicao ppc ' + 
                  ' INNER JOIN #Processo_Producao pp on ' +
                  ' pp.cd_processo = ppc.cd_processo ' +
                  ' LEFT JOIN Operacao op ON ' + 
                  ' op.cd_operacao = ppc.cd_operacao ' +  
                  ' LEFT JOIN Servico_Especial se ON ' + 
                  ' se.cd_servico_especial = ppc.cd_servico_especial ' +  
                  ' LEFT JOIN Maquina m ON ' + 
                  ' m.cd_maquina = (case when isnull(ppc.cd_maquina_processo,0)>0 then ppc.cd_maquina_processo else ppc.cd_maquina end) ' +
                  ' LEFT JOIN Grupo_Maquina gm ON ' +
                  ' gm.cd_grupo_maquina = m.cd_grupo_maquina ' +
                  ' LEFT OUTER JOIN EgisAdmin.dbo.Usuario usu_prog ON ' +
                  ' pp.cd_usuario_mapa_processo = usu_prog.cd_usuario ' +
                  ' order by cd_item_processo '

set @SQL = @SQL + 'SELECT  Identity(int, 1,1) as cd_chave, ' + 
                          'pp.nm_processista, ' +
			  'pp.cd_processo, ' + 
                          'pp.nm_numero_apontamento, ' +   
		  	  'ppc.cd_seq_comp_processo as cd_placa_processo, ' +
                          'ppc.cd_placa_processo as cd_placa, ' +
			  'qt_comp_processo = (ppc.qt_comp_processo * pvi.qt_item_pedido_venda),' + 
			  'ppc.nm_medida_comp_processo, ' + 
			  'p.nm_fantasia_produto, ' + 
                          'isnull(ppc.cd_produto,0) as cd_produto, ' +
			  'ppc.nm_obs_comp_processo, ' + 
                          'ppc.cd_mat_prima, ' +
                          'ppc.ic_esp_comp_processo, ' +
                          'isnull(ppc.nm_comp_processo,pl.sg_placa) as nm_comp_processo, ' +
			  'mp.nm_fantasia_mat_prima, ' +
                          'ppc.cd_seq_comp_processo as cd_seq_comp_processo, ' +
                          'ic_compra_item_orcamento = ' +
                          'case when (                ' + 
                          '  select top 1 a.cd_requisicao_compra ' +
                          '  from requisicao_compra_item a, ' +
                          '       requisicao_compra b       ' + 
                          '  where a.cd_pedido_venda = pp.cd_pedido_venda and ' +
                          '        a.cd_item_pedido_venda = pp.cd_item_pedido_venda and ' +
                          '        a.nm_placa = pl.sg_placa and ' + 
                          '        a.cd_requisicao_compra = b.cd_requisicao_compra and ' +
                          '        b.cd_tipo_requisicao = 2 ) > 0 then ''S'' else ''N'' end ' +
                  ' ' +
		  'INTO   #Processo_Producao_Componente ' + 
                  ' ' +
		  'FROM Processo_Producao_Componente ppc ' +
                  ' INNER JOIN #Processo_Producao pp on ' +
                  ' pp.cd_processo = ppc.cd_processo ' + 
                  ' LEFT OUTER JOIN Pedido_Venda_Item pvi on ' +
                  ' pp.cd_pedido_venda      = pvi.cd_pedido_venda and ' + 
                  ' pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda' + 
                  ' LEFT JOIN Materia_Prima mp ON ' + 
                  ' ppc.cd_mat_prima = mp.cd_mat_prima ' +
                  ' LEFT JOIN Produto p ON ' +
                  ' ppc.cd_produto = p.cd_produto ' +
                  ' left join Placa pl on ' +
                  ' pl.cd_placa = ppc.cd_placa_processo ' +
                  ' order by ppc.cd_componente_processo ' 

set @SQL = @SQL + 'SELECT  IsNull(ppc.cd_processo, comp.cd_processo) as cd_processo, ' +    
                          'ppc.nm_processista, ' + 
                          'comp.nm_numero_apontamento, ' +  
			  'ppc.cd_seq_processo, ' +
                          'comp.cd_placa, ' +
		          'ppc.nm_operacao, ' +
			  'ppc.nm_obs_item_processo, ' + 
			  'ppc.nm_maquina, ' + 
			  'ppc.nm_grupo_maquina, ' +  
			  'ppc.qt_seq_ant_processo, ' +
			  'ppc.qt_hora_estimado_processo, ' + 
                          'ppc.qt_tempo_total, ' +
			  'ppc.dt_programacao_processo, ' +
			  'ppc.qt_dia_processo, ' +
                          'ppc.dt_final_programacao, ' +
			  'comp.cd_seq_comp_processo, ' +
			  'comp.cd_placa_processo, ' +
			  'comp.qt_comp_processo, ' +
			  'comp.nm_comp_processo, ' + 
	     		  'comp.nm_medida_comp_processo, ' +
			  'nm_fantasia_produto = ' +
                          'case when (ic_compra_item_orcamento = ''S'' and isnull(cd_produto,0) = 0) and ' + 
                          '          (comp.nm_comp_processo is not null) then ''Esp.'' ' +
                          '     when (comp.ic_esp_comp_processo = ''S'' and isnull(cd_produto,0) = 0) then ''Esp.'' ' +  
                          'else comp.nm_fantasia_produto end, ' +
			  'comp.nm_obs_comp_processo, ' +
                          'comp.ic_compra_item_orcamento, ' +   
			  'mp.nm_fantasia_mat_prima, ' +
			  'ppc.UsuarioProgramador ' +
		'FROM #Processo_Producao_Composicao ppc ' +
                'full outer join #Processo_Producao_Componente comp on ' +
                'comp.cd_chave = ppc.cd_chave ' + 
                'left outer join Materia_Prima mp ON ' +
                'comp.cd_mat_prima = mp.cd_mat_prima ' +
		'order by isnull(ppc.cd_seq_processo,100),comp.cd_seq_comp_processo' 

--print(@SQL)
exec(@SQL)

end

--------------------------------------------------------------
else -- SQL para os outros modelos.
--------------------------------------------------------------
begin

set @SQL = ' SELECT DISTINCT    cd_processo, nm_processista ' +
           ' INTO               #Processo_Producao ' + 
           ' FROM               Processo_Producao ' +
	   ' WHERE ' 

----------------------------------------------------------------------
if @cd_processo = 0  -- Vou querer todos os processos, por favor...
----------------------------------------------------------------------
  begin
    set @SQL = @SQL + 'dt_processo between ' + '''' + cast(@dt_inicial as varchar(20)) + '''' +
	              ' and ' + '''' + cast(@dt_final as varchar(20)) + ''''

    -----------------------------------------------------------------------------
    if @ic_liberado = 'S' -- Mas só quero que traga os liberados nesse período.
    -----------------------------------------------------------------------------
      set @SQL = @SQL + ' and ic_libprog_processo = ''S'''

    -----------------------------------------------------------------------------
    if @ic_programado = 'S' -- Mas só quero que traga os que tiverem data de programação nesse período.
    -----------------------------------------------------------------------------
      set @SQL = @SQL + ' and dt_prog_processo is not null '

--  print @SQL
  end
-------------------------------------------------
else -- Vou querer apenas o processo digitado.
--------------------------------------------------
  set @SQL = @SQL + 'cd_processo = ' + cast(@cd_processo as varchar(20))


set @SQL = @SQL + 'SELECT  ppc.cd_processo, ' +    
                          ''''' as nm_processista, ' +
                          ''''' as nm_numero_apontamento, ' +  
			  '0 as cd_seq_processo, ' +
                          '0 as cd_placa, ' +
		          ''''' as nm_operacao, ' +
			  ''''' as nm_obs_item_processo, ' + 
			  ''''' as nm_maquina, ' + 
			  ''''' as nm_grupo_maquina, ' +  
			  '0 as qt_seq_ant_processo, ' +
			  '0.00 as qt_hora_estimado_processo, ' +
                          '0.00 as qt_hora_setup_processo, '+ 
                          '0.00 as qt_tempo_total, '+
			  'cast(Null as datetime) as dt_programacao_processo, ' +
			  '0 as qt_dia_processo, ' +
                          'cast(Null as datetime) as dt_final_programacao, ' +
			  '0 as cd_placa_processo, ' +
			  '0.00 as qt_comp_processo, ' +
			  ''''' as nm_comp_processo, ' + 
	     		  ''''' as nm_medida_comp_processo, ' +
			  ''''' as nm_fantasia_produto, ' +
			  ''''' as nm_obs_comp_processo, ' +
                          ''''' as ic_compra_item_orcamento, ' +
                          '0    as cd_seq_comp_processo, ' +
			  ''''' as nm_fantasia_mat_prima, ' +
                          ''''' as UsuarioProgramador ' +
		'FROM #Processo_Producao ppc '

--print(@SQL)
exec(@SQL)

end

