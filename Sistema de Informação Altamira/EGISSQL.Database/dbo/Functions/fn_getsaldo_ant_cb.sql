﻿
----------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
----------------------------------------------------------------------------------------------
--Function: Microsoft SQL Server       2000
--Autor(es)     : Igor Gama
--Banco de Dados: SQL
--Objetivo      : Trazer o saldo anterior da tabela 
--  Conta_Banco_Saldo
-- Data         : 08/07/2002
-- Atualizado   : 13/02/2003 - Retirada a atualização por plano_financeiro - ELIAS
-- 23/06/2004 - Revista forma de cálculo do saldo Anterior. - Daniel C. Neto.
-- 21.12.2005 - Acerto na Busca do Saldo Anterior - Carlos Fernandes
-- 19.07.2007 - Verificação - Carlos Fernandes
-- 25.07.2007 - Acertos para Busca do Saldo - Carlos Fernandes
-- 17.06.2009 - Ajustes - Carlos Fernandes
----------------------------------------------------------------------------------------------
Create function fn_getsaldo_ant_cb
(@dt_saldo                 datetime,
 @cd_conta_banco           int,
 @cd_plano_financeiro      int,
 @cd_tipo_lancamento_fluxo int)

RETURNS float

-- @vl_saldo int output

AS

BEGIN

  --select * from conta_agencia_banco

  declare @dt_saldo_ant        datetime
  declare @vl_saldo            decimal(25,2)
  declare @vl_debito           decimal(25,2)
  declare @vl_credito          decimal(25,2)
  declare @cd_tipo_operacao    int
  declare @vl_saldo_composicao decimal(25,2)
  declare @ic_limite_conta     char(1) 
  declare @vl_limite_conta     decimal(25,2)

  set @vl_saldo            = 0.00
  set @vl_saldo_composicao = 0.00
  set @vl_debito           = 0.00
  set @vl_credito          = 0.00
  set @dt_saldo            = @dt_saldo - 1 
  set @ic_limite_conta     = 'N'
  set @vl_limite_conta      = 0.00

  --Busca o Limite da Conta

  select 
    @ic_limite_conta = isnull(ic_limite_fluxo_caixa,'N'),
    @vl_limite_conta = isnull(vl_limite_conta_banco,0)
  from
    conta_agencia_banco with (nolock) 
  where
    cd_conta_banco = @cd_conta_banco
  

  set @dt_saldo_ant   = ( Select top 1 max(dt_saldo_conta_banco) From dbo.Conta_Banco_Saldo 
                          where dt_saldo_conta_banco    <= @dt_saldo       and
                                cd_conta_banco           = @cd_conta_banco and
                        --cd_plano_financeiro = @cd_plano_financeiro and
                                cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo )

  --print @dt_saldo_ant

  If Exists (Select top 1 'X' From dbo.Conta_Banco_Saldo 
             where dt_saldo_conta_banco    <= @dt_saldo_ant      and
                   cd_conta_banco           = @cd_conta_banco and
                   --cd_plano_financeiro = @cd_plano_financeiro and
                   cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo)
  Begin

    Select 
      @cd_tipo_operacao = cd_tipo_operacao_final,
      @vl_saldo         = isnull(vl_saldo_final_conta_banco,0)
    From 
      dbo.Conta_Banco_saldo 
    Where 
      dt_saldo_conta_banco     = @dt_saldo_ant   and
      cd_conta_banco           = @cd_conta_banco and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo

  end
  else
    set @vl_saldo = 0

--   if @vl_saldo_composicao = 0 
--   begin
--     select
--       @vl_saldo_composicao =  
--         ( sum(case when l.cd_tipo_operacao = 2 then 
--                          cast(isnull(l.vl_lancamento,0)  as numeric(25,2)) * - 1 
--                        else 
--                          cast(isnull(l.vl_lancamento,0)  as numeric(25,2)) 
--                        end))
--     from
--       conta_banco_lancamento l
--     where
--       cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
--       l.cd_conta_banco         = @cd_conta_banco and
--       cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,@dt_saldo,103) as datetime) --and
--   end

  If @cd_tipo_operacao = 2
  begin
     set @vl_saldo = isnull(@vl_saldo,0) * (-1)
  end

  --Checa se a composição é diferente da Tabela de Saldos

--    if @vl_saldo<>@vl_saldo_composicao
--    begin
--      set @vl_saldo = @vl_saldo_composicao
--    end

  --Verifica se a conta considera o Limite no Cálculo

  if @ic_limite_conta     = 'S'
  begin
     set @vl_saldo = @vl_saldo + isnull(@vl_limite_conta,0.00)
  end

  return( IsNULL(@vl_saldo,0) )

end

