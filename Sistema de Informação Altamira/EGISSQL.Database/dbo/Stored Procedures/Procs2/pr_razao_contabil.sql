
create procedure pr_razao_contabil
@ic_parametro         int,          -- Parametros Usados Nesta SProcedure; 
@ic_ordem             char(1),      -- Ordem do Relatório (C)lassificacao, 
                                    --                    (R)eduzido, 
                                    --                    (D)escricao
@ic_sem_movimento     char(1),      -- (S)im - Lista Contas Sem Movimento, (N)ao Lista  
@cd_empresa           int,          -- Empresa
@dt_inicial_exercicio datetime,     -- Data de Inicio do Relatório
@dt_final_exercicio   datetime,     -- Data Final do Relatório
@cd_conta_reduzido    int,          -- Conta Reduzida
@cd_conta_reduzido_final int = 0    -- Conta Reduzida Final
as
begin 
  -- Débito
  declare @cd_conta_debito int      -- Código da Conta (Plano)
  declare @cd_conta_ant_debito int  -- Código da Conta (Plano)
  -- Crédito
  declare @cd_conta_credito int     -- Código da Conta (Plano)
  declare @cd_conta_ant_credito int -- Código da Conta (Plano)

  declare @ic_tipo_saldo char(1)    -- Tipo de Saldo

  declare @cd_mascara_conta_debito varchar(20)   -- Máscara (11.22.333.4444) (Plano)
  declare @cd_mascara_conta_credito varchar(20)  -- Máscara (11.22.333.4444) (Plano)
  declare @nm_conta_debito varchar(40)           -- Descriçao da Conta (Plano)
  declare @nm_conta_credito varchar(40)          -- Descriçao da Conta (Plano)
  declare @cd_exercicio int                      -- Código do Exercicio (Movimento)
  declare @cd_lote int                           -- Código do Lote (Movimento)
  declare @cd_lancamento_contabil int            -- Código do Lançamento (Movimento)  
  declare @cd_reduzido_debito int                -- Reduzido Débito (Movimento)
  declare @cd_reduzido_credito int               -- Reduzido Crédito (Movimento)
  declare @cd_historico_contabil int             -- Código do Histórico Contábil (Movimento)
  declare @vl_lancamento_contabil float
  declare @cd_conta_pl int                       -- Código da Conta usado no #Aux_plano_conta quando escolhido listar contas sem movimento
  declare @vl_saldo_debito float                 -- Variável para calcular o Saldo de Débito.
  declare @vl_saldo_credito float                -- Variável para calcular o Saldo de Crédito.
  declare @dt_lancamento_contabil datetime
  declare @ds_historico_contabil varchar(8000)
  declare @ic_movimento char(1)
  declare @ic_debito_credito char(1)

  declare @qt_registro int
  declare @cd_exercicio_saldo int

  set @qt_registro = 0
  set @cd_exercicio_saldo = 0
  
  set @cd_conta_debito          = 0
  set @cd_conta_ant_debito      = 0

  set @cd_conta_credito         = 0
  set @cd_conta_ant_credito     = 0

  set @cd_mascara_conta_debito  = 0
  set @cd_mascara_conta_credito = 0
  set @nm_conta_debito          = ''
  set @nm_conta_credito         = ''
  set @cd_exercicio             = 0
  set @cd_lote                  = 0
  set @cd_lancamento_contabil   = 0 
  set @cd_reduzido_debito       = 0
  set @cd_reduzido_credito      = 0
  set @cd_historico_contabil    = 0
  set @vl_lancamento_contabil   = 0
  set @cd_conta_pl              = 0

  -- Criaçao da Tabela Temporária Onde será Gerada a Pesquisa
  create table #Aux_Razao_contabil (
    Id_Ordem int identity(1,1), 
    Conta int,
    Reduzido int,
    Classificacao varchar(20),
    Nome varchar(40),
    DataLancamento datetime,
    NumLancamento varchar(18),
    Contrapartida int,
    Debito float,
    Credito float,
    Saldo float,
    TipoSaldo char(1),
    CodHistorico int,
    Historico text )

  create table #Aux_Razao_contabil_Saldo (
    Conta int,
    Reduzido int,
    Saldo float,
    TipoSaldo char(1),
    Utilizado char(1)) 

  create table #Aux_Razao_Contabil_Saldo_Aux (
    Conta int,
    Reduzido int,
    Saldo float,
    TipoSaldo char(1))

  -- Se existir apenas um exercicio ativo trazer saldo inicial da tabela saldo_conta
  
  select @qt_registro = count(cd_exercicio) 
	  from parametro_contabil
	 where cd_empresa = @cd_empresa
     and ic_exercicio_ativo = 'S'

	if @qt_registro = 1
		begin
      Insert into #Aux_Razao_contabil_Saldo
	    select pc.cd_conta as Conta, 
             0 as Reduzido, 
             isnull(sc.vl_saldo_conta,0) as Saldo, 
             cast(isnull(ic_saldo_conta,'') as char(1)) as TipoSaldo,
             cast('N' as char(1)) as Utilizado
			  from Plano_Conta pc 
        left outer join Saldo_Conta sc 
          on pc.cd_conta = sc.cd_conta 
         and pc.cd_empresa = sc.cd_empresa 
         and sc.dt_saldo_conta = (@dt_inicial_exercicio -1)
			 where pc.cd_empresa = @cd_empresa 
		end
  else
   begin
     set @cd_exercicio_saldo = @cd_exercicio - 1 

     insert into #Aux_Razao_Contabil_Saldo_Aux
     exec pr_saldo_anterior 1, @cd_empresa, @cd_exercicio_saldo, @dt_inicial_exercicio, 0

     insert into #Aux_Razao_Contabil_Saldo
     select aux.*, 'N' from #Aux_Razao_Contabil_Saldo_Aux aux
  end
  
  -- Lista os lançamentos contábeis e alimenta a tabela temporária

  select
    mc.cd_exercicio,
    mc.cd_lote,
    mc.cd_lancamento_contabil,
    mc.dt_lancamento_contabil,
    mc.cd_reduzido_debito,
    pd.cd_conta as cd_conta_debito,
    pd.cd_mascara_conta as cd_mascara_conta_debito,
    pd.nm_conta as nm_conta_debito,
    mc.cd_reduzido_credito,
    pc.cd_conta as cd_conta_credito,
    pc.cd_mascara_conta as cd_mascara_conta_credito,
    pc.nm_conta as nm_conta_credito,
    mc.vl_lancamento_contabil,
    mc.cd_historico_contabil,
    mc.ds_historico_contabil,
    'S' as ic_movimento,
    ' ' as ic_debito_credito
  into
    #Movimento_Contabil
  from
    Movimento_contabil mc
    left outer join Plano_Conta pd 
      on pd.cd_conta_reduzido = mc.cd_reduzido_debito 
     and pd.cd_empresa = mc.cd_empresa
    left outer join Plano_Conta pc
      on pc.cd_conta_reduzido = mc.cd_reduzido_credito
     and pc.cd_empresa = mc.cd_empresa
  
  where mc.cd_empresa = @cd_empresa   
    and (mc.dt_lancamento_contabil between @dt_inicial_exercicio and @dt_final_exercicio)     
    and ( (mc.cd_reduzido_debito = @cd_conta_reduzido  or 
           mc.cd_reduzido_credito = @cd_conta_reduzido and @cd_conta_reduzido_final = 0) or
    ( ( mc.cd_reduzido_debito between @cd_conta_reduzido and @cd_conta_reduzido_final )  or
      ( mc.cd_reduzido_credito between @cd_conta_reduzido and @cd_conta_reduzido_final )     
    and (@cd_conta_reduzido_final <> 0 ) ) or (@cd_conta_reduzido = 0) )

  declare cRazao cursor for
  select * 
  from #Movimento_Contabil
  union all
  select
    0,
    0,
    0,
    sc.dt_saldo_conta,
    pc.cd_conta_reduzido,
    pc.cd_conta,
    pc.cd_mascara_conta,
    pc.nm_conta,
    0,
    0,
    '',
    '',
    sc.vl_saldo_conta,
    0,
    'Saldo Inicial',
    'N' as ic_movimento,
    sc.ic_saldo_conta as ic_debito_credito
  from saldo_conta sc, plano_conta pc 
  where sc.cd_conta = pc.cd_conta and
        pc.ic_conta_analitica = 'a' and
        pc.cd_empresa = dbo.fn_empresa() and
        sc.cd_empresa = dbo.fn_empresa() and
        sc.vl_saldo_conta > 0 and
        sc.dt_saldo_conta = @dt_inicial_exercicio -1 and
        (sc.cd_conta not in (select cd_conta_debito from #Movimento_Contabil) and
         sc.cd_conta not in (select cd_conta_credito from #Movimento_Contabil))                      
  order by 
    cd_lote, cd_lancamento_contabil, cd_reduzido_debito, cd_reduzido_credito

  open cRazao
  fetch next from cRazao into @cd_exercicio, @cd_lote, @cd_lancamento_contabil, @dt_lancamento_contabil,
                              @cd_reduzido_debito, @cd_conta_debito, @cd_mascara_conta_debito,
                              @nm_conta_debito, @cd_reduzido_credito, @cd_conta_credito,
                              @cd_mascara_conta_credito, @nm_conta_credito, @vl_lancamento_contabil,
                              @cd_historico_contabil, @ds_historico_contabil, @ic_movimento, @ic_debito_credito


  while (@@FETCH_STATUS = 0)
  begin
    -- Quando a Conta Não Tem Movimento
    if (@ic_movimento = 'N')
	    begin
	      insert into 
		      #aux_razao_contabil
	      values (
		      @cd_conta_debito,
		      @cd_reduzido_debito,
		      @cd_mascara_conta_debito,
		      @nm_conta_debito,
		      @dt_inicial_exercicio,  
		      0,
		      0,
		      0,
		      0,
		      @vl_lancamento_contabil, 
		      @ic_debito_credito, 
		      0,
		      @ds_historico_contabil )
	    end
    else
    begin
	    -- Quando a conta pesquisada é débito
	
	    if (isnull(@cd_reduzido_debito, 0) <> 0)
	    begin 
	      if (@cd_conta_ant_debito <> @cd_conta_debito) 
	      begin
	        set @cd_conta_ant_debito = @cd_conta_debito

	        if not exists(select top 1 'x' from #Aux_Razao_Contabil_Saldo
	                      where conta = @cd_conta_debito)                  
		        begin
	            -- Consulta Saldo Implantação - Substituído por Paulo Santos
		          if exists(select top 1 'X' from Saldo_Conta_Implantacao 
		                    where cd_empresa = @cd_empresa and 
		                          cd_conta = @cd_conta_debito)
			          begin
			            select            
			              @ic_tipo_saldo = ic_saldo_implantacao,
			              @vl_saldo_debito = case when isnull(ic_saldo_implantacao,'D') = 'D' then
			                                   Isnull(vl_saldo_implantacao,0)
			                                 else
			                                   (Isnull(vl_saldo_implantacao,0) * (-1)) end                   
			            from 
			              Saldo_Conta_Implantacao
			            where 
			              cd_empresa = @cd_empresa and 
			              cd_conta = @cd_conta_debito
		
	  	          end
	           else
		           begin
			           set @ic_tipo_saldo = 'D'
			           set @vl_saldo_debito = 0              
	             end 
	
	          insert into 
	            #Aux_Razao_Contabil_Saldo
	          values
	            (@cd_conta_debito, @cd_reduzido_debito, @vl_saldo_debito, @ic_tipo_saldo, 'N')
	
	          insert into 
				      #Aux_Razao_contabil
	          values (
				      @cd_conta_debito,
				      @cd_reduzido_debito,
				      @cd_mascara_conta_debito,
				      @nm_conta_debito,
				      @dt_inicial_exercicio,  
				      0,
				      0,
				      0,
				      0,
				      case when (isnull(@vl_saldo_debito,0) < 0) then 
				        (isnull(@vl_saldo_debito,0) * (-1)) 
				      else isnull(@vl_saldo_debito,0) end, 
				      case when (isnull(@vl_saldo_debito,0) < 0) then 'C' else 'D' end, 
				      0,
				      'Saldo Inicial' )
	
	        end
	        else
		        begin
              if ((select Utilizado from #Aux_Razao_Contabil_Saldo
                  where Conta = @cd_conta_debito) = 'N')
              begin
	
		          select 
		            @ic_tipo_saldo = TipoSaldo,
		            @vl_saldo_debito = case when Tiposaldo = 'D' then
			 	                            Isnull(Saldo,0)
			                             else
			                              (Isnull(Saldo,0) * (-1)) end                   
			  	 	  from 
		            #Aux_Razao_Contabil_Saldo
		 	        where 
		            Conta = @cd_conta_debito
	
		          insert into 
					      #Aux_Razao_contabil
	            values (
					      @cd_conta_debito,
					      @cd_reduzido_debito,
					      @cd_mascara_conta_debito,
					      @nm_conta_debito,
					      @dt_inicial_exercicio,  
					      0,
					      0,
					      0,
					      0,
					      case when (isnull(@vl_saldo_debito,0) < 0) then 
					        (isnull(@vl_saldo_debito,0) * (-1)) 
					      else isnull(@vl_saldo_debito,0) end, 
					      case when (isnull(@vl_saldo_debito,0) < 0) then 'C' else 'D' end, 
					      0,
					      'Saldo Inicial' )

              update #Aux_Razao_Contabil_Saldo
              set Utilizado = 'S'
              where Conta = @cd_conta_debito 

              end
             else
	           begin
    	          select 
				            @ic_tipo_saldo = TipoSaldo,
				            @vl_saldo_debito = case when Tiposaldo = 'D' then
					 	                            Isnull(Saldo,0)
					                             else
					                              (Isnull(Saldo,0) * (-1)) end                   
					  	 	  from 
				            #Aux_Razao_Contabil_Saldo
				 	        where 
				            Conta = @cd_conta_debito
             end 

		        end
	      end
	                                           
	      set @vl_saldo_debito = isnull(@vl_saldo_debito,0) + isnull(@vl_lancamento_contabil,0)
        
	      insert into 
	        #Aux_Razao_contabil
	      values (
	        @cd_conta_debito,
	        @cd_reduzido_debito,
	        @cd_mascara_conta_debito,
	        @nm_conta_debito,
	        @dt_lancamento_contabil,  
	        cast(isnull(@cd_lote,0) as varchar(8))+'-'+cast(isnull(@cd_lancamento_contabil,0) as varchar(8)),
	        isnull(@cd_reduzido_credito,0),
	        isnull(@vl_lancamento_contabil,0),
	        0,
	        case when (isnull(@vl_saldo_debito,0) < 0) then 
	          (isnull(@vl_saldo_debito,0) * (-1)) 
	        else isnull(@vl_saldo_debito,0) end, 
	        case when (isnull(@vl_saldo_debito,0) < 0) then 'C' else 'D' end, 
	          isnull(@cd_historico_contabil,0),
	        @ds_historico_contabil )

	      update 
	        #Aux_Razao_Contabil_Saldo
	      set 
	        Saldo = case when (isnull(@vl_saldo_debito,0) < 0) then 
	                  (isnull(@vl_saldo_debito,0) * (-1)) 
	                else isnull(@vl_saldo_debito,0) end,
	        TipoSaldo = case when (isnull(@vl_saldo_debito,0) < 0) then 'C' else 'D' end
	      where
	        Conta = @cd_conta_debito

	    end  -- DÉBITO
	
	    -- Quando a Conta Pesquisada é Crédito
	    if ((isnull(@cd_reduzido_credito,0) <> 0))
	    begin 
	    	if (@cd_conta_ant_credito <> @cd_conta_credito)  
	      begin
	        set @cd_conta_ant_credito = @cd_conta_credito
	

	        if not exists(select top 1 'x' from #Aux_Razao_Contabil_Saldo
	                      where conta = @cd_conta_credito)                  
	        begin
	          -- Consulta Saldo Implantação - Substituído por Paulo Santos
	          if exists(select top 1 'X' from Saldo_Conta_Implantacao 
	                    where cd_empresa = @cd_empresa and 
	                          cd_conta = @cd_conta_credito)
	          begin
	            select 
	              @ic_tipo_saldo = ic_saldo_implantacao,
	              @vl_saldo_credito = case when isnull(ic_saldo_implantacao,'C') = 'C' then
	                                    Isnull(vl_saldo_implantacao,0)
	                                  else
	                                    (Isnull(vl_saldo_implantacao,0) * (-1)) end                   
	            from 
	              Saldo_Conta_Implantacao 
	            where 
	              cd_empresa = @cd_empresa and 
	              cd_conta = @cd_conta_credito
	          end
	          else
	          begin
	            set @ic_tipo_saldo = 'D'
	            set @vl_saldo_credito = 0 
	          end
	 
	          insert into 
	            #Aux_Razao_Contabil_Saldo
	          values
	            (@cd_conta_credito, @cd_reduzido_credito, @vl_saldo_credito, @ic_tipo_saldo, 'N')
	
				    insert into 
				      #Aux_Razao_contabil
				    values (
				      @cd_conta_credito,
				      @cd_reduzido_credito,
				      @cd_mascara_conta_credito,
				      @nm_conta_credito,
				      @dt_inicial_exercicio,  
				      0,
				      0,
				      0,
				      0,
				      case when (isnull(@vl_saldo_credito,0) < 0) then 
				        (isnull(@vl_saldo_credito,0) * (-1)) 
				      else isnull(@vl_saldo_credito,0) end, 
				      case when (isnull(@vl_saldo_credito,0) < 0) then 'D' else 'C' end, 
				      0,
				      'Saldo Inicial' )

	  	    end
	        else
	        begin

            if ((select Utilizado from #Aux_Razao_Contabil_Saldo
                where Conta = @cd_conta_credito) = 'N')
            begin
            
	          select 
	            @ic_tipo_saldo = TipoSaldo,
	            @vl_saldo_credito = case when Tiposaldo = 'C' then
		 	                            Isnull(Saldo,0)
		                             else
		                              (Isnull(Saldo,0) * (-1)) end                   
		  	 	  from 
	            #Aux_Razao_Contabil_Saldo
	 	        where 
	            Conta = @cd_conta_credito

	          insert into 
				      #Aux_Razao_contabil
				    values (
				      @cd_conta_credito,
				      @cd_reduzido_credito,
				      @cd_mascara_conta_credito,
				      @nm_conta_credito,
				      @dt_inicial_exercicio,  
				      0,
				      0,
				      0,
				      0,
				      case when (isnull(@vl_saldo_credito,0) < 0) then 
				        (isnull(@vl_saldo_credito,0) * (-1)) 
				      else isnull(@vl_saldo_credito,0) end, 
				      case when (isnull(@vl_saldo_credito,0) < 0) then 'D' else 'C' end, 
				      0,
				      'Saldo Inicial' )

            update #Aux_Razao_Contabil_Saldo
            set Utilizado = 'S'
            where Conta = @cd_conta_credito 
         
            end
            else
            begin
              select
 	            @ic_tipo_saldo = TipoSaldo,
	            @vl_saldo_credito = case when Tiposaldo = 'C' then
		 	                            Isnull(Saldo,0)
		                             else
		                              (Isnull(Saldo,0) * (-1)) end                   
  		  	 	  from 
	              #Aux_Razao_Contabil_Saldo
	  	        where 
	              Conta = @cd_conta_credito

            end
	
	        end
	      end
	
	      set @vl_saldo_credito = isnull(@vl_saldo_credito,0) + isnull(@vl_lancamento_contabil,0)
	 
	      insert into 
	        #Aux_Razao_contabil
	      values (
	        @cd_conta_credito,
	        @cd_reduzido_credito,
	        @cd_mascara_conta_credito,
	        @nm_conta_credito,
	        @dt_lancamento_contabil,
	        cast(isnull(@cd_lote,0) as varchar(8))+'-'+cast(isnull(@cd_lancamento_contabil,0) as varchar(8)),
	        isnull(@cd_reduzido_debito,0),
	        0,
	        isnull(@vl_lancamento_contabil,0),
	        case when (isnull(@vl_saldo_credito,0) < 0) then 
	          (@vl_saldo_credito * (-1)) 
	        else @vl_saldo_credito end, 
	        case when @vl_saldo_credito < 0 then 'D' else 'C' end, 
	        isnull(@cd_historico_contabil,0),
	        @ds_historico_contabil )

	      update 
	        #Aux_Razao_Contabil_Saldo
	      set 
	        Saldo = case when (isnull(@vl_saldo_credito,0) < 0) then 
	                  (@vl_saldo_credito * (-1)) 
	                else @vl_saldo_credito end,
	        TipoSaldo = case when @vl_saldo_credito < 0 then 'D' else 'C' end
	      where
	        Conta = @cd_conta_credito
	
	    end -- CRÉDITO

    end -- COM MOVIMENTO    

    fetch next from cRazao into @cd_exercicio, @cd_lote, @cd_lancamento_contabil, @dt_lancamento_contabil,
                                @cd_reduzido_debito, @cd_conta_debito, @cd_mascara_conta_debito,
                                @nm_conta_debito, @cd_reduzido_credito, @cd_conta_credito,
                                @cd_mascara_conta_credito, @nm_conta_credito, @vl_lancamento_contabil,
                                @cd_historico_contabil, @ds_historico_contabil, @ic_movimento, @ic_debito_credito
          
  end 

  close cRazao
  deallocate cRazao
        
  -- Lista por Ordem de Classificaçao
  if @ic_ordem = 'C' 
    select
      Id_Ordem,
      Conta,
      Reduzido,
      Classificacao,
      Nome,
      DataLancamento,
      NumLancamento,
      Contrapartida,
      Debito,
      Credito,
      Abs(Saldo) as 'Saldo',
      TipoSaldo,
      CodHistorico,
      Historico                                                                                                                                                                                                                                                            
    from
      #Aux_Razao_Contabil
    where
        ( (Reduzido = @cd_conta_reduzido and 
           @cd_conta_reduzido_final = 0) or
          ( ( Reduzido between @cd_conta_reduzido and @cd_conta_reduzido_final ) and
	  (@cd_conta_reduzido_final <> 0 ) ) or
          (@cd_conta_reduzido = 0) )

    order by
       Classificacao,
       DataLancamento, 
       NumLancamento
 
  -- Lista por Ordem de Descriçao
  if @ic_ordem = 'D'
    select
      Conta,
      Reduzido,
      Classificacao,
      Nome,
      DataLancamento,
      NumLancamento,
      Contrapartida,
      Debito,
      Credito,
      Abs(Saldo) as 'Saldo',
      TipoSaldo,
      CodHistorico,
      Historico                                                                                                                                                                                                                                                            
    from
      #Aux_Razao_Contabil
    where
        ( (Reduzido = @cd_conta_reduzido and 
           @cd_conta_reduzido_final = 0) or
          ( ( Reduzido between @cd_conta_reduzido and @cd_conta_reduzido_final ) and
	  (@cd_conta_reduzido_final <> 0 ) ) or
          (@cd_conta_reduzido = 0) )

     order by
       Nome,
       DataLancamento,
       NumLancamento

  -- Lista por Ordem de Reduzido
  if @ic_ordem = 'R'
    select
      Conta,
      Reduzido,
      Classificacao,
      Nome,
      DataLancamento,
      NumLancamento,
      Contrapartida,
      Debito,
      Credito,
      Abs(Saldo) as 'Saldo',
      TipoSaldo,
      CodHistorico,
      Historico                                                                                                                                                                                                                                                            
    from
      #Aux_Razao_Contabil
    where
        ( (Reduzido = @cd_conta_reduzido and 
           @cd_conta_reduzido_final = 0) or
          ( ( Reduzido between @cd_conta_reduzido and @cd_conta_reduzido_final ) and
	  (@cd_conta_reduzido_final <> 0 ) ) or
          (@cd_conta_reduzido = 0) )
     order by
       Reduzido,
       DataLancamento,
       NumLancamento

  /* Ordem Utilizada só para o agrupamento no relatório QUICKREPORT */
  if @ic_ordem = 'Q' 
    select
      Conta,
      Reduzido,
      Classificacao,
      Nome,
      DataLancamento,
      NumLancamento,
      Contrapartida,
      Debito,
      Credito,
      Abs(Saldo) as 'Saldo',
      TipoSaldo,
      CodHistorico,
      Historico                                                                                                                                                                                                                                                            
    from
      #Aux_Razao_Contabil
    where
        ( (Reduzido = @cd_conta_reduzido and 
           @cd_conta_reduzido_final = 0) or
          ( ( Reduzido between @cd_conta_reduzido and @cd_conta_reduzido_final ) and
	  (@cd_conta_reduzido_final <> 0 ) ) or
          (@cd_conta_reduzido = 0) )

     order by
       Classificacao,
       DataLancamento, 
       NumLancamento

  
  -- Exclui tabela temporária                 
  drop table #Aux_Razao_contabil

end
