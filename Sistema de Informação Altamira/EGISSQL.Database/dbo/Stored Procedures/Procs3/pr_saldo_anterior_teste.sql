

/****** Object:  Stored Procedure dbo.pr_saldo_anterior_teste    Script Date: 13/12/2002 15:08:42 ******/
--pr_saldo_anterior
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Elias Pereira da Silva
--Cálculo do Saldo Anterior das Contas
--Data         : 06.07.2001
--Atualizado   : 25.07.2001 - Inclusao de saldos de implantaçao quando nao encontrados
--                            valores na tabela saldo_conta - elias
--               30.08.2001 - Atualizaçao das contas título - Elias
-----------------------------------------------------------------------------------
create procedure pr_saldo_anterior_teste
@ic_parametro      int,
@cd_empresa        int,
@cd_exercicio      int,
@dt_base_saldo     datetime,
@cd_conta_reduzido int
as
begin
  declare @cd_lote                int
  declare @cd_lancamento_contabil int
  declare @ic_lancamento_contabil char(1)
  declare @vl_lancamento_contabil float
  declare @cd_conta               int
  declare @vl_saldo_conta         float
  declare @ic_saldo_conta         char(1)
  declare @dt_saldo_conta         datetime
  declare @cd_mascara_conta       varchar(20)
  declare @cd_movimento           int
 
  set @cd_lote                = 0
  set @cd_lancamento_contabil = 0 
  set @ic_lancamento_contabil = ''
  set @vl_lancamento_contabil = 0
  set @cd_conta               = 0
  set @vl_saldo_conta         = 0
  set @ic_saldo_conta         = ''  
  set @dt_saldo_conta         = 0
  set @cd_mascara_conta       = ''
  set @cd_movimento           = 0
  -- Data do Saldo da Conta   
  set @dt_saldo_conta = isnull((select 
                                  dt_saldo_conta 
                                from
                                  Saldo_conta
                                where
                                  cd_empresa = @cd_empresa and
                                  dt_saldo_conta = (select 
                                                      max(dt_saldo_conta) 
                                                    from
                                                      Saldo_conta
                                                    where cd_empresa = @cd_empresa and
                                                          dt_saldo_conta between '01/01/1900' and @dt_base_saldo)),'01/01/1900')
  --print(convert (char(10), @dt_saldo_conta, 101))
  -----------------------------------------------------------------------------
  if @ic_parametro = 1   -- Totas as Contas
  -----------------------------------------------------------------------------
    begin
      -- carrega a tabela temporária com os saldos de encerramento
      select
        p.cd_conta,
        isnull(s.vl_saldo_conta, 0) as 'vl_saldo_conta',
        isnull(s.ic_saldo_conta,'') as 'ic_saldo_conta'
      into 
        #SaldoConta
      from
        Plano_conta p left outer join Saldo_conta s on s.cd_conta = p.cd_conta and s.dt_saldo_conta = @dt_saldo_conta
      where
        p.cd_empresa     = @cd_empresa
      --print('Saldo de Encerramento')
      --select * from #SaldoConta order by cd_conta
      -- se nao existir saldo de encerramento, carregar com saldos de implantaçao
      if not exists(select * from 
                      #SaldoConta 
                    where
                      vl_saldo_conta <> 0)
        begin
          update 
            #SaldoConta
          set
            cd_conta = i.cd_conta,
            vl_saldo_conta = i.vl_saldo_implantacao,
            ic_saldo_conta = i.ic_saldo_implantacao
          from
            #SaldoConta e left outer join Saldo_conta_implantacao i on e.cd_conta = i.cd_conta
          where
            cd_empresa = @cd_empresa
      
          --print('Saldo de Implantaçao')
          --select * from #SaldoConta order by cd_conta
        end
      -- acerto da data inicial para trazer os movimentos após o saldo inicial
      set @dt_saldo_conta = @dt_saldo_conta + 1
      -- criando tabela temporária com os movimentos do período (Débito)
      select
        identity(int, 0, 2)            as 'cd_movimento',
        m.cd_lote,
        m.cd_lancamento_contabil,
        m.cd_reduzido_debito           as 'cd_conta_reduzido',
        m.vl_lancamento_contabil,
        'D'                            as 'ic_lancamento_contabil'
      into
        #MovimentoContabilDebito
      from
        Movimento_Contabil m, Lote_Contabil l
      where
        l.cd_empresa    = @cd_empresa                        and
        l.cd_exercicio  = @cd_exercicio                      and
        m.cd_empresa    = @cd_empresa                        and
        m.cd_exercicio  = @cd_exercicio                      and
        l.cd_lote       = m.cd_lote                          and
        l.ic_ativa_lote = 'S'                                and
        m.dt_lancamento_contabil between @dt_saldo_conta     and 
                                         @dt_base_saldo      and
        isnull(m.cd_reduzido_debito,0) <> 0
      --print('Movimentos Contábeis a Débito')
      --select * from #MovimentoContabilDebito order by cd_conta_reduzido
      -- criando tabela temporária com os movimentos do período (Crédito)
      select
        identity(int, 1, 2)             as 'cd_movimento',
        m.cd_lote,
        m.cd_lancamento_contabil,
        m.cd_reduzido_credito           as 'cd_conta_reduzido',
        m.vl_lancamento_contabil,
        'C'                             as 'ic_lancamento_contabil'
      into
        #MovimentoContabilCredito
      from
        Movimento_contabil m, Lote_Contabil l
      where
        l.cd_empresa    = @cd_empresa                    and
        l.cd_exercicio  = @cd_exercicio                  and
        m.cd_empresa    = @cd_empresa                    and
        m.cd_exercicio  = @cd_exercicio                  and
        l.cd_lote       = m.cd_lote                      and
        l.ic_ativa_lote = 'S'                            and
        m.dt_lancamento_contabil between @dt_saldo_conta and 
                                          @dt_base_saldo and
        isnull(m.cd_reduzido_credito,0) <> 0
      --print('Movimento Contábil a Crédito')
      --select * from #MovimentoContabilCredito order by cd_conta_reduzido
      -- criando tabela temporária com a uniao das tabelas de débito e crédito 
      select * into
        #MovimentoContabil
      from 
        #MovimentoContabilDebito
      union all select * from
        #MovimentoContabilCredito
      --print('Movimento Contábil')
      --select * from #MovimentoContabil order by cd_conta_reduzido
    
      -- Lê a tabela de Movimento contabil e alimenta a de Saldo da Conta
      while exists(select * from #MovimentoContabil)
        begin
      
          select 
            @cd_movimento           = cd_movimento, 
            @cd_lancamento_contabil = cd_lancamento_contabil,
            @cd_conta_reduzido      = cd_conta_reduzido,
            @ic_lancamento_contabil = ic_lancamento_contabil,
            @vl_lancamento_contabil = vl_lancamento_contabil
          from
            #MovimentoContabil
          -- encontra a conta através do código reduzido
          set @cd_conta = (select 
                             cd_conta 
                           from 
                             Plano_conta 
                           where 
                             cd_empresa = @cd_empresa and 
                             cd_conta_reduzido = @cd_conta_reduzido)
          AtualizaValor:
            begin
              --print('Processando Movimento: '+cast(@cd_movimento as varchar(9)))
              --print('            Conta: '+cast(@cd_conta as varchar(9)))
              --print('            Reduzido: '+cast(@cd_conta_reduzido as varchar(9)))
              --print('            Valor: '+cast(@vl_lancamento_contabil as varchar(20)))
              -- Débito
              if (@ic_lancamento_contabil = 'D')
                begin
    
                  --print('É Débito')                  
 
                  -- Conta sem saldo  
                  if ((select ic_saldo_conta from #SaldoConta where cd_conta = @cd_conta) = '')
                    begin
                      --print('Conta sem Saldo')
                      update
                        #SaldoConta
                      set
                        vl_saldo_conta = @vl_lancamento_contabil,
                        ic_saldo_conta = 'D'
                      where
                        cd_conta = @cd_conta
                    end
                  else 
                    -- Conta com Saldo Devedor
                    if ((select ic_saldo_conta from #SaldoConta where cd_conta = @cd_conta) = 'D')
                      begin
                        --print('Conta com Saldo Devedor')
    
                        update
                          #SaldoConta
                        set
                          vl_saldo_conta = vl_saldo_conta + @vl_lancamento_contabil,
                          ic_saldo_conta = 'D'
                        where
                          cd_conta = @cd_conta
 
                      end
                    else
  
                      -- Conta com Saldo Credor (se o saldo depois de calculado ficar negativo
                      -- torna-o positivo e troca-se o sinal
                      begin
                        --print('Conta com Saldo Credor')
                        set @ic_saldo_conta = 'C'
                        set @vl_saldo_conta = 0
                        set @vl_saldo_conta = (select vl_saldo_conta from #SaldoConta where cd_conta = @cd_conta) - @vl_lancamento_contabil
                     
                        if @vl_saldo_conta < 0
                          begin
                            print('Saldo negativo acertado') 
                            set @vl_saldo_conta = @vl_saldo_conta * (-1)
                            set @ic_saldo_conta = 'D'
                          end
                      
                        update
                          #SaldoConta
                        set
                          vl_saldo_conta = @vl_saldo_conta,
                          ic_saldo_conta = @ic_saldo_conta
                        where
                          cd_conta = @cd_conta
                      
                      end  
                end
              -- Crédito    
              if (@ic_lancamento_contabil = 'C')
                begin
              
                  --print('É Crédito')
             
                  -- Saldo Zerado
                  if ((select ic_saldo_conta from #SaldoConta where cd_conta = @cd_conta) = '')
                    begin
                      --print('Saldo Zerado')
 
                      update
                        #SaldoConta
                      set
                        vl_saldo_conta = @vl_lancamento_contabil,
                        ic_saldo_conta = 'C'
                      where
                        cd_conta = @cd_conta
                    end
                  else
                    -- Saldo Credor
                    if ((select ic_saldo_conta from #SaldoConta where cd_conta = @cd_conta) = 'C')
                      begin
                        --print('Saldo Credor')
                        update
                          #SaldoConta
                        set
                          vl_saldo_conta = vl_saldo_conta + @vl_lancamento_contabil,
                          ic_saldo_conta = 'C'
                        where
                          cd_conta = @cd_conta
                      end
                    else
                      begin
                        --print('Saldo Devedor')
                        set @ic_saldo_conta = 'D'
                        set @vl_saldo_conta = 0
                        set @vl_saldo_conta = (select vl_saldo_conta from #SaldoConta where cd_conta = @cd_conta) - @vl_lancamento_contabil
                     
                        if @vl_saldo_conta < 0
                          begin
                            --print('Saldo Negativo Acertado')
                            set @vl_saldo_conta = @vl_saldo_conta * (-1)
                            set @ic_saldo_conta = 'C'
                          end
                      
                        update
                          #SaldoConta
                        set
                          vl_saldo_conta = @vl_saldo_conta,
                          ic_saldo_conta = @ic_saldo_conta
                        where
                          cd_conta = @cd_conta
                      
                      end  
                end
              goto EncontraContaPai
            end
          EncontraContaPai:
            begin
              declare @cd_contador int
              set     @cd_contador = 0
              -- pesquisa a máscara no plano de contas
              select 
                @cd_mascara_conta = isnull(cd_mascara_conta,'0')
              from
                Plano_conta
              where
                cd_empresa = @cd_empresa and
                cd_conta   = @cd_conta
              --print('Encontrando conta Superior. Máscara: '+@cd_mascara_conta) 
           
              -- se a máscara é igual a 1 quer dizer que é do grupo superior   
              if (len(@cd_mascara_conta) = 1)
                begin
                  --print('Vai para o Próximo Movimento')
                  goto ProximoMovimento
                end
              else
                while (@cd_contador <= len(@cd_mascara_conta))
                  begin
                    -- se encontrou um ponto, entao carrega a nova máscara com o grupo superior
                    if (substring(@cd_mascara_conta, (len(@cd_mascara_conta)-@cd_contador),1) = '.')
                      begin
                        set @cd_mascara_conta = (substring(@cd_mascara_conta, 1, (len(@cd_mascara_conta) - (@cd_contador + 1))))
                        break
                      end
                    set @cd_contador = @cd_contador + 1
                  end
                 
              -- após encontrada a nova máscara, encontrar a conta e reduzido
              select
                @cd_conta          = cd_conta,
                @cd_conta_reduzido = cd_conta_reduzido
              from
                Plano_conta
              where
                cd_empresa       = @cd_empresa and
                cd_mascara_conta = @cd_mascara_conta
              --print('Encontrado conta Superior. Máscara: '+@cd_mascara_conta) 
              -- atualizar movimento da nova conta
              goto AtualizaValor
            end                            
          ProximoMovimento:
           begin
 
              --print('Apagando Registro Processado, Movimento:' + cast(@cd_movimento as varchar(9)))
  
              delete from 
                #MovimentoContabil 
              where
                cd_movimento = @cd_movimento
           end
        end
      -- lista o resultado
      select * from 
        #SaldoConta 
      where
        vl_saldo_conta <> 0
      order by cd_conta
      drop table #SaldoConta
    end                 
  -----------------------------------------------------------------------------
  if (@ic_parametro = 2)  -- Conta Unica
  -----------------------------------------------------------------------------
    begin
      -- esta opçao somente aceita contas analíticas
      if ((select 
             ic_conta_analitica 
           from
             Plano_conta
           where
             cd_empresa = @cd_empresa and
             cd_conta_reduzido = @cd_conta_reduzido) = 'T')
        begin    
          raiserror('Conta Sintética nao Permitida nesta Operaçao!',16,1)
          return 
        end
      -- pesquisa conta através do reduzido passado         
      set @cd_conta = (select 
                         cd_conta 
                       from 
                         Plano_conta 
                       where 
                         cd_empresa = @cd_empresa and 
                         cd_conta_reduzido = @cd_conta_reduzido)
      --print(cast(@cd_conta as char(8))) 
      -- carrega a tabela temporária com o saldo de encerramento
      select
        p.cd_conta,
        isnull(s.vl_saldo_conta, 0) as 'vl_saldo_conta',
        isnull(s.ic_saldo_conta,'') as 'ic_saldo_conta'
      into 
        #SaldoContaUnica
      from
        Plano_conta p left outer join Saldo_conta s on s.cd_conta = p.cd_conta and s.dt_saldo_conta = @dt_saldo_conta
      where
        p.cd_empresa     = @cd_empresa and
        p.cd_conta       = @cd_conta
      --print('Saldo de Encerramento')
      --select * from #SaldoContaUnica
      -- se nao existir saldo de encerramento, carregar com saldos de implantaçao
      if not exists(select * from 
                      #SaldoContaUnica
                    where
                      vl_saldo_conta <> 0)
        begin
          update 
            #SaldoContaUnica
          set
            cd_conta = i.cd_conta,
            vl_saldo_conta = i.vl_saldo_implantacao,
            ic_saldo_conta = i.ic_saldo_implantacao
          from
            #SaldoContaUnica e left outer join Saldo_conta_implantacao i on e.cd_conta = i.cd_conta
          where
            cd_empresa = @cd_empresa
      
          --print('Saldo de Implantaçao')
          --select * from #SaldoContaUnica
        end
      -- acerto da data inicial para trazer os movimentos após o saldo inicial
      set @dt_saldo_conta = @dt_saldo_conta + 1
      -- criando tabela temporária com os movimentos do período (Débito)
      select
        identity(int, 0, 2)            as 'cd_movimento',
        m.cd_lote,
        m.cd_lancamento_contabil,
        m.vl_lancamento_contabil,
        'D'                            as 'ic_lancamento_contabil'
      into
        #MovimentoContabilDebitoUnica
      from
        Movimento_Contabil m, Lote_Contabil l
      where
        l.cd_empresa    = @cd_empresa                        and
        l.cd_exercicio  = @cd_exercicio                      and
        l.cd_lote       = m.cd_lote                          and
        l.ic_ativa_lote = 'S'                                and
        m.dt_lancamento_contabil between @dt_saldo_conta     and 
                                         @dt_base_saldo      and
        m.cd_reduzido_debito = @cd_conta_reduzido
      --print('Movimentos Contábeis a Débito')
      --select * from #MovimentoContabilDebitoUnica
      -- criando tabela temporária com os movimentos do período (Crédito)
      select
        identity(int, 1, 2)             as 'cd_movimento',
        m.cd_lote,
        m.cd_lancamento_contabil,
        m.vl_lancamento_contabil,
        'C'                             as 'ic_lancamento_contabil'
      into
        #MovimentoContabilCreditoUnica
      from
        Movimento_contabil m, Lote_Contabil l
      where
        l.cd_empresa    = @cd_empresa                    and
        l.cd_exercicio  = @cd_exercicio                  and
        l.cd_lote       = m.cd_lote                      and
        l.ic_ativa_lote = 'S'                            and
        m.dt_lancamento_contabil between @dt_saldo_conta and 
                                          @dt_base_saldo and
        m.cd_reduzido_credito = @cd_conta_reduzido
      --print('Movimento Contábil a Crédito')
      --select * from #MovimentoContabilCreditoUnica
      -- criando tabela temporária com a uniao das tabelas de débito e crédito
      select * into
        #MovimentoContabilUnica
      from 
        #MovimentoContabilDebitoUnica
      union all select * from
        #MovimentoContabilCreditoUnica
      --print('Movimento Contábil')
      --select * from #MovimentoContabilUnica
    
      -- Lê a tabela de Movimento contabil e alimenta a de Saldo da Conta
      while exists(select * from #MovimentoContabilUnica)
        begin
      
          select 
            @cd_movimento           = cd_movimento, 
            @cd_lancamento_contabil = cd_lancamento_contabil,
            @ic_lancamento_contabil = ic_lancamento_contabil,
            @vl_lancamento_contabil = vl_lancamento_contabil
          from
            #MovimentoContabilUnica
          --print('Processando Movimento: '+cast(@cd_movimento as varchar(9)))
          -- Débito
          if (@ic_lancamento_contabil = 'D')
            begin
    
              --print('É Débito')                  
 
              -- Conta sem saldo  
              if ((select ic_saldo_conta from #SaldoContaUnica) = '')
                begin
                  --print('Conta sem Saldo')
                  update
                    #SaldoContaUnica
                  set
                    vl_saldo_conta = @vl_lancamento_contabil,
                    ic_saldo_conta = 'D'
                end
              else 
                -- Conta com Saldo Devedor
                if ((select ic_saldo_conta from #SaldoContaUnica) = 'D')
                  begin
                    --print('Conta com Saldo Devedor')
   
                    update
                      #SaldoContaUnica
                    set
                      vl_saldo_conta = vl_saldo_conta + @vl_lancamento_contabil,
                      ic_saldo_conta = 'D'
 
                  end
                else  
                  -- Conta com Saldo Credor (se o saldo depois de calculado ficar negativo
                  -- torna-o positivo e troca-se o sinal
                  begin
                    --print('Conta com Saldo Credor')
                    set @ic_saldo_conta = 'C'
                    set @vl_saldo_conta = (select vl_saldo_conta from #SaldoContaUnica) - @vl_lancamento_contabil                     
                    if @vl_saldo_conta < 0
                      begin
                        --print('Saldo negativo acertado') 
                        set @vl_saldo_conta = @vl_saldo_conta * (-1)
                        set @ic_saldo_conta = 'D'
                      end                      
                    update
                      #SaldoConta
                    set
                      vl_saldo_conta = @vl_saldo_conta,
                      ic_saldo_conta = @ic_saldo_conta
                      
                  end  
            end
          -- Crédito    
          if (@ic_lancamento_contabil = 'C')
            begin              
              --print('É Crédito')
              -- Saldo Zerado
              if ((select ic_saldo_conta from #SaldoContaUnica) = '')
                begin
                  --print('Saldo Zerado')
                  update
                    #SaldoContaUnica
                  set
                    vl_saldo_conta = @vl_lancamento_contabil,
                    ic_saldo_conta = 'C'
                end
              else 
                -- Saldo Credor
                if ((select ic_saldo_conta from #SaldoContaUnica) = 'C')
                  begin
                    --print('Saldo Credor')
                    update
                      #SaldoContaUnica
                    set
                      vl_saldo_conta = vl_saldo_conta + @vl_lancamento_contabil,
                      ic_saldo_conta = 'C'
                  end
                else               
                -- Saldo Devedor
                  begin
                    --print('Saldo Devedor')
                    set @ic_saldo_conta = 'D'
                    set @vl_saldo_conta = (select vl_saldo_conta from #SaldoContaUnica) - @vl_lancamento_contabil
                     
                    if @vl_saldo_conta < 0
                      begin
                        --print('Saldo Negativo Acertado')
                        set @vl_saldo_conta = @vl_saldo_conta * (-1)
                        set @ic_saldo_conta = 'C'
                      end
                      
                    update
                      #SaldoContaUnica
                    set
                      vl_saldo_conta = @vl_saldo_conta,
                      ic_saldo_conta = @ic_saldo_conta
                      
                  end  
            end
          --print('Apagando Registro Processado, Movimento:' + cast(@cd_movimento as varchar(9)))
  
          delete from 
            #MovimentoContabilUnica
          where
            cd_movimento = @cd_movimento
                    
        end  
  
      select * from #SaldoContaUnica
      drop table #SaldoContaUnica
    end
end
      


