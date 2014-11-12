


/****** Object:  Stored Procedure dbo.pr_atualiza_saldo_implantacao    Script Date: 13/12/2002 15:08:12 ******/
----------------------------------------------------------------------------
---pr_atualiza_saldo_implantacao
----------------------------------------------------------------------------
---GBS-Global Business Solution Ltda                                    2004
----------------------------------------------------------------------------
---Stored Procedure      : SQL Server Microsoft 2000
---Autor                 : Elias Pereira da Silva
---Objeivo               : Inclusao/Exclusao de saldo de implantaçao
---Data                  : 07/05/2001 
---Atualizaçao           : 25/07/2001 - Data de implantacao (dt_implantacao) será
---                      : sempre informada pelo usuário
---                      : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
---                      : 31/01/2006 - Acerto na Linha 510 de Select * para Select top 1 cd_conta - Dirceu/Carlos
---                      : 01.02.2006 - Encontra conta Pai, permitir conta com cadastro de zeros, exemplo :
---                                     1.0.0.00.0000 - Carlos Fernades                               
----------------------------------------------------------------------------------
CREATE  procedure pr_atualiza_saldo_implantacao
@ic_parametro   int,
@cd_empresa     int,
@cd_conta       int,
@dt_implantacao datetime,
@ic_movimento   char(1),
@vl_lancamento  float,
@ic_lancamento  char(1),
@cd_usuario     int
as

begin

  declare @sinal            char(1)
  declare @cd_mascara_conta varchar(20)
  declare @cd_contador      int
  declare @qt_grau_1        int

  set @sinal            = ''
  set @cd_mascara_conta = ''
  set @cd_contador      = 0
  set @qt_grau_1        = 0


if @ic_parametro = 1 
begin

  select 
    @cd_mascara_conta = cd_mascara_conta
  from
    plano_conta
  where
    cd_empresa = @cd_empresa and
    cd_conta   = @cd_conta

  goto
    AtualizaValor

AtualizaValor:
begin
  print ('Atualizando Valor da conta: '+@cd_mascara_conta)

if @ic_movimento = 'I'
begin --0

  print ('Inclusao')

  -- se a seleçao estiver vazia faz-se a inclusao
  if (not exists(select top 1 cd_conta
       from
         saldo_conta_implantacao
       where
         cd_empresa = @cd_empresa and
         cd_conta   = @cd_conta))
    begin  --1 
      print ('Inclusao de saldo novo') 
      insert into saldo_conta_implantacao(
        cd_empresa,
        cd_conta,
        dt_implantacao,
        vl_saldo_implantacao,
        ic_saldo_implantacao,
        ic_implantado,
        cd_usuario,
        dt_usuario)
      values (
        @cd_empresa,
        @cd_conta,
        @dt_implantacao,
        @vl_lancamento,
        @ic_lancamento,
        'N',
        @cd_usuario,
        getDate())  

      goto EncontraContaPai

    end --1
  else
    -- se a seleçao contiver conteúdo, faz a atribuiçao de valores 
    -- levando-se em consideraçao o tipo de valor já existente (D/C)
    -------------------------------------------------------------------
    -- SALDO DEVEDOR (JA EXISTENTE)
    -------------------------------------------------------------------
    if ((select 
           ic_saldo_implantacao
         from
           saldo_conta_implantacao
         where
           cd_empresa = @cd_empresa and
           cd_conta   = @cd_conta) = 'D')
      begin --2

        print ('Saldo Devedor já existente')

        -- se  o tipo for devedor e o lançamento também, soma o valor do lançamento 
        if (@ic_lancamento = 'D')
          begin --3
            print ('Tipo Devedor, soma-se o lançamento')
            update
              saldo_conta_implantacao
            set
              dt_implantacao       = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao + @vl_lancamento),
              ic_implantado        = 'N',
              cd_usuario           = @cd_usuario,
              dt_usuario           = getDate()  
            where
              cd_empresa = @cd_empresa and
              cd_conta   = @cd_conta
          end --3
        -- se o tipo for credor (diferente do já existente) subtrai-se o valor
        if (@ic_lancamento = 'C')
          begin --4
            print ('Tipo Credor, subtrai o lançamento') 
            update 
              saldo_conta_implantacao
            set
              dt_implantacao       = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao - @vl_lancamento),
              ic_implantado        = 'N',
              cd_usuario           = @cd_usuario,
              dt_usuario           = getDate()
            where
              cd_empresa  = @cd_empresa and
              cd_conta    = @cd_conta
            
            -- se o valor ficou negativo após a subtracao indica-o como credor
            if ((select
                   vl_saldo_implantacao
                 from
                   saldo_conta_implantacao
                 where
                   cd_empresa = @cd_empresa and
                   cd_conta = @cd_conta) < 0)    
              begin --5
                print ('Valor Negativo Após Subtraçao, Inversao do Sinal')
                update
                  saldo_conta_implantacao
                set
                  vl_saldo_implantacao = (vl_saldo_implantacao*-1),
                  ic_saldo_implantacao = 'C'
                where
                  cd_empresa = @cd_empresa and
                  cd_conta = @cd_conta
              end --5
            -- se ficou zero, indica-o como saldo zerado 
            if ((select
                   vl_saldo_implantacao
                 from
                   saldo_conta_implantacao
                 where
                   cd_empresa = @cd_empresa and
                   cd_conta = @cd_conta) = 0)    
              begin --6
                print ('Saldo zerado após subtraçao, indicaçao de saldo zero')
                update
                  saldo_conta_implantacao
                set
                  ic_saldo_implantacao = ''
                where
                  cd_empresa = @cd_empresa and
                  cd_conta = @cd_conta
              end --6
          end --4

        goto EncontraContaPai

      end --2
    -------------------------------------------------------------------
    -- SALDO CREDOR (JA EXISTENTE)
    -------------------------------------------------------------------
    else if ((select 
           ic_saldo_implantacao
         from
           saldo_conta_implantacao
         where
           cd_empresa = @cd_empresa and
           cd_conta = @cd_conta) = 'C')
      begin --7
        print('Saldo Credor já Existente') 
        -- se o tipo for credor e o lançamento também, soma o valor do lançamento 
        if (@ic_lancamento = 'C')
          begin --8
            print('Tipo Credor, soma-se o Lançamento')
            update
              saldo_conta_implantacao
            set
              dt_implantacao       = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao + @vl_lancamento),
              ic_implantado        = 'N',
              cd_usuario           = @cd_usuario,
              dt_usuario           = getDate()  
            where
              cd_empresa = @cd_empresa and
              cd_conta = @cd_conta
          end --8
        -- se o tipo for devedor (diferente do já existente) subtrai-se o valor
        if (@ic_lancamento = 'D')
          begin --9
            print('Tipo Devedor, subtrai o lançamento') 
            update 
              saldo_conta_implantacao
            set
              dt_implantacao       = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao - @vl_lancamento),
              ic_implantado        = 'N',
              cd_usuario           = @cd_usuario,
              dt_usuario           = getDate()
            where
              cd_empresa = @cd_empresa and
              cd_conta = @cd_conta
            
            -- se o valor ficou negativo após a subtracao indica-o como devedor
            if ((select
                   vl_saldo_implantacao
                 from
                   saldo_conta_implantacao
                 where
                   cd_empresa = @cd_empresa and
                   cd_conta = @cd_conta) < 0)    
              begin --10
                print('Valor Negativo Após Subtraçao, Inversao do Sinal')
                update
                  saldo_conta_implantacao
                set
                  vl_saldo_implantacao = (vl_saldo_implantacao*-1),
                  ic_saldo_implantacao = 'D'
                where
                  cd_empresa = @cd_empresa and
                  cd_conta = @cd_conta
              end --10
            -- se ficou zero, indica-o como saldo zerado 
            if ((select
                   vl_saldo_implantacao
                 from
                   saldo_conta_implantacao
                 where
                   cd_empresa = @cd_empresa and
                   cd_conta = @cd_conta) = 0)    
              begin --11
                print('Saldo Zerado após Subtraçao, Indicaçao de Saldo Zerado')
                update
                  saldo_conta_implantacao
                set
                  ic_saldo_implantacao = ''
                where
                  cd_empresa = @cd_empresa and
                  cd_conta = @cd_conta
              end --11
          end --9

        goto EncontraContaPai 

      end --7
    -------------------------------------------------------------------
    -- SALDO ZERADO (JA EXISTENTE)
    -------------------------------------------------------------------
    else if (((select 
                 ic_saldo_implantacao
               from
                 saldo_conta_implantacao
               where
                 cd_empresa = @cd_empresa and
                 cd_conta = @cd_conta) = '0') or
              (select
                 ic_saldo_implantacao
               from
                 saldo_conta_implantacao
               where
                 cd_empresa = @cd_empresa and
                 cd_conta = @cd_conta) = '')  
      begin --12
        print('Saldo Zerado Já Existente')
        -- apenas soma o valor do lançamento
        update
          saldo_conta_implantacao
        set
          dt_implantacao = @dt_implantacao,
          vl_saldo_implantacao = @vl_lancamento,
          ic_saldo_implantacao = @ic_lancamento,
          ic_implantado = 'N',
          cd_usuario = @cd_usuario,
          dt_usuario = getDate()  
        where
          cd_empresa = @cd_empresa and
          cd_conta = @cd_conta
        goto EncontraContaPai
      end --12
end --0            
        
if @ic_movimento = 'E'
begin  --0
  print('Exclusao de Lançamento')
  -------------------------------------------------------------------
  -- SALDO DEVEDOR (JA EXISTENTE)
  -------------------------------------------------------------------
  if ((select 
         ic_saldo_implantacao
       from
         saldo_conta_implantacao
       where
         cd_empresa = @cd_empresa and
         cd_conta = @cd_conta) = 'D')
    begin --1     
      print('Saldo Devedor já Existente')
      -- se  o tipo for devedor e o lançamento também, subtrai o valor do lançamento 
      if (@ic_lancamento = 'D')
        begin --2
          print('Tipo de Saldo Devedor, subtrai o valor do Lancamento')
          update
            saldo_conta_implantacao
          set
            dt_implantacao = @dt_implantacao,
            vl_saldo_implantacao = (vl_saldo_implantacao - @vl_lancamento),
            ic_implantado = 'N',
            cd_usuario = @cd_usuario,
            dt_usuario = getDate()  
          where
            cd_empresa = @cd_empresa and
            cd_conta = @cd_conta
          -- se o valor ficou negativo após a subtracao indica-o como credor
          if ((select
                 vl_saldo_implantacao
               from
                 saldo_conta_implantacao
               where
                 cd_empresa = @cd_empresa and
                 cd_conta = @cd_conta) < 0)    
            begin --3
              print('Saldo Negativo Após a Subtraçao, Saldo Credor')
              update
                saldo_conta_implantacao
              set
                vl_saldo_implantacao = (vl_saldo_implantacao*-1),
                ic_saldo_implantacao = 'C'
              where
                cd_empresa = @cd_empresa and
                cd_conta = @cd_conta
            end --3
          -- se ficou zero, indica-o como saldo zerado 
          if ((select
                 vl_saldo_implantacao
               from
                 saldo_conta_implantacao
               where
                 cd_empresa = @cd_empresa and
                 cd_conta = @cd_conta) = 0)    
            begin --4
              print('Saldo Zerado após Subtraçao, Atribui sinal de saldo zerado')
              update
                saldo_conta_implantacao
              set
                ic_saldo_implantacao = ''
              where
                cd_empresa = @cd_empresa and
                cd_conta = @cd_conta
            end --4
        end --2
        -- se o tipo for credor (diferente do já existente) soma-se o valor
        if (@ic_lancamento = 'C')
          begin --5
            print('Tipo Credor, soma-se o valor')
            update 
              saldo_conta_implantacao
            set
              dt_implantacao = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao + @vl_lancamento),
              ic_implantado = 'N',
              cd_usuario = @cd_usuario,
              dt_usuario = getDate()
            where
              cd_empresa = @cd_empresa and
              cd_conta = @cd_conta            
          end  --5
    end --1
    -------------------------------------------------------------------
    -- SALDO CREDOR (JA EXISTENTE)
    -------------------------------------------------------------------
    else if ((select 
           ic_saldo_implantacao
         from
           saldo_conta_implantacao
         where
           cd_empresa = @cd_empresa and
           cd_conta = @cd_conta) = 'C')
      begin --6
        print('Saldo Credor Já Existente')
        -- se o tipo for credor e o lançamento também, subtrai o valor do lançamento 
        if (@ic_lancamento = 'C')
          begin --7
            print('Tipo de Lançamento Credor, subtrai o lançamento') 
            update
              saldo_conta_implantacao
            set
              dt_implantacao = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao - @vl_lancamento),
              ic_implantado = 'N',
              cd_usuario = @cd_usuario,
              dt_usuario = getDate()  
            where
              cd_empresa = @cd_empresa and
              cd_conta = @cd_conta
            -- se o valor ficou negativo após a subtracao indica-o como devedor
            if ((select
                   vl_saldo_implantacao
                 from
                   saldo_conta_implantacao
                 where
                   cd_empresa = @cd_empresa and
                   cd_conta = @cd_conta) < 0)    
              begin --8
                print('Saldo Negativo Após Subtraçao, Indicaçao de Saldo Devedor')
                update
                  saldo_conta_implantacao
                set
                  vl_saldo_implantacao = (vl_saldo_implantacao*-1),
                  ic_saldo_implantacao = 'D'
                where
                  cd_empresa = @cd_empresa and
                  cd_conta = @cd_conta
              end --8
            -- se ficou zero, indica-o como saldo zerado 
            if ((select
                   vl_saldo_implantacao
                 from
                   saldo_conta_implantacao
                 where
                   cd_empresa = @cd_empresa and
                   cd_conta = @cd_conta) = 0)    
              begin --9
                print ('Saldo Zerado Após Subtraçao, Atribui Código de Saldo Zerado')
                update
                  saldo_conta_implantacao
                set
                  ic_saldo_implantacao = ''
                where
                  cd_empresa = @cd_empresa and
                  cd_conta = @cd_conta
              end --9
          end --7
        -- se o tipo for devedor (diferente do já existente) soma-se o valor
        if (@ic_lancamento = 'D')
          begin --10
            print('Tipo de Lancamento Devedor, soma-se o valor do lançamento')
            update 
              saldo_conta_implantacao
            set
              dt_implantacao = @dt_implantacao,
              vl_saldo_implantacao = (vl_saldo_implantacao + @vl_lancamento),
              ic_implantado = 'N',
              cd_usuario = @cd_usuario,
              dt_usuario = getDate()
            where
              cd_empresa = @cd_empresa and
              cd_conta = @cd_conta            
          end --10
      end --6
    -------------------------------------------------------------------
    -- SALDO ZERADO (JA EXISTENTE)
    -------------------------------------------------------------------
    else if (((select 
                 ic_saldo_implantacao
               from
                 saldo_conta_implantacao
               where
                 cd_empresa = @cd_empresa and
                 cd_conta = @cd_conta) = '0') or
              (select
                 ic_saldo_implantacao
               from
                 saldo_conta_implantacao
               where
                 cd_empresa = @cd_empresa and
                 cd_conta = @cd_conta) = '') 
      begin --11            
        print('Saldo Zerado Já Existente')
        -- quando o saldo estiver zerado, atribui-se o valor a ele com
        -- sinal trocado
        set @sinal = ''
                 
        if @ic_lancamento = 'D'
          set @sinal = 'C'
        if @ic_lancamento = 'C'
          set @sinal = 'D'

        print('Trocou o Tipo anterior '+@ic_lancamento+' pelo novo tipo '+@sinal)
        
        update
          saldo_conta_implantacao
        set
          dt_implantacao = @dt_implantacao,
          vl_saldo_implantacao = @vl_lancamento,
          ic_saldo_implantacao = @sinal,
          ic_implantado = 'N',
          cd_usuario = @cd_usuario,
          dt_usuario = getDate()  
        where
          cd_empresa = @cd_empresa and
          cd_conta = @cd_conta
      end --11

  goto EncontraContaPai

end --0           
end -- AtualizaValor


--Nova Versão: Carlos 01.02.2006
-- 
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
        end
  end
else
  return

end -- EncontraContaPai

--Carlos 01.02.2006
--Antiga que não funcionava contas com zero no final
--
-- EncontraContaPai:
-- begin
-- 
--   if (len(@cd_mascara_conta) <> 1)  
--     begin
--       if exists(select top 1 cd_conta
--                 from 
--                   Plano_conta
--                 where
--                   cd_empresa = @cd_empresa and
--                   cd_mascara_conta = @cd_mascara_conta)
--         begin
--             
--           set @cd_contador = 0
--                 
--           while (@cd_contador <=  len(@cd_mascara_conta))
--             begin
--               if (substring(@cd_mascara_conta, (len(@cd_mascara_conta)-@cd_contador), 1) = '.')
--                 begin
--                   set @cd_mascara_conta = (substring(@cd_mascara_conta, 1, (len(@cd_mascara_conta)-(@cd_contador+1))))
--                   break
--                 end      
--               set @cd_contador = @cd_contador + 1
--             end
--         end
--                      
--       select 
--         @cd_conta = cd_conta 
--       from
--         Plano_conta
--       where
--         cd_empresa       = @cd_empresa and
--         cd_mascara_conta = @cd_mascara_conta
--                    
--       goto AtualizaValor
--     end
--   else
--     return
-- 
-- end -- EncontraContaPai


end -- @ic_parametro = 1
end -- procedure


-----------------------------------------------------------
--Testando a Stored Procedure
-----------------------------------------------------------
/*      

--select * from plano_conta order by cd_mascara_conta

exec pr_atualiza_saldo_implantacao 1, 14, 52, '12/31/2004','I', 250, 'D', 0

exec pr_atualiza_saldo_implantacao 1, 4, 5, 'E', 50, 'C', 0
exec pr_atualiza_saldo_implantacao 1, 4, 6, 'I', 100, 'D', 0
exec pr_atualiza_saldo_implantacao 1, 4, 5, 'I', 50, 'D', 0

select pct.cd_mascara_conta, pct.cd_conta_reduzido, sci.*
          from
            Plano_conta pct
          left outer join
            Saldo_conta_implantacao sci
          on 
            (pct.cd_empresa = sci.cd_empresa and 
            pct.cd_conta   = sci.cd_conta) 
          where
            sci.vl_saldo_implantacao <> 0
order by cd_mascara_conta 
delete from saldo_conta_implantacao */

