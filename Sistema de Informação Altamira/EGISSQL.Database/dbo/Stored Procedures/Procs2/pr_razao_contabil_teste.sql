
create procedure pr_razao_contabil_teste
@ic_parametro         int,       -- Parametros Usados Nesta SProcedure; 
@ic_ordem             char(1),   -- Ordem do Relatório (C)lassificacao, 
                                 --                    (R)eduzido, 
                                 --                    (D)escricao
@ic_sem_movimento     char(1),   -- (S)im - Lista Contas Sem Movimento, (N)ao Lista  
@cd_empresa           int,       -- Empresa
@dt_inicial_exercicio datetime,  -- Data de Inicio do Relatório
@dt_final_exercicio   datetime,  -- Data Final do Relatório
@cd_conta_reduzido    int,        -- Conta Reduzida
@cd_conta_reduzido_final int = 0  -- Conta Reduzida Final
as
begin 

  -- Débito
  declare @cd_conta_debito int               -- Código da Conta (Plano)
  declare @cd_conta_ant_debito int           -- Código da Conta (Plano)

  -- Crédito
  declare @cd_conta_credito int              -- Código da Conta (Plano)
  declare @cd_conta_ant_credito int          -- Código da Conta (Plano)

  declare @cd_mascara_conta varchar(20)    -- Máscara (11.22.333.4444) (Plano)
  declare @nm_conta varchar(40)            -- Descriçao da Conta (Plano)
  declare @cd_exercicio int                -- Código do Exercicio (Movimento)
  declare @cd_lote int                     -- Código do Lote (Movimento)
  declare @cd_lancamento_contabil int      -- Código do Lançamento (Movimento)  
  declare @cd_reduzido_debito int          -- Reduzido Débito (Movimento)
  declare @cd_reduzido_credito int         -- Reduzido Crédito (Movimento)
  declare @cd_historico_contabil int       -- Código do Histórico Contábil (Movimento)
  declare @vl_lancamento_contabil float
  declare @cd_conta_pl int                 -- Código da Conta usado no #Aux_plano_conta quando escolhido listar contas sem movimento
  declare @vl_saldo_debito float           -- Variável para calcular o Saldo de Débito.
  declare @vl_saldo_credito float          -- Variável para calcular o Saldo de Crédito.

  set @cd_conta_debito        = 0
  set @cd_conta_ant_debito    = 0

  set @cd_conta_credito       = 0
  set @cd_conta_ant_credito   = 0

  set @cd_mascara_conta       = 0
  set @nm_conta               = ''
  set @cd_exercicio           = 0
  set @cd_lote                = 0
  set @cd_lancamento_contabil = 0 
  set @cd_reduzido_debito     = 0
  set @cd_reduzido_credito    = 0
  set @cd_historico_contabil  = 0
  set @vl_lancamento_contabil = 0
  set @cd_conta_pl            = 0
  

  -- Criaçao da Tabela Temporária Onde será Gerada a Pesquisa
     Print('Cria "Tabela Temporária", #Aux_Razao_Contabil')
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
      TipoSaldo char(1))

    -- Lista os lançamentos contábeis e alimenta a tabela temporária
    print('Lista os Lançamentos Contábeis e Alimenta Tabela #Aux_Razao_Contabil')      

    select
      cd_exercicio,
      cd_lote,
      cd_lancamento_contabil,
      dt_lancamento_contabil,
      cd_reduzido_debito,
      cd_reduzido_credito,
      vl_lancamento_contabil,
      cd_historico_contabil,
      ds_historico_contabil
    into
      #Aux_Movimento_contabil_unica
    from
      Movimento_contabil mc
    where
      cd_empresa = @cd_empresa and
      (dt_lancamento_contabil between @dt_inicial_exercicio and @dt_final_exercicio) and
      ( (cd_reduzido_debito = @cd_conta_reduzido  or 
         cd_reduzido_credito = @cd_conta_reduzido and 
         @cd_conta_reduzido_final = 0) or
        ( ( cd_reduzido_debito between @cd_conta_reduzido and @cd_conta_reduzido_final )  or
          ( cd_reduzido_credito between @cd_conta_reduzido and @cd_conta_reduzido_final ) and
    	  (@cd_conta_reduzido_final <> 0 ) ) or
        (@cd_conta_reduzido = 0) )
    --order by cd_reduzido_debito, cd_reduzido_credito, cd_lote, cd_lancamento_contabil
    order by cd_lote, cd_lancamento_contabil, cd_reduzido_debito, cd_reduzido_credito

--select * from #Aux_Movimento_contabil_unica

      print('Cria Tabela #Aux_Movimento_Contabil_Unica')

      while exists (select top 1 'x' from #Aux_Movimento_contabil_unica)
        begin

           Print('Existe o Movimento #Aux_Movimento_Contabil_Unica')    
          select top 1
            @cd_exercicio = cd_exercicio,
            @cd_lote = cd_lote,
            @cd_lancamento_contabil = cd_lancamento_contabil,
            @cd_reduzido_debito = cd_reduzido_debito,
            @cd_reduzido_credito = cd_reduzido_credito,
            @vl_lancamento_contabil = isnull(vl_lancamento_contabil,0)
          from
            #Aux_Movimento_contabil_unica
      --order by cd_reduzido_debito, cd_reduzido_credito, cd_lote, cd_lancamento_contabil
        order by cd_lote, cd_lancamento_contabil, cd_reduzido_debito, cd_reduzido_credito

--          order by
--            cd_lancamento_contabil

          -- Quando a conta pesquisada é débito
          if (isnull(@cd_reduzido_debito, 0) <> 0)
            begin 
               Print('É Débito - Alimenta váriaveis @cd_conta_debito, @cd_mascara_conta, @nm_conta ( Tabela Plano_conta )') 
              select
                @cd_conta_debito = cd_conta, 
                @cd_mascara_conta = cd_mascara_conta,
                @nm_conta = nm_conta
              from
                Plano_conta
              where
                cd_empresa = @cd_empresa and
                cd_conta_reduzido = @cd_reduzido_debito
 
              print('Variável @cd_reduzido_debito '+cast(@cd_reduzido_debito as Varchar))
              print('Variável @cd_conta_ant_debito '+cast(@cd_conta_ant_debito as varchar))
              print('Variável @cd_conta_debito '+cast(@cd_conta_debito as varchar))

    	      if (@cd_conta_ant_debito <> @cd_conta_debito) 
                begin

                  print('Variável @cd_conta_ant_debito = @cd_conta debito')
                  set @cd_conta_ant_debito = @cd_conta_debito
                  
--                  if not exists(select * from #Aux_Razao_Contabil
--                                where Conta = @cd_conta_debito
--                                  and Saldo <> 0
--                                  and Debito = 0
--                                  and Credito = 0)
--                    begin
--                      -- Consulta Saldo Implantação - Substituído por Paulo Santos
--  	                  select @vl_saldo_debito = case when ic_saldo_implantacao = 'D' then
--		                                             Isnull(vl_saldo_implantacao,0)
--	                                              else
--	                                               (Isnull(vl_saldo_implantacao,0) * (-1)) end                   
--	  		                from saldo_conta_implantacao 
--  	                    where cd_empresa = @cd_empresa
--			                   and cd_conta = @cd_conta_debito
			                   --and ic_saldo_implantacao = 'D' -- psantos

                     if exists(select top 1 'x' from #Aux_Razao_Contabil_Saldo
                               where conta = @cd_conta_debito)
		                     update #Aux_Razao_Contabil_Saldo
		                        set Saldo = @vl_saldo_debito
		                      where conta = @cd_conta_debito
                     else
                       insert into #Aux_Razao_Contabil_Saldo
                       values(@cd_conta_debito, @cd_reduzido_debito, @vl_saldo_debito, 'D')
			                  
                        -- Comentado por Paulo Santos devido estar pegando o Saldo Inicial Errado  
			                  --set @vl_saldo_debito = dbo.fn_saldo_contabil(@dt_inicial_exercicio, @cd_exercicio, @cd_conta_debito)
			
			                    print('@vl_saldo_debito - O Saldo Inicial Débito é ' + cast(@vl_saldo_debito as varchar));
			                  
			                insert into 
			                  #Aux_Razao_contabil
			                select 
			                    @cd_conta_debito,
			                    @cd_reduzido_debito,
			                    @cd_mascara_conta,
			                    @nm_conta,
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
			                    'Saldo Inicial'
			                  from
			                    #Aux_Movimento_contabil_unica
			                  where
			                    cd_exercicio = @cd_exercicio and
			                    cd_lote = @cd_lote and
			                    cd_lancamento_contabil = @cd_lancamento_contabil
--	                   end
--                  else
--                    begin
--                      print('Passou no else para pegar o saldo debito atualizado')
--                      select top 1 @vl_saldo_debito = Saldo from #Aux_Razao_contabil
--                      where conta = @cd_conta_debito
--                      order by id_ordem desc
--                      print('saldo debito' + cast(@vl_saldo_debito as Varchar))

--                      select @vl_saldo_debito = case when tiposaldo = 'D' then
--		                                              Isnull(saldo,0)
--	                                              else
--	                                                (Isnull(saldo,0) * (-1)) end                   
--	  		                from #Aux_Razao_contabil 
--  	                   where conta = @cd_conta_debito
--                       order by conta, id_ordem desc
--                    end
                end
                   
                select @vl_saldo_debito = Saldo from #Aux_Razao_Contabil_Saldo
                where conta = @cd_conta_debito
                        
                set @vl_saldo_debito = isnull(@vl_saldo_debito,0) + isnull(@vl_lancamento_contabil,0)
                  
                print('Valor do Lançamento Contábil - @vl_lancamento_contabil '+cast(@vl_lancamento_contabil as varchar))
                print('Saldo + Lançamento = (@vl_saldo_debito + @vl_lancamento_contabil) '+cast(@vl_saldo_debito as varchar))
                print('Insere Saldo_Inicial_Débito na Tabela #Aux_Razao_contabil')
              insert into 
                #Aux_Razao_contabil
              select
                @cd_conta_debito,
                @cd_reduzido_debito,
                @cd_mascara_conta,
                @nm_conta,
                dt_lancamento_contabil,  
                cast(isnull(cd_lote,0) as varchar(8))+'-'+cast(isnull(cd_lancamento_contabil,0) as varchar(8)),
                isnull(@cd_reduzido_credito,0),
                isnull(@vl_lancamento_contabil,0),
                0,
                case when (isnull(@vl_saldo_debito,0) < 0) then 
                  (isnull(@vl_saldo_debito,0) * (-1)) 
                else isnull(@vl_saldo_debito,0) end, 
                case when (isnull(@vl_saldo_debito,0) < 0) then 'C' else 'D' end, 
                isnull(cd_historico_contabil,0),
                ds_historico_contabil
              from
                #Aux_Movimento_contabil_unica
              where
                cd_exercicio = @cd_exercicio and
                cd_lote = @cd_lote and
                cd_lancamento_contabil = @cd_lancamento_contabil
            end 

-- ****************************************************************************


          -- Quando a Conta Pesquisada é Crédito
          if ((isnull(@cd_reduzido_credito,0) <> 0))
            begin 
                print('É Crédito')
              select
                @cd_conta_credito = cd_conta, 
                @cd_mascara_conta = cd_mascara_conta,
                @nm_conta = nm_conta
              from
                Plano_conta
              where
                cd_empresa = @cd_empresa and
                cd_conta_reduzido = @cd_reduzido_credito

              print('@cd_reduzido_credito '+cast(@cd_reduzido_credito as varchar))
              print('@cd_conta_ant_credito '+cast(@cd_conta_ant_credito as varchar))
              print('@cd_conta_credito '+cast(@cd_conta_credito as varchar))

    	      if (@cd_conta_ant_credito <> @cd_conta_credito)  
                begin
                  set @cd_conta_ant_credito = @cd_conta_credito
                  Print('Variável Conta Anterior Crédito Receber Valor da Conta Crédito')

                  if not exists(select * from #Aux_Razao_Contabil
                                where Conta = @cd_conta_credito
                                  and Saldo <> 0
                                  and Debito = 0
                                  and Credito = 0)
	                   begin
	                  
	                     -- Consulta Saldo Implantação - Substituído por Paulo Santos
	
	                     select @vl_saldo_credito = case when ic_saldo_implantacao = 'C' then
	                                              isnull(vl_saldo_implantacao,0)
	                                            else 
	                                              isnull(vl_saldo_implantacao,0) * (-1) end
	                       from saldo_conta_implantacao 
	                     where cd_empresa = @cd_empresa
	                       and cd_conta = @cd_conta_credito
	                      --and ic_saldo_implantacao = 'C' -- psantos
	                 
	                     -- Comentado por Paulo Santos devido estar pegando o Saldo Inicial Errado  
	                     --set @vl_saldo_credito = dbo.fn_saldo_contabil(@dt_inicial_exercicio, @cd_exercicio, @cd_conta_credito)
	                  
	                     print('O saldo inicial crédito é ' + cast(@vl_saldo_credito as varchar));
			                  insert into 
			                    #Aux_Razao_contabil
			                  select 
			                    @cd_conta_credito,
			                    @cd_reduzido_credito,
			                    @cd_mascara_conta,
			                    @nm_conta,
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
			                    'Saldo Inicial'
			                  from
			                    #Aux_Movimento_contabil_unica
			                  where
			                    cd_exercicio = @cd_exercicio and
			                    cd_lote = @cd_lote and
			                    cd_lancamento_contabil = @cd_lancamento_contabil
			                end
                  else
                   begin
                     print('Passou no else para pegar o saldo credito atualizado')
--                     select top 1 @vl_saldo_credito = saldo,
--                                  @ic_tipo_saldo from #Aux_Razao_contabil
--                     where conta = @cd_conta_credito
--                     order by id_ordem desc

                     select @vl_saldo_credito = case when tiposaldo = 'C' then
		                                              Isnull(saldo,0)
	                                              else
	                                                (Isnull(saldo,0) * (-1)) end                   
	  		               from #Aux_Razao_contabil 
  	                  where conta = @cd_conta_credito
                      order by conta, id_ordem desc

                     print('saldo credito' + cast(@vl_saldo_credito as Varchar))                      
                   end
               end
--                print('@vl_saldo_credito '+cast(@vl_saldo_credito as varchar))
                  
                  set @vl_saldo_credito = isnull(@vl_saldo_credito,0) + isnull(@vl_lancamento_contabil,0)

                print('@vl_lancamento_contabil '+cast(@vl_lancamento_contabil as varchar))
                print('@vl_saldo_credito + @vl_lancamento_contabil'+cast(@vl_saldo_credito as varchar))
                print('Insere Saldo')
 
              insert into 
                #Aux_Razao_contabil
              select 
                @cd_conta_credito,
                @cd_reduzido_credito,
                @cd_mascara_conta,
                @nm_conta,
                dt_lancamento_contabil,
                cast(isnull(cd_lote,0) as varchar(8))+'-'+cast(isnull(cd_lancamento_contabil,0) as varchar(8)),
                isnull(@cd_reduzido_debito,0),
                0,
                isnull(@vl_lancamento_contabil,0),
                case when (isnull(@vl_saldo_credito,0) < 0) then 
                  (@vl_saldo_credito * (-1)) 
                else @vl_saldo_credito end, 
                case when @vl_saldo_credito < 0 then 'D' else 'C' end, 
                --case when @vl_saldo_credito < 0 then 'D' else 'C' end,
                isnull(cd_historico_contabil,0),
                ds_historico_contabil
              from
                #Aux_Movimento_contabil_unica
              where
                cd_exercicio = @cd_exercicio and
                cd_lote = @cd_lote and
                cd_lancamento_contabil = @cd_lancamento_contabil
            end 
          
          -- Apaga Registro Processado
          print('Deleta Tabela #Aux_Movimento_Contabil_Unica')
          delete from 
            #Aux_Movimento_contabil_unica
          where
            cd_exercicio = @cd_exercicio and
            cd_lote = @cd_lote and
            cd_lancamento_contabil = @cd_lancamento_contabil

        end 
    end 

        
  -- Lista por Ordem de Classificaçao
  Print('Lista Razao')  
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

