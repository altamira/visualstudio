
CREATE PROCEDURE pr_consulta_movto_anual_plano_financeiro

@ic_parametro             int, 
@cd_plano_financeiro      int,
@cd_tipo_lancamento_fluxo int,
@cd_ano                   int,
@dt_inicial               datetime,
@dt_final                 datetime

AS


-------------------------------------------------------------------------------
--Atualização da Tabela de Plano Financeiro Movimento
-------------------------------------------------------------------------------
--delete from plano_financeiro_saldo
--delete from plano_financeiro_movimento


declare @cd_empresa int

if @dt_inicial is null
begin
 set @dt_inicial = cast( '01/01/'+cast(@cd_ano as varchar(4)) as datetime )
end

if @dt_final is null
begin
 set @dt_final   = cast( '12/31/'+cast(@cd_ano as varchar(4)) as datetime )
end

--select @dt_inicial
--select @dt_final
-- delete from plano_financeiro_saldo
-- delete from plano_financeiro_movimento

set @cd_empresa = dbo.fn_empresa()


--Atualização do Fluxo de Caixa

  exec pr_atualiza_fluxo_caixa 
      @cd_empresa, 
      @cd_tipo_lancamento_fluxo, 
      @dt_inicial,
      @dt_final

-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Movimentos do Plano Financeiro
-------------------------------------------------------------------------------
  begin

    declare @qt_cont                     int
    declare @cd_plano_financeiro_inicial int

    --select * from plano_financeiro

    -- Fazendo os primeiros Selects para pegar o nome e a quantidade de meses possíveis.

    select
      tof.nm_tipo_operacao as cd_mascara,
      gf.nm_grupo_financeiro,
      pf.cd_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      pf.cd_mascara_plano_financeiro,
      cast(Null as Float) as 'Mes1',
      cast(Null as Float) as 'Mes2',
      cast(Null as Float) as 'Mes3',
      cast(Null as Float) as 'Mes4',
      cast(Null as Float) as 'Mes5',
      cast(Null as Float) as 'Mes6',
      cast(Null as Float) as 'Mes7',
      cast(Null as Float) as 'Mes8',
      cast(Null as Float) as 'Mes9',
      cast(Null as Float) as 'Mes10',
      cast(Null as Float) as 'Mes11',
      cast(Null as Float) as 'Mes12'
    into
     #Temp_PF
    from
      Plano_Financeiro pf with (nolock)                                      left outer join
      Grupo_Financeiro gf          with (nolock) on gf.cd_grupo_financeiro = pf.cd_grupo_financeiro left outer join
      Tipo_Operacao_Financeira tof with (nolock) on tof.cd_tipo_operacao = gf.cd_tipo_operacao
      
    where
      ( pf.cd_plano_financeiro = @cd_plano_financeiro ) or 
      ( @cd_plano_financeiro = 0 )

    create table #Temp_Movto
      (cd_plano_financeiro int,
       cd_mes              int,
       vl_plano_financeiro float,
       cd_tipo_operacao    int)

    -- Fazendo somatória dos dias agrupados por plano e pelo dia do movimento.

    insert into #Temp_Movto
      select pfm.cd_plano_financeiro,
             month(pfm.dt_movto_plano_financeiro)    as 'cd_mes',
             sum( isnull(pfm.vl_plano_financeiro,0)) as 'vl_plano_financeiro',
             tof.cd_tipo_operacao
      from Plano_Financeiro_Movimento pfm with (nolock)                            inner join
           Plano_Financeiro pf            with (nolock) on pf.cd_plano_financeiro = pfm.cd_plano_financeiro left outer join
           Grupo_Financeiro gf            with (nolock) on gf.cd_grupo_financeiro = pf.cd_grupo_financeiro  left outer join
           tipo_operacao_financeira tof   with (nolock) on tof.cd_tipo_operacao = gf.cd_tipo_operacao
      where 
           year(pfm.dt_movto_plano_financeiro) = @cd_ano and
           ( ( pfm.cd_plano_financeiro = @cd_plano_financeiro ) or
           ( @cd_plano_financeiro = 0 ) ) and
           pfm.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo
      group by
           pfm.cd_plano_financeiro, month(pfm.dt_movto_plano_financeiro), tof.cd_tipo_operacao
        
    -- Fazendo Updates para cada semana, ordenando por plano financeiro.
    -- Ou seja, vou atualizar um plano financeiro por vez e um Mes por vez,
    -- até acabar todos os movimentos da tabela Temporária.
   
    while exists ( select top 1 cd_plano_financeiro
                   from #Temp_Movto
                  order by cd_plano_financeiro ) 
      begin
  
        set @qt_cont = 1

        set @cd_plano_financeiro_inicial = ( select top 1 cd_plano_financeiro
                                             from #Temp_Movto
                                             order by cd_plano_financeiro )

        update #Temp_PF
        set Mes1 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes2 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes3 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes4 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes5 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes6 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes7 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes8 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes9 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes10 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes11 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Mes12 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               cd_mes = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        delete #Temp_Movto where cd_plano_financeiro = @cd_plano_financeiro_inicial

      end            
            
    select *, 
		(
		 IsNull(Mes1,0) + IsNull(Mes2,0) + IsNull(Mes3,0) +
		 IsNull(Mes4,0) + IsNull(Mes5,0) + IsNull(Mes6,0) +
		 IsNull(Mes7,0) + IsNull(Mes8,0) + IsNull(Mes9,0) +
		 IsNull(Mes10,0) + IsNull(Mes11,0) + IsNull(Mes12,0) 
		) as vl_total -- Total a ser apresentado
	from #Temp_PF 
        order by cd_mascara


  end -- Fim do if

-------------------------------------------------------
if @ic_parametro = 2 -- Dá nome aos Bois.
-------------------------------------------------------
begin

  select 
    cd_mes,
    nm_mes
  from Mes
  order
    by cd_mes

       
end  

