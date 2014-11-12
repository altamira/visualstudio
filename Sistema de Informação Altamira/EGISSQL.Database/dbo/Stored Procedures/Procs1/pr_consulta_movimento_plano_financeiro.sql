
CREATE PROCEDURE pr_consulta_movimento_plano_financeiro
@ic_parametro             int, 
@cd_plano_financeiro      int,
@cd_tipo_lancamento_fluxo int,
@dt_inicial               datetime,
@dt_final                 datetime

AS

declare @cd_empresa int

set @cd_empresa = dbo.fn_empresa()

  exec pr_atualiza_fluxo_caixa 
      @cd_empresa, 
      @cd_tipo_lancamento_fluxo, 
      @dt_inicial,
      @dt_final

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Movimentos do Plano Financeiro
-------------------------------------------------------------------------------
  begin

    declare @qt_cont                     int
    declare @cd_plano_financeiro_inicial int


    -- Fazendo os primeiros Selects para pegar o nome e a quantidade de semanas possíveis.
    --select * from plano_financeiro

    select
      tof.nm_tipo_operacao as cd_mascara,
      gf.nm_grupo_financeiro,
      pf.cd_plano_financeiro,
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      cast(Null as Float) as 'Semanas1',
      cast(Null as Float) as 'Semanas2',
      cast(Null as Float) as 'Semanas3',
      cast(Null as Float) as 'Semanas4',
      cast(Null as Float) as 'Semanas5',
      cast(Null as Float) as 'Semanas6',
      cast(Null as Float) as 'Semanas7',
      cast(Null as Float) as 'Semanas8',
      cast(Null as Float) as 'Semanas9',
      cast(Null as Float) as 'Semanas10',
      cast(Null as Float) as 'Semanas11',
      cast(Null as Float) as 'Semanas12',
      cast(Null as Float) as 'Semanas13'
    into
     #Temp_PF
    from
      Plano_Financeiro pf left outer join
      Grupo_Financeiro gf on gf.cd_grupo_financeiro = pf.cd_grupo_financeiro left outer join
      Tipo_Operacao_Financeira tof on tof.cd_tipo_operacao = gf.cd_tipo_operacao
    where
      ( pf.cd_plano_financeiro = @cd_plano_financeiro ) or 
      ( @cd_plano_financeiro = 0 )

    create table #Temp_Movto
      (cd_plano_financeiro int,
       dt_movto_inicial_plano datetime,
       vl_plano_financeiro float,
       cd_tipo_operacao int)

    -- Fazendo somatória dos dias agrupados por plano e pelo dia do movimento.
    insert into #Temp_Movto
      select pfm.cd_plano_financeiro,
             pfm.dt_movto_plano_financeiro as 'dt_movto_inicial_plano',
             sum(pfm.vl_plano_financeiro) as 'vl_plano_financeiro',
             tof.cd_tipo_operacao
      from Plano_Financeiro_Movimento pfm with (nolock) inner join
           Plano_Financeiro pf on pf.cd_plano_financeiro = pfm.cd_plano_financeiro left outer join
           Grupo_Financeiro gf on gf.cd_grupo_financeiro = pf.cd_grupo_financeiro  left outer join
           tipo_operacao_financeira tof on tof.cd_tipo_operacao = gf.cd_tipo_operacao
      where pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
           ( ( pfm.cd_plano_financeiro = @cd_plano_financeiro ) or
           ( @cd_plano_financeiro = 0 ) ) and
           pfm.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo
      group by pfm.cd_plano_financeiro, pfm.dt_movto_plano_financeiro, tof.cd_tipo_operacao
        
    -- Fazendo Updates para cada semana, ordenando por plano financeiro.
    -- Ou seja, vou atualizar um plano financeiro por vez e uma Semana por vez,
    -- até acabar todos os movimentos da tabela Temporária.
    while exists ( select top 1 cd_plano_financeiro
                   from #Temp_Movto
                  order by cd_plano_financeiro ) 
      begin
  
        set @qt_cont = Datepart(ww, @dt_inicial)

        set @cd_plano_financeiro_inicial = ( select top 1 cd_plano_financeiro
                                             from #Temp_Movto
                                             order by cd_plano_financeiro )
        update #Temp_PF
        set Semanas1 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )

                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)
        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas2 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas3 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas4 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas5 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas6 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas7 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas8 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas9 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas10 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas11 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas12 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        set @qt_cont = @qt_cont + 1

        update #Temp_PF
        set Semanas13 = ( select ( case when cd_tipo_operacao = 2 then
                                    sum(vl_plano_financeiro) 
                                  else 
                                    sum(vl_plano_financeiro) * -1 end )
                         from #Temp_Movto 
                         where cd_plano_financeiro = @cd_plano_financeiro_inicial and
                               Datepart(ww, dt_movto_inicial_plano) = @qt_cont
                         group by cd_tipo_operacao)

        where
          cd_plano_financeiro = @cd_plano_financeiro_inicial

        delete #Temp_Movto where cd_plano_financeiro = @cd_plano_financeiro_inicial

      end            
            
    select *, 
		(
		 IsNull(Semanas1,0) + IsNull(Semanas2,0) + IsNull(Semanas3,0) +
		 IsNull(Semanas4,0) + IsNull(Semanas5,0) + IsNull(Semanas6,0) +
		 IsNull(Semanas7,0) + IsNull(Semanas8,0) + IsNull(Semanas9,0) +
		 IsNull(Semanas10,0) + IsNull(Semanas11,0) + IsNull(Semanas12,0) 
		) as vl_total -- Total a ser apresentado
	from #Temp_PF 
        order by cd_mascara


  end -- Fim do if

-------------------------------------------------------
if @ic_parametro = 2 -- Dá nome aos Bois.
-------------------------------------------------------
begin
  declare @dt_inicial_var datetime
  declare @dt_final_var datetime
  declare @qt_semana_final int
  declare @cd_indice int

  create table #Temp
    ( Indice int,
      Semana int,
      Dia varchar(100),
      DiaInicial datetime,
      DiaFinal Datetime )

  set @qt_semana_final = ( DatePart(ww,@dt_final) )
  set @dt_inicial_var = @dt_inicial
  set @cd_indice = 1

  while DatePart(ww,@dt_final) <> DatePart(ww,@dt_inicial)
    begin
      while DatePart(ww,@dt_inicial) = DatePart(ww,@dt_inicial_var)
        begin
          insert into #Temp
           ( Indice,
             Semana,
             Dia, 
             DiaInicial,
             DiaFinal )
          values
           ( @cd_indice,
             ( DatePart(ww,@dt_inicial) ) ,
             ( ( case when Day(@dt_inicial) < 10 then 
	  	     '0' + cast( Day(@dt_inicial) as varchar(2) ) 
      	         else cast( Day(@dt_inicial) as varchar(2)) end ) + '/' + 
  	     ( case when Month(@dt_inicial) < 10 then
	             '0' + cast( Month(@dt_inicial) as varchar(2)) 
	         else cast( Month(@dt_inicial) as varchar(2)) end ) + '/' + 
    	     cast( year(@dt_inicial) as varchar(4) ) + 
              ' A ' +
               ( case when Day(@dt_inicial_var) < 10 then 
	    	 '0' + cast( Day(@dt_inicial_var) as varchar(2) ) 
	         else cast( Day(@dt_inicial_var) as varchar(2)) end ) + '/' + 
  	     ( case when Month(@dt_inicial_var) < 10 then
	             '0' + cast( Month(@dt_inicial_var) as varchar(2)) 
	         else cast( Month(@dt_inicial_var) as varchar(2)) end ) + '/' + 
    	   cast( year(@dt_inicial_var) as varchar(4) ) ),
           @dt_inicial,
           @dt_inicial_var
           )
          set @dt_inicial_var = @dt_inicial_var + 1
          set @cd_indice = @cd_indice + 1
        end
      set @dt_inicial = @dt_inicial_var
      set @cd_indice = 1
    end

    set @cd_indice = 1

    while @qt_semana_final = DatePart(ww,@dt_inicial_var)
      begin
        insert into #Temp
         ( Indice,
           Semana,
           Dia,
           DiaInicial,
           DiaFinal )
        values
         ( @cd_indice,
           ( DatePart(ww,@dt_inicial) ) ,
           ( ( case when Day(@dt_inicial) < 10 then 
 	       '0' + cast( Day(@dt_inicial) as varchar(2) ) 
               else cast( Day(@dt_inicial) as varchar(2)) end ) + '/' + 
  	     ( case when Month(@dt_inicial) < 10 then
                   '0' + cast( Month(@dt_inicial) as varchar(2)) 
	       else cast( Month(@dt_inicial) as varchar(2)) end ) + '/' + 
                 cast( year(@dt_inicial) as varchar(4) ) + 
                 ' A ' +
             ( case when Day(@dt_inicial_var) < 10 then 
	  	 '0' + cast( Day(@dt_inicial_var) as varchar(2) ) 
	         else cast( Day(@dt_inicial_var) as varchar(2)) end ) + '/' + 
  	     ( case when Month(@dt_inicial_var) < 10 then
	         '0' + cast( Month(@dt_inicial_var) as varchar(2)) 
	       else cast( Month(@dt_inicial_var) as varchar(2)) end ) + '/' + 
    	           cast( year(@dt_inicial_var) as varchar(4) ) ),
             @dt_inicial,
             @dt_inicial_var
             )
         set @dt_inicial_var = @dt_inicial_var + 1
         set @cd_indice = @cd_indice + 1
       end


  select max(Indice) as 'Codigo', Semana 
  into #Selecao
  from #Temp 
  group by Semana 
  order by Semana

  select distinct 
    t.Semana, 
    t.Dia,
    t.DiaInicial,
    t.DiaFinal
  from #Temp t inner join
       #Selecao s on s.Codigo = t.Indice and
                     s.Semana = t.Semana
  order by
    t.Semana
       
end  

