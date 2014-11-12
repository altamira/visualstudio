
-------------------------------------------------------------------------
---pr_atualiza_valor_plano_conta
-------------------------------------------------------------------------
---GBS-Global Business Solution Ltda                                2004
-------------------------------------------------------------------------
---Stored Procedure     : SQL Server Microsoft 2000
---Autor(es)            : Elias Pereira da Silva
---Objetivo             : Inclusão/Exclusão de Valores no Plano de Contas
---Data                 : 04/05/2001 
---Atualização          : 05/05/2001 - Inclusão do Parâmetro de Inclusão/Exclusão
---                                    @ic_movimento
---Alteração            : 19/11/2004 - Elias/Paulo Santos
--                      : 27/12/2004 - Ajuste na Atualização do Saldo de Implantação - Carlos
--                      : 28/12/2004 - Conferência
--                      : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 31/01/2006 - Acerto na Linha 579 de Select * para Select top 1 cd_conta - Dirceu/Carlos
--                      : 01.02.2006 - Busca da Conta de Grau Anterior - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------------

create procedure pr_atualiza_valor_plano_conta
@ic_parametro   int,              -- Parâmetro da Stored Procedure
@cd_empresa     int,              -- Código da Empresa
@cd_conta       int,              -- Código da Conta
@ic_movimento   char(1),          -- Tipo de Movimento ('I'nclusão/'E'xclusão) 
@vl_lancamento  numeric(25,2),    -- Valor do Lançamento
@ic_lancamento  char(1),          -- 'D'ébito/'C'rédito
@ic_implantacao char(1),          -- Saldo de Implantação ('S'/'N')
@cd_usuario     int               -- Código do Usuário

as
begin

  declare @cd_mascara_conta       varchar(30)    -- Máscara da Conta
  declare @cd_contador            int            -- Contador Usado na Função EncontraContaPai
  declare @ic_saldo_inicial_conta char(1)        -- Tipo do Saldo Inicial ('D'ébito/'C'rédito)
  declare @ic_saldo_atual_conta   char(1)        -- Tipo do Saldo Atual ('D'ébito/'C'rédito)
  declare @vl_debito              numeric(25,2)  -- Valor do Débito 
  declare @vl_credito             numeric(25,2)  -- Valor do Crédito
  declare @qt_grau_1              int

set @qt_grau_1 = 0

begin transaction

----------------------------------------------------------------------------------------
if @ic_parametro = 1                       -- Atualização dos Saldos do Plano de Contas
----------------------------------------------------------------------------------------
begin

  -- Guarda a máscara da conta
  
  Print('1 Guarda a máscara da conta')
  
  select 
    @cd_mascara_conta = cd_mascara_conta
  from
    Plano_conta
  where
    cd_empresa = @cd_empresa and
    cd_conta   = @cd_conta 

goto AtualizaValor


AtualizaValor:
begin

  -- Lançamentos iniciais (implantação) não há a contagem de lançamentos, somente a 
  -- atualização dos saldos iniciais e atuais

  -- Quando for Implantação
  -- O Saldo do Plano de Contas é Atualizado com o Saldos de Implantação

  if (@ic_implantacao = 'S')
    begin

      Print('2 Atualiza Valor')

      update 
        Plano_conta
      set
        vl_saldo_inicial_conta = @vl_lancamento,
        ic_saldo_inicial_conta = @ic_lancamento,
        vl_saldo_atual_conta   = @vl_lancamento,
        ic_saldo_atual_conta   = @ic_lancamento,
        vl_debito_conta        = 0,
        vl_credito_conta       = 0,
        qt_lancamento_conta    = 0,               
        cd_usuario             = @cd_usuario,
        dt_usuario             = getDate() 
      where
        cd_empresa = @cd_empresa and        --Empresa
        cd_conta   = @cd_conta              --Conta
    end

  else

    -- Lançamentos em geral
    begin

      Print('3 Lançamentos em Geral')

      -- D/C Saldo Anterior 
      select 
        @ic_saldo_inicial_conta = isnull(ic_saldo_inicial_conta,ic_tipo_conta)
      from
        Plano_conta
      where
        cd_empresa = @cd_empresa and
        cd_conta   = @cd_conta 
 
      -- Lançamentos a Débito
      if (@ic_lancamento = 'D')
        begin

          Print('4 Lançamento a Débito')
          
          -- Quando o Saldo Inicial for Débito
          if (@ic_saldo_inicial_conta = 'D')
            begin

              Print('5 Saldo Inicial a Débito')

              -- Inclusão do Lançamento 
              if (@ic_movimento = 'I')
                begin

                  Print('6 Inclusão de Lançamento')
 
                  update
                    Plano_conta
                  set
                    vl_debito_conta = 
                       (cast(Isnull(vl_debito_conta,0) as numeric(25,2))+ @vl_lancamento),
                    
                    vl_saldo_atual_conta = 
                         (cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2)) + 
                         (cast(Isnull(vl_debito_conta,0) as numeric(25,2))+ @vl_lancamento)-
                          cast(Isnull(vl_credito_conta,0) as numeric(25,2))),
                    
                    qt_lancamento_conta  = (qt_lancamento_conta + 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end

              else

                -- Exclusão do Lançamento
                begin

                  Print('7 Exclusão do Lançamento')

                  update
                    Plano_conta
                  set
                    vl_debito_conta = (cast(Isnull(vl_debito_conta,0) as numeric(25,2)) - @vl_lancamento),
                    
                    vl_saldo_atual_conta = (cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2))+ 
                                           (cast(Isnull(vl_debito_conta,0) as numeric(25,2)) - @vl_lancamento)-
                                            cast(Isnull(vl_credito_conta,0) as numeric(25,2))),
                    
                    qt_lancamento_conta  = (qt_lancamento_conta - 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
            end              

          -- Quando o saldo Inicial for Crédito

          if (@ic_saldo_inicial_conta = 'C')
            begin

              Print('8 Quando o saldo Inicial for Crédito')

              -- Inclusão de Lançamento
              if (@ic_movimento = 'I')
                begin
                  update
                    Plano_conta
                  set
                    vl_debito_conta = (cast(Isnull(vl_debito_conta,0) as numeric(25,2)) + @vl_lancamento),
                    
                    vl_saldo_atual_conta = ((cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2))*-1) +  
                                            (cast(Isnull(vl_debito_conta,0) as numeric(25,2)) + @vl_lancamento) -
                                            cast(Isnull(vl_credito_conta,0) as numeric(25,2))),
                    
                    qt_lancamento_conta  = (qt_lancamento_conta + 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
              else

                -- Exclusão de Lançamento
                begin
                  
                  Print('9 Exclusão de Lançamento')

                  update
                    Plano_conta
                  set
                    vl_debito_conta      = (cast(Isnull(vl_debito_conta,0) as numeric(25,2)) - @vl_lancamento),

                    vl_saldo_atual_conta = ((cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2))*-1) +  
                                            (cast(Isnull(vl_debito_conta,0) as numeric(25,2))- @vl_lancamento) -
                                            cast(Isnull(vl_credito_conta,0) as numeric(25,2))),

                    qt_lancamento_conta  = (qt_lancamento_conta - 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end

            end 
 
          -- Quando não houver saldo inicial ou for saldo zerado

          if ((@ic_saldo_inicial_conta = '') or (@ic_saldo_inicial_conta = '0'))
            begin
              Print('10 Inclusão de Lançamento Saldo Incial ou Zerado')

              -- Inclusão de Lançamento
              if (@ic_movimento = 'I')
                begin
                  Print('11 Inclusão de lançamento')

                  update
                    Plano_conta
                  set
                    vl_debito_conta      = (cast(Isnull(vl_debito_conta,0)  as numeric(25,2)) + @vl_lancamento),

                    vl_saldo_atual_conta = ((cast(Isnull(vl_debito_conta,0) as numeric(25,2)) + @vl_lancamento) -
                                            cast(Isnull(vl_credito_conta,0) as numeric(25,2))),

                    qt_lancamento_conta  = (qt_lancamento_conta + 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
              else

                -- Exclusão de Lançamento

                begin

                  Print('12 Exclusão de Lançamento')

                  update
                    Plano_conta
                  set
                    vl_debito_conta = 
                       (cast(Isnull(vl_debito_conta,0)  as numeric(25,2)) - @vl_lancamento),

                    vl_saldo_atual_conta = 
                      ((cast(Isnull(vl_debito_conta,0)  as numeric(25,2)) - @vl_lancamento) -
                        cast(Isnull(vl_credito_conta,0) as numeric(25,2))), 

                    qt_lancamento_conta  = (qt_lancamento_conta - 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end

            end  

          -- Determina o tipo de Saldo Atual (Valores Negativos não são Permitidos,
          -- quando ocorre de o valor ser negativo, muda-se o sinal)

          -- Se o Saldo Atual estiver Zerado marca-o com a tag '0' - Saldo Zerado

          if ((select 
                 Isnull(vl_saldo_atual_conta,0)
               from
                 Plano_conta
               where
                 cd_empresa = @cd_empresa and
                 cd_conta   = @cd_conta) = 0)  
            begin
              Print('13 Saldo Atual estiver Zerado marca-o com a tag 0 - Saldo Zerado')

              update
                Plano_conta
              set
                ic_saldo_atual_conta = ''
              where
                cd_empresa = @cd_empresa and
                cd_conta   = @cd_conta
            end
          else
            -- Se o saldo for maior que zero ele será Débito
            begin
              Print('14 Se o saldo for maior que zero ele será Débito')

              if ((select 
                     Isnull(vl_saldo_atual_conta,0)
                   from
                     Plano_conta
                   where
                     cd_empresa = @cd_empresa and
                     cd_conta   = @cd_conta) > 0)  
                begin

                  update
                    Plano_conta
                  set
                    ic_saldo_atual_conta = 'D'
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end

              else

                -- Saldo Menor que zero, tornar o valor positivo e indicar como Crédito
                begin
                  Print('15 Se o saldo for maior que zero ele será Débito')
                  update
                    Plano_conta
                  set
                    vl_saldo_atual_conta = 
                        (cast(Isnull(vl_saldo_atual_conta,0) as numeric(25,2))*-1),
                    ic_saldo_atual_conta = 'C'
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end 
            end   
        end

 
      -- Lançamentos a Crédito
      if (@ic_lancamento = 'C')
        begin
          Print('16 Lançamentos a Crédito')
          -- Saldo Inicial a Débito 
          if (@ic_saldo_inicial_conta = 'D')
            begin
              Print('17 Saldo Inicial a Débito')
              -- Inclusão de Lançamento
              if (@ic_movimento = 'I')
                begin
                  Print('18 Inclusão de Lançamento')
                  update
                    Plano_conta
                  set
                    vl_credito_conta = 
                      (cast(Isnull(vl_credito_conta,0) as numeric(25,2)) + @vl_lancamento),

                    vl_saldo_atual_conta = 
                        ((cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2))*-1) - 
                      cast(Isnull(vl_debito_conta,0) as numeric(25,2))+
                     (cast(Isnull(vl_credito_conta,0) as numeric(25,2)) + @vl_lancamento)),

                    qt_lancamento_conta  = (qt_lancamento_conta + 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
              else 

                -- Exclusão de Lançamento
                begin
                  Print('19 Exclusão de Lançamento')
                  update
                    Plano_conta
                  set
                    vl_credito_conta = 
                     (cast(Isnull(vl_credito_conta,0)          as numeric(25,2)) - @vl_lancamento),

                    vl_saldo_atual_conta = 
                       ((cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2))*-1) - 
                       cast(Isnull(vl_debito_conta,0)          as numeric(25,2))+
                     (cast(Isnull(vl_credito_conta,0)          as numeric(25,2)) - @vl_lancamento)),

                    qt_lancamento_conta  = (qt_lancamento_conta - 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
            end
        
          -- Saldo Inicial a Crédito
          if (@ic_saldo_inicial_conta = 'C')
            begin
              Print('20 Saldo Inicial a Crédito')
              -- Inclusão de Lançamento 
              if (@ic_movimento = 'I')
                begin
                  Print('21 Inclusão de Lançamento') 
                  update
                    Plano_conta
                  set
                    vl_credito_conta = 
                    (cast(Isnull(vl_credito_conta,0) as numeric(25,2)) + @vl_lancamento),

                    vl_saldo_atual_conta = 
                    (cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2))-  
                     cast(Isnull(vl_debito_conta,0) as numeric(25,2))+
                    (cast(Isnull(vl_credito_conta,0) as numeric(25,2)) + @vl_lancamento)),

                    qt_lancamento_conta  = (qt_lancamento_conta + 1)
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
              else

                -- Exclusão de Lançamento
                begin
                  Print('22 Exclusão de Lançamento') 
                  update
                    Plano_conta
                  set
                    vl_credito_conta = 
                     (cast(Isnull(vl_credito_conta,0)       as numeric(25,2)) - @vl_lancamento),

                    vl_saldo_atual_conta = 
                     (cast(Isnull(vl_saldo_inicial_conta,0) as numeric(25,2)) -  
                     cast(Isnull(vl_debito_conta,0)         as numeric(25,2)) +
                    (cast(Isnull(vl_credito_conta,0)        as numeric(25,2)) - @vl_lancamento)),

                    qt_lancamento_conta = (qt_lancamento_conta - 1)
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
            end

          -- Saldo anterior inexistente ou zerado 

          if ((@ic_saldo_inicial_conta = '') or (@ic_saldo_inicial_conta = '0'))
            begin
              Print('23 Saldo Anterior inexistente ou zerado')
              -- Inclusão de Lançamento
              if (@ic_movimento = 'I')
                begin
                  Print('24 Inclusão de Lançamento') 
                  update
                    Plano_conta
                  set
                    vl_credito_conta = 
                      (cast(Isnull(vl_credito_conta,0)    as numeric(25,2)) + @vl_lancamento),

                    vl_saldo_atual_conta = 
                        ((cast(Isnull(vl_credito_conta,0) as numeric(25,2)) + @vl_lancamento)-
                          cast(Isnull(vl_debito_conta,0)  as numeric(25,2))),

                    qt_lancamento_conta  = (qt_lancamento_conta + 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
              else
 
                -- Exclusão de Lançamento
                begin
                  Print('24 Exclusão de Lançamento')
                  update
                    Plano_conta
                  set
                    vl_credito_conta = 
                      (cast(Isnull(vl_credito_conta,0)  as numeric(25,2)) - @vl_lancamento),

                    vl_saldo_atual_conta = 
                      ((cast(Isnull(vl_credito_conta,0) as numeric(25,2)) - @vl_lancamento)-
                        cast(Isnull(vl_debito_conta,0)  as numeric(25,2))),

                    qt_lancamento_conta  = (qt_lancamento_conta - 1),
                    cd_usuario           = @cd_usuario,
                    dt_usuario           = getDate() 
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end

            end

          -- Caso o saldo atual for zero, marca-o com a tag " "(VAZIO) - Saldo Zerado

          if ((select 
                 Isnull(vl_saldo_atual_conta,0)
               from
                 Plano_conta
               where
                 cd_empresa = @cd_empresa and
                 cd_conta   = @cd_conta) = 0)  
            begin

              Print('26 Caso o Saldo atual for zero, marca-o com a tag = '' (VAZIO)')

              update
                Plano_conta
              set
                ic_saldo_atual_conta = ''
              where
                cd_empresa = @cd_empresa and
                cd_conta   = @cd_conta
            end
          else  
            begin 

              -- Caso o saldo atual for maior que zero então o saldo é a Crédito
              if ((select 
                     Isnull(vl_saldo_atual_conta,0)
                   from
                     Plano_conta
                   where
                     cd_empresa = @cd_empresa and
                     cd_conta   = @cd_conta) > 0)  
                begin
                  Print('27 Caso o saldo atual for maior que zero então o saldo é a Crédito')
                  update
                    Plano_conta
                  set
                    ic_saldo_atual_conta = 'C'
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end
              else

                -- Se o saldo atual for negativo, torna-o positivo e indica como Débito
                begin
                  Print('28 Se o saldo atual for negativo, torna-o positivo e indica como Débito')
                  update
                    Plano_conta
                  set
                    vl_saldo_atual_conta = 
                       (cast(Isnull(vl_saldo_atual_conta,0) as numeric(25,2))*-1),
                    ic_saldo_atual_conta = 'D'
                  where
                    cd_empresa = @cd_empresa and
                    cd_conta   = @cd_conta
                end 
            end
        end      

      goto EncontraContaPai

    end  

end

--Nova Rotina de Encontra Pai
EncontraContaPai:
begin

  if (len(@cd_mascara_conta) <> 1)  
  begin

    declare @qt_grau              int
    declare @cd_mascara_resultado varchar(20)
    declare @qt_grau_resultado    int

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
      @qt_grau_resultado    = isnull(qt_grau_conta,0)
    from
      Plano_Conta
    where 
      qt_grau_conta = @qt_grau-1 and
      substring(cd_mascara_conta ,1,dbo.fn_soma_digito_grau_conta(cd_grupo_conta,@qt_grau-1))=
      substring(@cd_mascara_conta,1,dbo.fn_soma_digito_grau_conta(cd_grupo_conta,@qt_grau-1))

    set @cd_mascara_conta = @cd_mascara_resultado

    print 'Conta Pai : '+@cd_mascara_resultado    
    print 'Grau Conta: '+cast( @qt_grau_resultado as varchar )

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
         else
            begin
              if @@ERROR = 0
                 commit tran
              else
                 begin
                   ---RAISERROR @@ERROR
                   rollback tran
                 end
             end
        end
  end

else
 begin
   if @@ERROR = 0
      commit tran
    else
      begin
        ---RAISERROR @@ERROR
        rollback tran
      end

    return
 end

end -- EncontraContaPai

end
end



--Anterior
--Carlos 01.02.2006
-- EncontraContaPai:
-- begin
--   
--   -- Se a máscara for igual a 1 quer dizer que é o grupo superior 
--   -- (Ativo, Passivo, Receitas, Despesas ...)e não existem grupos acima deles
-- 
--   if (len(@cd_mascara_conta) <> 1)  
--     begin
-- 
--       Print('29 EncontraContaPai - Se a máscara for igual a 1 quer dizer que é o grupo superior 
--             (Ativo, Passivo, Receitas, Despesas)e não existem grupos acima deles') 
-- 
--       if exists(select top 1 cd_conta
--                 from 
--                   Plano_conta
--                 where
--                   cd_empresa       = @cd_empresa and
--                   cd_mascara_conta = @cd_mascara_conta)
--         begin
-- 
--           Print('30 Inicializa o contador do loop')
-- 
--           -- inicializa o contador do loop  
-- 
--           set @cd_contador = 0
-- 
--           while ( @cd_contador <=  len(@cd_mascara_conta) )
--             begin
--               -- se encontrou o ponto, então carrega a nova mascara com o grupo superior
-- 
--               Print('31 se encontrou o ponto, então carrega a nova mascara com o grupo superior')
-- 
--               if (substring(@cd_mascara_conta, (len(@cd_mascara_conta)-@cd_contador), 1) = '.')
--                 begin
--                   set @cd_mascara_conta = (substring(@cd_mascara_conta, 1, (len(@cd_mascara_conta)-(@cd_contador+1))))
--                   break
--                 end      
-- 
--               set @cd_contador = @cd_contador + 1
-- 
--             end
--         end
-- 
--       Print('32 encontra o código da conta (chave) que é usado na maioria das pesquisas')
--       
--       -- encontra o código da conta (chave) que é usado na maioria das pesquisas       
-- 
--       select 
--         @cd_conta = cd_conta 
--       from
--         Plano_conta
--       where
--         cd_empresa       = @cd_empresa and
--         cd_mascara_conta = @cd_mascara_conta
-- 
--       print('Conta Pai Encontrada: '+@cd_mascara_conta)
-- 
--       -- Chava a sub função que atualiza o valor da conta
--       goto AtualizaValor
--     end
--   else
--    begin
--      if @@ERROR = 0
--        commit tran
--      else
--        begin
--          ---RAISERROR @@ERROR
--          rollback tran
--        end
--      return  
--    end
-- 
-- end
-- 
-- end
-- end

