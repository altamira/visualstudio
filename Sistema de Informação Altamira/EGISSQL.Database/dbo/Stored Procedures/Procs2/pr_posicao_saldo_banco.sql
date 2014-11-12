
create procedure pr_posicao_saldo_banco
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)              : Elias Pereira da Silva
--Banco de Dados         : EgisSql
--Objetivo               : Listagem de Posição de Saldos Bancários
--Data                   : 26/03/2003
--Atualizado: 28/03/2003 - Daniel C. Neto
--                       - Incluído nome da Empresa.
--                       - Elias/Duela - Acertado o filtro da Correto de Data Base no Parametro 1
--            19.04.2007 - Correção da Consulta do Saldo Correto
--            21.04.2007 - Acertos Diversos - Carlos Fernandes
--            19.07.2007 - Verificação - Carlos Fernandes
--            25.07.2007 - Acerto do Saldo Inicial - Carlos Fernandes
--            03.09.2007 - Acerto do Saldos - Carlos Fernandes
--            17.10.2007 - Inclusão da Nova Rotina - Carlos Fernandes
--            27.10.2007 - Novas Colunas ( uso do Limite/Saldo em aberto conta ) - Carlos Fernandes
-- 23.03.2009 - Verificação de Conta Inativa - Carlos Fernandes 
-- 09.08.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@ic_parametro             int      = 1,
@dt_base                  datetime = '',
@cd_tipo_lancamento_fluxo int      = 2,
@dt_inicio_mes            datetime = '',
@cd_usuario               int      = 0,
@cd_conta_banco_aux       int      = 0,
@ic_saldo_total           char(1)  = 'N',
@vl_retorno_saldo         float    = 0 output --retorno

as


if @ic_saldo_total is null
   set @ic_saldo_total = 'N'

declare @cd_conta_banco    int
declare @dt_inicial        datetime
declare @vl_saldo_anterior decimal(25,2)

set @dt_inicial = @dt_base + 1

--select * from conta_agencia_banco

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Lista a Posição dos Saldos
-------------------------------------------------------------------------------
  begin

    select
       c.cd_conta_banco
    into 
      #AuxConta
    from 
      conta_agencia_banco c with (nolock) 
    where
      isnull(c.ic_ativo_conta,'S')           = 'S'
      and isnull(c.ic_fluxo_caixa_conta,'N') = 'S'

    select
      c.cd_conta_banco,
      cast(0 as decimal(25,2))        as SaldoContaBanco,
      cast(0 as decimal(25,2))        as SaldoFinal,
      @dt_base                        as dt_inicial_conta_banco

     into
      #AuxDataSaldo

    from 
      conta_agencia_banco c with (nolock) 

    where
      isnull(c.ic_ativo_conta,'S') = 'S'
      and isnull(c.ic_fluxo_caixa_conta,'N') = 'S'
      and c.cd_conta_banco = case when @cd_conta_banco_aux = 0 then c.cd_conta_banco else @cd_conta_banco_aux end

   set @vl_saldo_anterior = 0

   while exists ( select top 1 cd_conta_banco from #AuxConta )
   begin 
     select top 1
       @cd_conta_banco = cd_conta_banco
     from
       #AuxConta

      exec pr_saldo_sintetico_movimento_banco  9, 
                                               @dt_inicial,
                                               @cd_conta_banco,
                                               @cd_tipo_lancamento_fluxo,
                                               @dt_inicial,
                                               @dt_inicial,
                                               0, 
                                               1,
                                               0,
                                               @cd_usuario,
                                               @vl_saldo_atual_retorno = @vl_saldo_anterior output

     
      --select @dt_inicial,@dt_final,'@SaldoContaBanco', @SaldoContaBanco
	
    update
      #AuxDataSaldo
    set                                      --Verificar outros cliente qdo valor foi digitado
      SaldoFinal = isnull(SaldoContaBanco,0) + case when SaldoContaBanco=0 then isnull(@vl_saldo_anterior,0) else 0.00 end
    where
      cd_conta_banco = @cd_conta_banco
   
     delete from #AuxConta where cd_conta_banco = @cd_conta_banco

   end
   
    --select * from #AuxDataSaldo


    --select * from #AuxDataSaldo
  
  select
    c.cd_conta_banco,
    b.cd_numero_banco                                 as 'Banco',
    cast(ltrim(rtrim(ag.cd_numero_agencia_banco))+'-'+
    ltrim(rtrim(ag.nm_agencia_banco)) as varchar(20)) as 'Agencia',
    c.nm_conta_banco                                  as 'Conta',
    cast(e.nm_fantasia_empresa as varchar(15))        as 'Empresa',
    isnull(c.vl_limite_conta_banco,0)                 as 'Limite',
  --dbo.fn_getsaldo_ant_cb((cast(convert(int,@dt_base,103) as datetime)),c.cd_conta_banco,null,@cd_tipo_lancamento_fluxo) as 'SaldoInicial',
    isnull(a.SaldoFinal,0)                            as 'SaldoInicial',

    (select 
       sum(isnull(d.vl_lancamento,0)) 
     from 
       conta_banco_lancamento d  with (nolock) 
     where 
       d.cd_conta_banco                     = c.cd_conta_banco and
       d.cd_tipo_operacao                   = 2 and          
       d.cd_tipo_lancamento_fluxo           = @cd_tipo_lancamento_fluxo and
       isnull(d.ic_transferencia_conta,'N') = 'N' and
       cast(convert(int,d.dt_lancamento,103) as datetime) = cast(convert(int,@dt_base,103) as datetime))   as 'Debito',

   (select
      sum(isnull(d.vl_lancamento,0))
    from 
      conta_banco_lancamento d with (nolock) 
    where 
      d.cd_conta_banco = c.cd_conta_banco and
      d.cd_tipo_operacao = 1 and          
      d.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      isnull(d.ic_transferencia_conta,'N') = 'N' and
      cast(convert(int,d.dt_lancamento,103) as datetime) = cast(convert(int,@dt_base,103) as datetime)) as 'Credito',    
   (select 
      sum(isnull(d.vl_lancamento,0)) 
    from 
      conta_banco_lancamento d  with (nolock) 
    where 
      d.cd_conta_banco           = c.cd_conta_banco and
      d.cd_tipo_operacao         = 2 and          
      d.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      isnull(d.ic_transferencia_conta,'N') = 'S' and
      cast(convert(int,d.dt_lancamento,103) as datetime) = cast(convert(int,@dt_base,103) as datetime)) as 'TransfDebito',

   (select 
      sum(isnull(d.vl_lancamento,0))
    from 
      conta_banco_lancamento d with (nolock)  
    where 
      d.cd_conta_banco = c.cd_conta_banco and
      d.cd_tipo_operacao = 1 and          
      d.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      isnull(d.ic_transferencia_conta,'N') = 'S' and
      cast(convert(int,d.dt_lancamento,103) as datetime) = cast(convert(int,@dt_base,103) as datetime)) as 'TransfCredito'
  into
    #PosicaoSaldo    

  from
    Conta_Agencia_Banco c                   with (nolock) 
    left outer join #AuxDataSaldo a         with (nolock) on a.cd_conta_banco    = c.cd_conta_banco
    left outer join EGISADMIN.dbo.Empresa e with (nolock) on e.cd_empresa        = c.cd_empresa
    left outer join Banco b                 with (nolock) on b.cd_banco          = c.cd_banco
    left outer join Agencia_Banco ag        with (nolock) on ag.cd_banco         = c.cd_banco and
                                                             ag.cd_agencia_banco = c.cd_agencia_banco
  where
    isnull(c.ic_ativo_conta,'S') = 'S'
    and isnull(c.ic_fluxo_caixa_conta,'N') = 'S'

--select * from banco

  order by
    c.nm_conta_banco

  if @ic_saldo_total = 'N'
  begin

    select
      Banco,
      Agencia,
      Conta,
      Empresa,
      Limite,
      isnull(SaldoInicial,0)     as 'SaldoAtual',
      isnull(Debito,0)           as 'Debito',
      isnull(Credito,0)          as 'Credito',
      isnull(TransfDebito,0)     as 'TransfDebito',
      isnull(TransfCredito,0)    as 'TransfCredito',

      (isnull(SaldoInicial,0) +
       isnull(Debito,0) - 
       isnull(Credito,0) + 
       isnull(TransfDebito,0) -
       isnull(TransfCredito,0))  as 'SaldoInicial',

       case when isnull(SaldoInicial,0)<0 and isnull(Limite,0)>0 then
         Limite - ( SaldoInicial * -1 )
       else
         0.00 
       end                        as 'UsoLimite',

       (select sum(isnull(vl_saldo_documento,0))
       from
         documento_receber with (nolock) 
       where
         cd_conta_banco_remessa = cd_conta_banco and
         isnull(vl_saldo_documento,0)>0 ) as 'Cobranca'
     from
       #PosicaoSaldo

     where
       cd_conta_banco = case when @cd_conta_banco_aux = 0 then cd_conta_banco else @cd_conta_banco_aux end

     order by
       Banco,Conta

    end
      
  end

  --Mostra o Saldo


  if @ic_saldo_total = 'S'
  begin

   select
     sum(isnull(SaldoInicial,0))     as 'SaldoAtual'
   from
     #PosicaoSaldo
   where
     cd_conta_banco = case when @cd_conta_banco_aux = 0 then cd_conta_banco else @cd_conta_banco_aux end

  end

  --Retorno do Saldo


  if @ic_saldo_total = 'R'
  begin

   select
     @vl_retorno_saldo = sum(isnull(SaldoInicial,0))
   from
     #PosicaoSaldo
   where
     cd_conta_banco = case when @cd_conta_banco_aux = 0 then cd_conta_banco else @cd_conta_banco_aux end

  end




--select * from documento_receber

