
----------------------------------------------------------------------
--pr_balancete_verificacao
----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                             2004
----------------------------------------------------------------------                     
--Stored Procedure      : SQL Server Microsoft 2000  
--Autor(es)             : Carlos Cardoso Fernandes
--                      : Elias Pereira da Silva         
--Objetivo              : Balancete de Verificação
--Data                  : 31.05.2001
--Atualizado            : 13.06.2001 - Definição do parâmetro 1 para consulta do balancete
--                                     completo - Elias
--                      : 19.07.2001 - Inclusão de Balancete somente com contas Analiticas
--                                     (parametro 2) - Elias
--                      : 27.07.2001 - Inclusão de campo de Conta Sintética no resultado da
--                                      Query - Elias
--                      : 24.08.2001 - Inclusão de parâmetros 'dt_inicial' e 'dt_final' - Elias
--                      : 28.08.2001 - Acertos de Erros Encontrados - Elias
--                      : 09.10.2001 - Filtro dos movimentos somente quando lote ativo (ic_ativa_lote = 'S')
--                      : 31/01/2004 - Acerto na Rotina que Encontra a Conta Superior - ELIAS
-- Alteração            : 02/12/2004 - Acerto ao identificar que não existe saldo inicial, trazer zerado
--                      : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- Alteração            : 07/01/2005 - Alteração da composição do Saldo ao mudar de exercício
--                      : 02.02.2006 - Acerto na rotina da máscara para aceitar zero no cadastro - carlos fernandes
-------------------------------------------------------------------------------------------------------------------
CREATE   procedure pr_balancete_verificacao
@ic_parametro             int,
@ic_imprime_sem_movimento char(1),
@cd_empresa               int,
@cd_exercicio             int,
@dt_inicial               datetime,
@dt_final                 datetime,
@cd_mascara_conta_pesq    varchar(100)
as

begin

  -- chaves usadas para varrer a tabela de movimento contábil
  declare @cd_lancamento           int
  declare @cd_lote                 int
  -- variáveis para otimização do algoritmo de varredura
  declare @cd_conta_reduzido       int
  declare @cd_conta_reduzido_chave int
  declare @vl_lancamento           decimal(15,2)
  declare @ic_lancamento           char(1)
  declare @cd_mascara_conta        varchar(20)
  declare @qt_registro             int
  declare @cd_exercicio_saldo      int 
  declare @nm_msg                  varchar(150)
  declare @qt_grau_1               int
  
  -- inicialização
  set @cd_lancamento           = 0
  set @cd_lote                 = 0
  set @cd_conta_reduzido       = 0
  set @cd_conta_reduzido_chave = 0
  set @vl_lancamento           = 0.00 
  set @ic_lancamento           = ''
  set @cd_mascara_conta        = ''
  set @qt_registro             = 0
  set @cd_exercicio_saldo      = 0
  
  -----------------------------------------------------------------------------
  -- Criando Tabela Temporária #BalanceteContabil onde será listado o resultado
  -----------------------------------------------------------------------------

  -- tabela de saldo anterior
  create table #SaldoAnterior (
    cd_conta       int,
    cd_conta_reduzido int, 
    vl_saldo_conta float,
    ic_saldo_conta char(1))
  
  -- Se existir apenas um exercicio ativo trazer saldo inicial da tabela saldo_conta
  
  select 
    @qt_registro = count(cd_exercicio) 
  from 
    parametro_contabil
  where cd_empresa = @cd_empresa and
        isnull(ic_exercicio_ativo,'N') = 'S'
	
  if @qt_registro = 1
  begin

      --print('saldo_conta')
      --select * from plano_conta

      Insert
        #SaldoAnterior
      select
        pc.cd_conta, ''       as Reduzido, 
	isnull(sc.vl_saldo_conta,isnull(pc.vl_saldo_inicial_conta,0))    as vl_saldo_conta, 
	isnull(sc.ic_saldo_conta,isnull(pc.ic_saldo_inicial_conta,''))   as ic_saldo_conta
      from 
        Plano_Conta pc 
        left outer join Saldo_Conta sc  on pc.cd_conta = sc.cd_conta 
                                       and pc.cd_empresa = sc.cd_empresa 
                                       and sc.dt_saldo_conta = (@dt_inicial -1)
      where pc.cd_empresa = @cd_empresa
   end

  else
  begin
    set @cd_exercicio_saldo = @cd_exercicio - 1 -- comentado por psantos em 20/01/2005
    --print('saldo anterior')
    insert
      #SaldoAnterior		

    exec pr_saldo_anterior 1, @cd_empresa, @cd_exercicio_saldo, @dt_inicial, 0

  end
  
--select * from #saldoanterior
--select * from #saldoAnterior where cd_conta in (select cd_conta from plano_conta where cd_conta_reduzido in (5,53,99) and cd_empresa = dbo.fn_empresa())

  select
    p.cd_conta,
    p.cd_conta_reduzido,
    p.cd_conta_sintetica,
    p.cd_grupo_conta,
    p.qt_grau_conta,
    p.cd_mascara_conta,
    p.nm_conta,
    cast(isnull(s.vl_saldo_conta,0.00) as decimal(15,2)) as 'vl_saldo_inicial',
    isnull(s.ic_saldo_conta,'')                          as 'ic_saldo_inicial',
    cast(0.00 as decimal(15,2))                          as 'vl_debito_conta',
    cast(0.00 as decimal(15,2))                          as 'vl_credito_conta',
    cast(isnull(s.vl_saldo_conta,0.00) as decimal(15,2)) as 'vl_saldo_atual',
    isnull(s.ic_saldo_conta,'')                          as 'ic_saldo_atual',
    0                                                    as 'qt_lancamento',
    p.ic_conta_analitica,
    p.ic_tipo_conta,
    g.ic_tipo_grupo_conta
  into 
    #BalanceteContabil
  from
    Plano_conta p left outer join #SaldoAnterior s on s.cd_conta = p.cd_conta,
    Grupo_conta g
  where
    p.cd_empresa     = @cd_empresa and
    p.cd_grupo_conta = g.cd_grupo_conta
  
  --print('Balancete Contábil')
     
  -- criando tabela temporária com os movimentos do período (Débito)

  select
    m.cd_lote,
    m.cd_lancamento_contabil,
    m.cd_reduzido_debito                            as 'cd_conta_reduzido',
    cast(m.vl_lancamento_contabil as decimal(15,2)) as 'vl_lancamento_contabil',
    'D'                                             as 'ic_lancamento_contabil'
  into
    #MovimentoContabilDebito
  from
    Movimento_Contabil m, Lote_Contabil l
  where
    l.cd_empresa    = @cd_empresa                and
    l.cd_exercicio  = @cd_exercicio              and
    l.cd_lote       = m.cd_lote                  and
    l.ic_ativa_lote = 'S'                        and
    m.dt_lancamento_contabil between @dt_inicial and 
                                     @dt_final   and
    isnull(m.cd_reduzido_debito,0) <> 0

  --select * from movimento_contabil

  --print('Movimentos Contábeis a Débito')

  -- criando tabela temporária com os movimentos do período (Crédito)

  select
    m.cd_lote,
    m.cd_lancamento_contabil,
    m.cd_reduzido_credito                           as 'cd_conta_reduzido',
    cast(m.vl_lancamento_contabil as decimal(15,2)) as 'vl_lancamento_contabil',
    'C'                                             as 'ic_lancamento_contabil'
  into
    #MovimentoContabilCredito
  from
    Movimento_contabil m, Lote_Contabil l
  where
    l.cd_empresa    = @cd_empresa                and
    l.cd_exercicio  = @cd_exercicio              and
    l.cd_lote       = m.cd_lote                  and
    l.ic_ativa_lote = 'S'                        and
    m.dt_lancamento_contabil between @dt_inicial and 
                                     @dt_final   and
    isnull(m.cd_reduzido_credito,0) <> 0

  --print('Movimento Contábil a Crédito')

  -- criando tabela temporária com a união das tabelas de débito e crédito

  select * 
  into
    #MovimentoContabil
  from 
    #MovimentoContabilDebito
  union all select * from
    #MovimentoContabilCredito

  --print('Movimento Contábil')
    
  -- lendo a tabela de movimento e atualizando o saldo da 
  -- tabela de balancete
  
  while exists(select top 1 'x' from #MovimentoContabil)
    begin

      select 
        top 1
        @cd_lote                 = cd_lote,
        @cd_lancamento           = cd_lancamento_contabil,
        @cd_conta_reduzido       = cd_conta_reduzido,
        @cd_conta_reduzido_chave = cd_conta_reduzido,
        @vl_lancamento           = vl_lancamento_contabil,
        @ic_lancamento           = ic_lancamento_contabil
      from
        #MovimentoContabil

      set @qt_grau_1 = 0

      AtualizaValor:
        begin

          --print('Atualizando o valor da conta: '+cast(@cd_conta_reduzido as varchar(6)))

          -- lançamento a débito
          if (@ic_lancamento = 'D')
            begin      

              --print('Lançamento a Débito')

              -- saldo inicial a débito ou saldo zerado
              if ((select top 1
                     ic_saldo_inicial 
                   from 
                     #BalanceteContabil 
                   where 
                     cd_conta_reduzido = @cd_conta_reduzido) in ('D',''))
                begin

                  --print('Saldo Inicial a Débito ou Zerado')
                     
                  update
                    #BalanceteContabil
                  set
                    vl_debito_conta = (vl_debito_conta + @vl_lancamento),

                    vl_saldo_atual = 
                        (vl_saldo_inicial + 
                            (vl_debito_conta + @vl_lancamento) - vl_credito_conta),

                    qt_lancamento   = (qt_lancamento + 1)
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

              -- saldo inicial a crédito
              if ((select top 1
                     ic_saldo_inicial
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) = 'C')
                begin
                       
                  --print('Saldo Inicial a Crédito')             
    
                  update
                    #BalanceteContabil
                  set
                    vl_debito_conta = (vl_debito_conta + @vl_lancamento),

                    vl_saldo_atual = 
                          ((vl_saldo_inicial * (-1))+ 
                                (vl_debito_conta + @vl_lancamento) - vl_credito_conta),

                    qt_lancamento   = (qt_lancamento + 1)
                  where
                    cd_conta_reduzido = @cd_conta_reduzido
  
                  --print('Imprimindo Parcial de Balancete Contábil')
             
                end

              -- atualiza o tipo de saldo atual

              --print('Atualizando o Saldo Atual')
  
              -- valor do saldo atual zerado - tipo ''             
              if ((select top 1
                     vl_saldo_atual
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) = 0)
                begin
                 
                  --print('Saldo Atual Zerado')

                  update
                    #BalanceteContabil
                  set
                    ic_saldo_atual = ''
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

              -- valor do saldo atual positivo - tipo D
              if ((select top 1
                     vl_saldo_atual
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) > 0)
                begin

                  --print('Saldo Atual Positivo')

                  update
                    #BalanceteContabil
                  set
                    ic_saldo_atual = 'D'
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

              -- valor do saldo atual negativo - tipo C
              if ((select top 1
                     vl_saldo_atual
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) < 0)
                begin
              
                  --print('Saldo Atual Negativo')

                  update
                    #BalanceteContabil
                  set
                    vl_saldo_atual = (vl_saldo_atual * (-1)),
                    ic_saldo_atual = 'C'
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

            end

          -- lançamento a crédito
          if (@ic_lancamento = 'C')
            begin      

             --print('Lançamento a Crédito') 

              -- saldo inicial a débito
              if ((select top 1
                     ic_saldo_inicial 
                   from 
                     #BalanceteContabil 
                   where 
                     cd_conta_reduzido = @cd_conta_reduzido) = 'D')
                begin

                  --print('Saldo inicial a Débito')
                     
                  update
                    #BalanceteContabil
                  set
                    vl_credito_conta = (vl_credito_conta + @vl_lancamento),

                    vl_saldo_atual = 
                      ((vl_saldo_inicial * (-1))+ 
                            (vl_credito_conta + @vl_lancamento) - vl_debito_conta),

                    qt_lancamento     = (qt_lancamento + 1)
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

              -- saldo inicial a crédito ou zerado

              if ((select top 1
                     ic_saldo_inicial
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) in ('C',''))
                begin

                  --print('Saldo Inicial a Crédito ou Zerado')
                       
                  update
                    #BalanceteContabil
                  set
                    vl_credito_conta = 
                       cast((vl_credito_conta + @vl_lancamento) as numeric(15,2)),

                    vl_saldo_atual =  
                       cast((vl_saldo_inicial + 
                              (vl_credito_conta + @vl_lancamento) - 
                                               vl_debito_conta) as numeric(15,2)),

                    qt_lancamento   =  (qt_lancamento + 1)
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')
                
                end

              -- atualiza o tipo de saldo atual

              --print('Atualizando o Saldo Atual')  

              -- valor do saldo atual zerado - tipo ''             
              if ((select top 1
                     vl_saldo_atual
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) = 0)
                begin

                  --print('Saldo Atual Zerado')
                    
                  update
                    #BalanceteContabil
                  set
                    ic_saldo_atual = ''
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

              -- valor do saldo atual positivo - tipo C
              if ((select top 1
                     vl_saldo_atual
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) > 0)
                begin

                  --print('Saldo Atual Positivo')

                  update
                    #BalanceteContabil
                  set
                    ic_saldo_atual = 'C'
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

              -- valor do saldo atual negativo - tipo D
              if ((select top 1
                     vl_saldo_atual
                   from
                     #BalanceteContabil
                   where
                     cd_conta_reduzido = @cd_conta_reduzido) < 0)
                begin

                  --print('Saldo Atual Negativo')

                  update
                    #BalanceteContabil
                  set
                    vl_saldo_atual = (vl_saldo_atual * (-1)),
                    ic_saldo_atual = 'D'
                  where
                    cd_conta_reduzido = @cd_conta_reduzido

                  --print('Imprimindo Parcial de Balancete Contábil')

                end

            end

          goto EncontraContaPai

        end

--Carlos 02.02.2006
--Nova Rotina

      EncontraContaPai:
        begin

          declare @cd_contador int
          set     @cd_contador = 0

          -- pesquisa a máscara no plano de contas
          select 
            @cd_mascara_conta = cd_mascara_conta 
          from
            Plano_conta
          where
            cd_empresa        = @cd_empresa and
            cd_conta_reduzido = @cd_conta_reduzido                    

          if (isnull(@cd_mascara_conta,'')='') 
          begin
            set @nm_msg = 'Não Foi Encontrada a Conta '+cast(@cd_conta_reduzido as varchar)+
                          ' presente no Lançamento '+cast(@cd_lancamento as varchar)+'/'+
                          cast(@cd_lote as varchar)+ 
                          ' no Plano de Contas. Verifique!'            
            raiserror (@nm_msg,16,1)
            break
          end

          --print('Encontrando conta Superior. Máscara: '+@cd_mascara_conta) 
          --print('@cd_empresa '+cast(@cd_empresa as varchar))
          --print('@cd_conta_reduzido '+cast(@cd_conta_reduzido as varchar))

           
          -- se a máscara é igual a 1 quer dizer que é do grupo superior   
          if (len(@cd_mascara_conta) = 1)
            begin
              --print('Vai para o Próximo Movimento')
              goto ProximoMovimento
            end
          else
            begin
              declare @qt_grau              int
              declare @cd_mascara_resultado varchar(20)
              declare @qt_grau_resultado    int
              declare @cd_conta             int

              set @cd_conta = 0

              --gera o grau da conta

              select 
                @qt_grau = isnull(qt_grau_conta,0)
              from 
                Plano_conta
              where
                cd_empresa       = @cd_empresa and
                cd_mascara_conta = @cd_mascara_conta

              --Conta Resultado

              select 
                @cd_conta             = isnull(cd_conta,0),
                @cd_mascara_resultado = isnull(cd_mascara_conta,''),
                @qt_grau_resultado    = isnull(qt_grau_conta,0),
                @cd_conta_reduzido    = cd_conta_reduzido
              from
                Plano_Conta
              where 
                qt_grau_conta = @qt_grau-1 and
                substring(cd_mascara_conta ,1,dbo.fn_soma_digito_grau_conta(cd_grupo_conta,@qt_grau-1))=
                substring(@cd_mascara_conta,1,dbo.fn_soma_digito_grau_conta(cd_grupo_conta,@qt_grau-1))

              set @cd_mascara_conta = @cd_mascara_resultado

              print 'Conta Pai : '+@cd_mascara_resultado    
              print 'Grau Conta: '+cast( @qt_grau_resultado as varchar )

             --print('Encontrado conta Superior. Máscara: '+@cd_mascara_conta) 

             if @qt_grau_resultado>1
                begin
                  goto AtualizaValor
                end
             else
                begin
                  if @qt_grau_resultado = 1 and @qt_grau_1 = 0
                     begin
                      set @qt_grau_1 = 1
                      goto AtualizaValor
                     end 
                end
            end
        end       



--Rotina Antiga

--       EncontraContaPai:
--         begin
-- 
--           declare @cd_contador int
--           set     @cd_contador = 0
-- 
--           -- pesquisa a máscara no plano de contas
--           select 
--             @cd_mascara_conta = cd_mascara_conta 
--           from
--             Plano_conta
--           where
--             cd_empresa = @cd_empresa and
--             cd_conta_reduzido = @cd_conta_reduzido                    
-- 
--           if (isnull(@cd_mascara_conta,'')='') 
--           begin
--             set @nm_msg = 'Não Foi Encontrada a Conta '+cast(@cd_conta_reduzido as varchar)+
--                           ' presente no Lançamento '+cast(@cd_lancamento as varchar)+'/'+
--                           cast(@cd_lote as varchar)+ 
--                           ' no Plano de Contas. Verifique!'            
--             raiserror (@nm_msg,16,1)
--             break
--           end
-- 
--           --print('Encontrando conta Superior. Máscara: '+@cd_mascara_conta) 
--           --print('@cd_empresa '+cast(@cd_empresa as varchar))
--           --print('@cd_conta_reduzido '+cast(@cd_conta_reduzido as varchar))
--            
--           -- se a máscara é igual a 1 quer dizer que é do grupo superior   
--           if (len(@cd_mascara_conta) = 1)
--             begin
--               --print('Vai para o Próximo Movimento')
--               goto ProximoMovimento
--             end
--           else
--             while (@cd_contador <= len(@cd_mascara_conta))
--               begin
--                 -- se encontrou um ponto, então carrega a nova máscara com o grupo superior
--                 if (substring(@cd_mascara_conta, (len(@cd_mascara_conta)-@cd_contador),1) = '.')
--                   begin
--                     set @cd_mascara_conta = (substring(@cd_mascara_conta, 1, (len(@cd_mascara_conta) - (@cd_contador + 1))))
--                     break
--                   end
--                 set @cd_contador = @cd_contador + 1
--               end
--                  
--           -- após encontrada a nova máscara, encontrar a conta
--           select
--             @cd_conta_reduzido = cd_conta_reduzido
--           from
--             Plano_conta
--           where
--             cd_empresa = @cd_empresa and
--             cd_mascara_conta = @cd_mascara_conta
-- 
--           --print('Encontrado conta Superior. Máscara: '+@cd_mascara_conta) 
-- 
--           -- atualizar movimento da nova conta
--           goto AtualizaValor
-- 
--         end       
      
      ProximoMovimento:
        begin
          delete from 
            #MovimentoContabil 
          where        
            cd_lote                = @cd_lote and
            cd_lancamento_contabil = @cd_lancamento and
            cd_conta_reduzido      = @cd_conta_reduzido_chave
        end
                          
    end

  -----------------------------------------------------------------------------
  -- Converte valores de contas redutoras para negativo
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  if @ic_parametro = 1                     -- Balancete de Verificação Completo
  -----------------------------------------------------------------------------
    begin
      if @ic_imprime_sem_movimento = 'S'
        begin  
          select 
            * 
          from 
            #BalanceteContabil 
          order by 
            cd_mascara_conta
        end
      else
        begin
          select 
            * 
          from 
            #BalanceteContabil 
          where
            vl_saldo_inicial <> 0 or
            vl_saldo_atual <> 0
          order by 
            cd_mascara_conta
        end
    end

  -----------------------------------------------------------------------------
  if @ic_parametro = 2                             -- Somente Contas Analíticas
  -----------------------------------------------------------------------------
    begin
      if @ic_imprime_sem_movimento = 'S'
        begin  
          select 
            * 
          from 
            #BalanceteContabil 
          where
            ic_conta_analitica = 'a'  
          order by 
            cd_mascara_conta
        end
      else
        begin
          select 
            * 
          from 
            #BalanceteContabil 
          where
            ic_conta_analitica = 'a' and
            vl_saldo_inicial <> 0 or
            vl_saldo_atual <> 0
          order by 
            cd_mascara_conta
        end
    end

-----------------------------------------------------------------------------
  if @ic_parametro = 3              -- Relação Analítica em Ordem Alfabética
  ---------------------------------------------------------------------------
    begin
      if @ic_imprime_sem_movimento = 'S'
        begin    
          select 
            * 
          from 
            #BalanceteContabil
          where 
            cd_mascara_conta like @cd_mascara_conta_pesq + '%'
          order by 
            cd_mascara_conta
        end
      else
        begin
          select 
            * 
          from 
            #BalanceteContabil 
          where
            cd_mascara_conta like @cd_mascara_conta_pesq + '%' and 
            vl_saldo_inicial <> 0 or vl_saldo_atual <> 0
          order by 
            cd_mascara_conta
        end
    end

-----------------------------------------------------------------------------
  if @ic_parametro = 4  -- Relação Analítica em Ordem Alfabética -- Somente Contas Analíticas
-----------------------------------------------------------------------------
    begin
      if @ic_imprime_sem_movimento = 'S'
        begin  
          select 
            * 
          from 
            #BalanceteContabil 
          where
            cd_mascara_conta like @cd_mascara_conta_pesq + '%' and 
            ic_conta_analitica = 'a'  
          order by 
            cd_mascara_conta
        end
      else
        begin
          select 
            * 
          from 
            #BalanceteContabil 
          where
            cd_mascara_conta like @cd_mascara_conta_pesq + '%' and 
            ic_conta_analitica = 'a' and
            vl_saldo_inicial <> 0 or
            vl_saldo_atual <> 0
          order by 
            cd_mascara_conta
        end
    end
end                                



