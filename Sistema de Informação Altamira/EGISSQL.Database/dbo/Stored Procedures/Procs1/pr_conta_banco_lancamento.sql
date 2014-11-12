

create procedure pr_conta_banco_lancamento
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Elias Pereira da Silva
--                : Carlos Cardoso Fernandes

--Banco de Dados  : EgisSql
--Objetivo: Consultas Gerais do Conta Banco Movimento
--Data: 14/02/2003
--Atualizado: 26/03/2003 - Inclusão do Parâmetro 3 para trazer apenas o valor dos lctos pendentes
--                         Comentado filtro de data para os parâmetros 2 e 3 (Lctos Pendentes) - ELIAS
--            03/04/2003 - Acrscentado o campo de empresa - ELIAS 
--            29/04/2003 - Acertado a rotina de Listagem de Lançamentos Pendentes para trazer somente
--                         até a data atual - ELIAS	
--            21.12.2005 - Acerto do tipo de operação - Carlos Fernandes
--            12.01.2006 - Acerto da Sigla da Moeda Padrão da Conta p/ Saldo Anterior - Carlos Fernandes
--            08.11.2006 - Acerto na Busca do Saldo - Carlos Fernandes
--            04.12.2006 - Dados do Contas a Pagar/Receber - Carlos Fernandes
--            09.04.2007 - Acrescentando data final no filtro - Anderson
--            18.06.2007 - Verificação do Histórico do Lançamento - Carlos Fernandes
--            18.07.2007 - Acertos - Carlos Fernandes
--            09.10.2007 - Mostrar o Destinatário de Baixa de Empresa Diversa - Carlos Fernandes
--            17.10.2007 - Busca do Saldo Final Sintético - Carlos Fernandes
-- 21.11.2007 - Mostrar o usuário - Carlos Fernandes
-- 19.08.2008 - Data dos Lançamentos Pendentes - Carlos Fernandes
-- 05.02.2009 - Inclusão do Complemento Histórico - Carlos Fernandes
-- 17.06.2009 - Verificação do Saldo Inicial - Carlos Fernandes 
-- 22.10.2010 - Ajustes diversos - Carlos Fernandes
---------------------------------------------------------------------------------------------------------
@ic_parametro             int      = 0,
@dt_base                  datetime,
@cd_conta_banco           int      = 0,
@cd_tipo_lancamento_fluxo int      = 0,
@dt_inicial               datetime = '',
@dt_final                 datetime = '',
@cd_tipo_extrato          int      = 0, -- 0 = Completo - 1 = Conciliado - 2 = Não Conciliado
@cd_moeda                 int      = 0,
@ic_atualiza_saldo        int      = 0, -- Atualização do Saldo
@cd_usuario               int      = 0

as


  --select * from conta_banco_saldo
  --print @dt_base

  declare @cd_lancamento          int
  declare @vl_saldo_atual         numeric(25,2)
  declare @vl_debito              numeric(25,2)
  declare @vl_credito             numeric(25,2)
  declare @vl_limite              numeric(25,2)
  declare @dt_saldo_conta         datetime
  declare @sg_moeda               char(10)
  declare @vl_saldo               float
  declare @ic_fixo_saldo_banco    char(1) 
  declare @dt_primeiro_lancamento datetime
  declare @vl_saldo_auxiliar      numeric(25,2)
  declare @dt_inicio_anterior     datetime
  declare @dt_fim_anterior        datetime

  set @ic_fixo_saldo_banco = 'N'

  if @dt_final = ''
  begin
    set @dt_final = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
  end

  --select * from moeda
  --select * from conta_banco_lancamento
  --select * from conta_agencia_banco

  --Verifica a Moeda da Conta

  if @cd_conta_banco>0 
  begin
     select
       @sg_moeda = isnull(m.sg_moeda,'R$')
     from 
       Moeda m                                 with (nolock) 
       left outer join Conta_Agencia_Banco cab with (nolock) on cab.cd_moeda = m.cd_moeda
     where 
       @cd_conta_banco = cab.cd_conta_banco
     
  end

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- Lista o extrato bancário
-------------------------------------------------------------------------------
  begin


    -------------------------------------------------------------------------------
    --Verifica a Data Maior que existe para o Cadastro de Saldo Inicial da Conta   
    -------------------------------------------------------------------------------
    --Data do Saldo da Conta

    select top 1
       @dt_saldo_conta      = max(dt_saldo_conta_banco),
       @ic_fixo_saldo_banco = max(isnull(ic_fixo_saldo_banco,'N'))
    from 
      dbo.Conta_Banco_Saldo with (nolock) 
     where 
           dt_saldo_conta_banco    <= @dt_base        and
           cd_conta_banco           = @cd_conta_banco and
           cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo 
     group by 
           dt_saldo_conta_banco
     order by
        dt_saldo_conta_banco desc

    -------------------------------------------------------------------------------
    --Caso não exista Lançamento de Saldo Inicial busca a Data do 1o. Lan/camento
    -------------------------------------------------------------------------------

    if @dt_saldo_conta is null
    begin
      set @dt_saldo_conta = isnull((select min(l.dt_lancamento) 
                            from 
                              conta_banco_lancamento l with (nolock) 
                            where
                              l.cd_conta_banco = @cd_conta_banco),@dt_base) 

    end

    -------------------------------------------------------------------------------
    -- carrega o saldo inicial
    -------------------------------------------------------------------------------

    set @vl_saldo_atual = dbo.fn_getsaldo_ant_cb(@dt_base+1,@cd_conta_banco,null,@cd_tipo_lancamento_fluxo)

    --select @vl_saldo_atual,@dt_saldo_conta

    -------------------------------------------------------------------------------
    -- carrega o limite atual da conta
    -------------------------------------------------------------------------------
    
    select 
      @vl_limite = isnull(vl_limite_conta_banco,0)
    from 
      conta_agencia_banco with (nolock) 
    where
      cd_conta_banco = @cd_conta_banco

    -------------------------------------------------------------------------------
    --Lançamentos no Período Selecionado
    -------------------------------------------------------------------------------

    select
      l.cd_lancamento,
      l.dt_lancamento,
      e.nm_empresa,
      p.cd_mascara_plano_financeiro+' - '+p.nm_conta_plano_financeiro as 'nm_conta_plano_financeiro',
      --select * from conta_banco_lancamento

      rtrim(ltrim(case when isnull(l.nm_historico_lancamento,'')='' and l.cd_historico_financeiro>0
      then
         hf.nm_historico_financeiro
      else
         l.nm_historico_lancamento
      end 
      + ' ' + l.nm_compl_lancamento))                                 as nm_historico_lancamento,

      case when l.cd_tipo_operacao = 2 then cast(l.vl_lancamento  as numeric(25,2)) else 0 end as 'vl_debito',
      case when l.cd_tipo_operacao = 1 then cast(l.vl_lancamento  as numeric(25,2)) else 0 end as 'vl_credito',
      cast(0.00 as numeric(25,2)) as 'vl_saldo_atual',
      IsNull(@vl_limite,0)        as 'vl_limite',
      cast(0.00 as numeric(25,2)) as 'vl_disponivel',
      m.sg_moeda,
      case 
        when l.ic_lancamento_conciliado='S' then 1 else 0 end as Sel,
      l.ic_lancamento_conciliado,
      l.cd_conta_banco,
      l.cd_plano_financeiro,
      l.cd_tipo_operacao,
      l.cd_tipo_lancamento_fluxo,
      hf.nm_historico_financeiro,
      l.cd_documento,
      u.nm_fantasia_usuario,
      l.nm_compl_lancamento

    into
      #conta_banco_lancamento

    from
      conta_banco_lancamento l                 with (nolock) 
      left outer join  plano_financeiro p      with (nolock) on  p.cd_plano_financeiro      = l.cd_plano_financeiro
      left outer join  moeda m                 with (nolock) on  m.cd_moeda                 = l.cd_moeda
      left outer join  historico_financeiro hf with (nolock) on  hf.cd_historico_financeiro = l.cd_historico_financeiro
      left outer join  EgisAdmin.dbo.Empresa e with (nolock) on  e.cd_empresa               = l.cd_empresa
      left outer join  EgisAdmin.dbo.Usuario u with (nolock) on  u.cd_usuario               = l.cd_usuario

    where
      l.cd_conta_banco           = @cd_conta_banco and
      l.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      cast(convert(int,l.dt_lancamento,103) as datetime) >= cast(convert(int,@dt_base,103) as datetime) and   
      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,@dt_final,103) as datetime) and
      isnull(l.ic_lancamento_conciliado,'N')
      = case
          when @cd_tipo_extrato = 0 then isnull(l.ic_lancamento_conciliado,'N')
          when @cd_tipo_extrato = 1 then 'S'
          when @cd_tipo_extrato = 2 then 'N'
      end
    order by
      l.cd_conta_banco,
      l.dt_lancamento,
      l.cd_lancamento

    --Data do 1o. Lançamento

    select 
      top 1 
      @dt_primeiro_lancamento = dt_lancamento
    from
      #conta_banco_lancamento
    order by
      dt_lancamento

    --select @dt_primeiro_lancamento

    -------------------------------------------------------------------------------
    -- inserindo o saldo anterior
    -------------------------------------------------------------------------------

    -------------------------------------------------------------------------------
    --Processar o Saldo até a Data Inicial
    -------------------------------------------------------------------------------
    set @vl_saldo_auxiliar    = @vl_saldo_atual

--    select @vl_saldo_auxiliar

    set @vl_saldo = 0.00

    --select * from conta_banco_saldo

    select
      top 1
      @vl_saldo = isnull(vl_saldo_final_conta_banco,0)

    from 
      dbo.Conta_Banco_Saldo with (nolock) 
     where 
        --dt_saldo_conta_banco     = @dt_base-1      and
        dt_saldo_conta_banco     <= @dt_base       and
        cd_conta_banco           = @cd_conta_banco and
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo 
 
    order by
       dt_saldo_conta_banco desc

    --select @vl_saldo,@dt_saldo_conta,@dt_base,@vl_saldo_atual, cast(convert(int,@dt_base-1,103)as datetime)
    --select @dt_saldo_conta,@dt_base,@dt_primeiro_lancamento,cast(convert(int,@dt_base-1,103)as datetime)

    -------------------------------------------------------------------------------
    --Lançamentos para Composição do Saldo 
    -------------------------------------------------------------------------------
    --select @dt_base,@dt_final,@dt_saldo_conta,cast((@dt_base-@dt_saldo_conta) as int )

    if isnull(@vl_saldo,0)=0 or (@dt_base-@dt_saldo_conta)>2
    begin

      select @vl_saldo = isnull(( sum(case when l.cd_tipo_operacao = 2 --Débito
                                         then cast(l.vl_lancamento  as numeric(25,2)) * - 1 
                                         else cast(l.vl_lancamento  as numeric(25,2)) end)),0) 

      from
        conta_banco_lancamento l with (nolock) 
      where
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
        l.cd_conta_banco         = @cd_conta_banco and
        cast(convert(int,l.dt_lancamento,103) as datetime) between cast(convert(int,@dt_saldo_conta,103) as datetime) and
                                                                   cast(convert(int,@dt_base-1,103)      as datetime) and   
      isnull(l.ic_lancamento_conciliado,'N')
      = case
          when @cd_tipo_extrato = 0 then isnull(l.ic_lancamento_conciliado,'N')
          when @cd_tipo_extrato = 1 then 'S'
          when @cd_tipo_extrato = 2 then 'N'
      end

      set @vl_saldo_atual = @vl_saldo_atual + @vl_saldo


--Mostra a tabela para achar diferenças
--       select 
--         cast(round(vl_lancamento,2) as numeric(25,2)) as vl_lancamento,
--         *
--       from
--         conta_banco_lancamento l with (nolock) 
--       where
--         cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
--         l.cd_conta_banco         = @cd_conta_banco and
--         cast(convert(int,l.dt_lancamento,103) as datetime) between cast(convert(int,@dt_saldo_conta,103) as datetime) and
--                                                                    cast(convert(int,@dt_base-1,103)      as datetime) and   
--       isnull(l.ic_lancamento_conciliado,'N')
--       = case
--           when @cd_tipo_extrato = 0 then isnull(l.ic_lancamento_conciliado,'N')
--           when @cd_tipo_extrato = 1 then 'S'
--           when @cd_tipo_extrato = 2 then 'N'
--       end
-- 
--       order by
--         l.dt_lancamento

      -- select @vl_saldo_atual,@vl_saldo

    end

--    select @vl_saldo_atual

    
    set @dt_saldo_conta = @dt_base - 1

    insert into
      #conta_banco_lancamento
    values
      (0,
       isnull(@dt_saldo_conta,@dt_base - 1),
       null,
       null,
       'Saldo Anterior',
       0,
       0,
       @vl_saldo_atual,
       IsNull(@vl_limite,0),
       IsNull(@vl_saldo_atual,0) + IsNull(@vl_limite,0),
       @sg_moeda,         --'R$',
       0,
       '0',
       0,
       0,
       0,
       0,
       '',
       0,
       '',
       '')
       
    declare cCursor cursor for

    select 
      cd_lancamento
    from
      #conta_banco_lancamento
    order by
      cd_conta_banco,
      dt_lancamento,
      cd_lancamento
    
    open cCursor

    fetch next from cCursor into @cd_lancamento

    while (@@FETCH_STATUS = 0)
      begin

        select
          @vl_debito  = isnull(vl_debito,0),
          @vl_credito = isnull(vl_credito,0)
        from
          #conta_banco_lancamento
        where
          cd_lancamento = @cd_lancamento

        set @vl_saldo_atual = IsNull(@vl_saldo_atual,0) - IsNull(@vl_debito,0) + IsNull(@vl_credito,0)

        update
          #conta_banco_lancamento
        set
          vl_saldo_atual = IsNull(@vl_saldo_atual,0),
          vl_disponivel  = IsNull(@vl_saldo_atual,0) + IsNull(@vl_limite,0)
        where
          cd_lancamento = @cd_lancamento

        fetch next from cCursor into @cd_lancamento

      end

    close cCursor
    deallocate cCursor

    --Mostra a Tabela para Consulta 

    if @ic_parametro = 1
    begin

      select
        cbl.*,
        isnull(dr.cd_nota_saida,dp.cd_nota_fiscal_entrada)     as Documento,
        
        case when isnull(c.nm_fantasia_cliente,'')  <>''  then c.nm_fantasia_cliente
             when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))  
             when (isnull(dp.cd_contrato_pagar, 0)  <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))  
             when (isnull(dp.cd_funcionario, 0)     <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))  
             when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))    
        end                                                    as 'RazaoSocial',
    
        case when isnull(dr.cd_documento_receber,0)>0 then
           dr.cd_identificacao
        else
          case when isnull(dp.cd_documento_pagar,0)>0 then
            dp.cd_identificacao_document
          else
            ''
          end
        end                                                    as 'Identificacao'

      from 
        #conta_banco_lancamento cbl          with (nolock) 
        left outer join documento_receber dr with (nolock) on dr.cd_documento_receber = cbl.cd_documento and
                                                              isnull(cbl.vl_credito,0)>0

        left outer join cliente c            with (nolock) on c.cd_cliente          = dr.cd_cliente

        left outer join documento_pagar dp   with (nolock) on dp.cd_documento_pagar = cbl.cd_documento and
                                                              isnull(cbl.vl_debito,0)>0

        left outer join fornecedor f         with (nolock) on f.cd_fornecedor = dp.cd_fornecedor
        
       order by
        cbl.cd_conta_banco,
        cbl.dt_lancamento,
        cbl.cd_lancamento

     end

     --select * from #conta_banco_lancamento 
    
--     set @ic_parametro = 4

  end

--select * from conta_banco_lancamento
--select * from documento_receber
--select * from documento_pagar


else

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Lançamentos Pendentes
-------------------------------------------------------------------------------
  begin

    select     
      l.dt_lancamento 		as 'Data', 
      l.nm_historico_lancamento as 'Historico', 
      l.vl_lancamento 		as 'Valor', 
      t.sg_tipo_operacao 	as 'Tipo',
      l.cd_tipo_operacao 	as 'CodTipo'
    from         
      Conta_Banco_Lancamento l   with (nolock) 
    inner join
      Tipo_Operacao_Financeira t with (nolock) 
    on 
      l.cd_tipo_operacao = t.cd_tipo_operacao
    where
      isnull(l.ic_lancamento_conciliado,'N') = 'N' and
      l.cd_conta_banco           = @cd_conta_banco and
      l.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
--      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,getDate(),103) as datetime) -- 29/04/2003
      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,@dt_final,103) as datetime) -- 29/04/2003
  
    order by
      l.dt_lancamento

  end

else

-------------------------------------------------------------------------------
if @ic_parametro = 3   -- Total dos Lançamentos Pendentes (GERAL)
-------------------------------------------------------------------------------
  begin

    declare @dt_hoje               datetime
    declare @dt_ultima_conciliacao datetime

    declare @vl_ultimo_saldo_conciliado decimal(25,2)

--    set @dt_hoje = getdate()
    set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

    --Busca a Data do último lançamento no movimento bancário CONCILIADO e soma mais 1 dia

    select 
      @dt_ultima_conciliacao = max(dt_lancamento) + 1
    from
      conta_banco_lancamento l with (nolock) 
    where
      isnull(ic_lancamento_conciliado,'N')='S' and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      l.cd_conta_banco         = @cd_conta_banco and
      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,@dt_final,103) as datetime)  

--    select @dt_ultima_conciliacao

      exec pr_saldo_sintetico_movimento_banco  9, 
                                               @dt_ultima_conciliacao,
                                               @cd_conta_banco,
                                               @cd_tipo_lancamento_fluxo,
                                               @dt_ultima_conciliacao,
                                               @dt_ultima_conciliacao,
                                               0, 
                                               1,
                                               0,
                                               @cd_usuario,
                                               @vl_saldo_atual_retorno = @vl_ultimo_saldo_conciliado output

--   select @vl_ultimo_saldo_conciliado
     

    -- Saldo imediatamente anterior registrado na tabela de
    -- Saldos - ELIAS 03/04/2003

    declare @dt_saldo_conta_banco datetime

    -- A soma do máximo da data + 1 é necessária porque no 
    -- getSaldo_Ant_Cb é feito um decremento na data para buscar o 
    -- Saldo Anterior, no caso precisamos do saldo Atual - ELIAS 03/04/2003

    select 
      @dt_saldo_conta_banco = max(dt_saldo_conta_banco)+1 
    from 
      conta_banco_saldo with (nolock) 
    where
      cd_conta_banco           = @cd_conta_banco and
      cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo
      
    set @vl_saldo_atual = dbo.fn_getsaldo_ant_cb(cast(convert(int,getDate(),103) as datetime)+1,@cd_conta_banco,null,@cd_tipo_lancamento_fluxo)

    --Atualiza o Saldo Anterior

    set @vl_saldo = 0.00

    select @vl_saldo = isnull(vl_saldo_final_conta_banco,0)
    from 
      dbo.Conta_Banco_Saldo with (nolock) 
     where 
        dt_saldo_conta_banco     = @dt_base-1      and
        cd_conta_banco           = @cd_conta_banco and
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo 
 
--   select @vl_saldo,@dt_saldo_conta,@dt_base

    if isnull(@vl_saldo,0)=0
    begin
      select @vl_saldo = isnull(( sum(case when l.cd_tipo_operacao = 2 
                                         then cast(l.vl_lancamento  as numeric(25,2)) * - 1 
                                         else cast(l.vl_lancamento  as numeric(25,2)) end)),0)
      from
        conta_banco_lancamento l with (nolock) 
      where
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
        l.cd_conta_banco         = @cd_conta_banco and
        cast(convert(int,l.dt_lancamento,103) as datetime) between cast(convert(int,@dt_saldo_conta_banco,103) as datetime) and
                                                                   cast(convert(int,@dt_base-1,103)      as datetime) and   
        isnull(l.ic_lancamento_conciliado,'N')
        = case
                                       when @cd_tipo_extrato = 0 then isnull(l.ic_lancamento_conciliado,'N')
                                       when @cd_tipo_extrato = 1 then 'S'
                                       when @cd_tipo_extrato = 2 then 'N'
                                     end

      set @vl_saldo_atual = @vl_saldo_atual + @vl_saldo

--      select @vl_saldo_atual,@vl_saldo

    end

    select

      case when (t.cd_tipo_operacao = 1) then
        isnull(l.vl_lancamento,0)
      else
        0 
      end as 'Credito',

      case when (t.cd_tipo_operacao = 2) then
        isnull(l.vl_lancamento,0)
      else
        0
      end as 'Debito'
    into
      #LctoPendente
    from         
      Conta_Banco_Lancamento l   with (nolock) 
    inner join
      Tipo_Operacao_Financeira t with (nolock) 
    on 
      l.cd_tipo_operacao = t.cd_tipo_operacao
    where
      isnull(l.ic_lancamento_conciliado,'N') = 'N' and
      l.cd_conta_banco           = @cd_conta_banco and
      l.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
--      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,getDate(),103) as datetime)  -- 29/04/2003
      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,@dt_final,103) as datetime)  -- 29/04/2003

    select
--      isnull(@vl_saldo_atual,0)                                                  as 'SaldoEmpresa',
      @vl_ultimo_saldo_conciliado                                                as 'SaldoEmpresa',
      sum(isnull(Credito,0)) - sum(isnull(Debito,0))                             as 'LctoPendente',
      isnull(@vl_ultimo_saldo_conciliado,0) + isnull(sum(Credito),0) - isnull(sum(Debito),0) as 'SaldoBanco'
--     @vl_ultimo_saldo_conciliado                                                as 'SaldoBanco'
    from
      #LctoPendente

  end

else

--Tabela Sintética com o Último Saldo 

if @ic_parametro = 9
begin
   
    --Data do Saldo da Conta

    select top 1 @dt_saldo_conta = max(dt_saldo_conta_banco)
    from 
      dbo.Conta_Banco_Saldo with (nolock)
     where 
           dt_saldo_conta_banco    <= @dt_base        and
           cd_conta_banco           = @cd_conta_banco and
           cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo 
     group by 
           dt_saldo_conta_banco
     order by
        dt_saldo_conta_banco desc

    if @dt_saldo_conta is null
    begin
      set @dt_saldo_conta = isnull((select min(l.dt_lancamento) 
                            from 
                              conta_banco_lancamento l with (nolock) 
                            where
                              l.cd_conta_banco = @cd_conta_banco),@dt_base) 

    end

    -- carrega o saldo inicial

    set @vl_saldo_atual = dbo.fn_getsaldo_ant_cb(@dt_base+1,@cd_conta_banco,null,@cd_tipo_lancamento_fluxo)

    -- carrega o limite atual da conta
    
    select 
      @vl_limite = isnull(vl_limite_conta_banco,0)
    from 
      conta_agencia_banco with (nolock) 
    where
      cd_conta_banco = @cd_conta_banco

    select
      l.cd_lancamento,
      l.dt_lancamento,
      e.nm_empresa,
      p.cd_mascara_plano_financeiro+' - '+p.nm_conta_plano_financeiro as 'nm_conta_plano_financeiro',
      --select * from conta_banco_lancamento
      case when isnull(l.nm_historico_lancamento,'')='' and l.cd_historico_financeiro>0
      then
         hf.nm_historico_financeiro
      else
         l.nm_historico_lancamento
      end                                                             as nm_historico_lancamento,

      case when l.cd_tipo_operacao = 2 then cast(l.vl_lancamento  as numeric(25,2)) else 0 end as 'vl_debito',
      case when l.cd_tipo_operacao = 1 then cast(l.vl_lancamento  as numeric(25,2)) else 0 end as 'vl_credito',
      cast(null as numeric(25,2)) as 'vl_saldo_atual',
      IsNull(@vl_limite,0)        as 'vl_limite',
      cast(null as numeric(25,2)) as 'vl_disponivel',
      m.sg_moeda,
      case 
        when l.ic_lancamento_conciliado='S' then 1 else 0 end as Sel,
      l.ic_lancamento_conciliado,
      l.cd_conta_banco,
      l.cd_plano_financeiro,
      l.cd_tipo_operacao,
      l.cd_tipo_lancamento_fluxo,
      hf.nm_historico_financeiro,
      l.cd_documento,
      l.nm_compl_lancamento
    into
      #conta_banco_lancamento_saldo

    from
      conta_banco_lancamento l                 with (nolock)
      left outer join  plano_financeiro p      on  p.cd_plano_financeiro      = l.cd_plano_financeiro
      left outer join  moeda m                 on  m.cd_moeda                 = l.cd_moeda
      left outer join  historico_financeiro hf on  hf.cd_historico_financeiro = l.cd_historico_financeiro
      left outer join  EgisAdmin.dbo.Empresa e on  e.cd_empresa               = l.cd_empresa
    where
      l.cd_conta_banco           = @cd_conta_banco and
      l.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      cast(convert(int,l.dt_lancamento,103) as datetime) >= cast(convert(int,@dt_base,103) as datetime) and   
      cast(convert(int,l.dt_lancamento,103) as datetime) <= cast(convert(int,@dt_final,103) as datetime) and
      l.ic_lancamento_conciliado = case
                                     when @cd_tipo_extrato = 0 then l.ic_lancamento_conciliado
                                     when @cd_tipo_extrato = 1 then 'S'
                                     when @cd_tipo_extrato = 2 then 'N'
                                   end
    order by
      l.cd_conta_banco,
      l.dt_lancamento,
      l.cd_lancamento

    -- inserindo o saldo anterior

    --Processar o Saldo até a Data Inicial
    
    set @vl_saldo = 0.00

    select @vl_saldo = isnull(vl_saldo_final_conta_banco,0)
    from 
      dbo.Conta_Banco_Saldo with (nolock)  
     where 
        dt_saldo_conta_banco     = @dt_base-1      and
        cd_conta_banco           = @cd_conta_banco and
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo 
 

    if isnull(@vl_saldo,0)=0
    begin
      select @vl_saldo = isnull(( sum(case when l.cd_tipo_operacao = 2 
                                         then cast(l.vl_lancamento  as numeric(25,2)) * - 1 
                                         else cast(l.vl_lancamento  as numeric(25,2)) end)),0)
      from
        conta_banco_lancamento l with (nolock) 
      where
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
        l.cd_conta_banco         = @cd_conta_banco and
        cast(convert(int,l.dt_lancamento,103) as datetime) between cast(convert(int,@dt_saldo_conta,103) as datetime) and
                                                                   cast(convert(int,@dt_base-1,103)      as datetime) and   
        l.ic_lancamento_conciliado = case
                                       when @cd_tipo_extrato = 0 then l.ic_lancamento_conciliado
                                       when @cd_tipo_extrato = 1 then 'S'
                                       when @cd_tipo_extrato = 2 then 'N'
                                     end

      set @vl_saldo_atual = @vl_saldo_atual + @vl_saldo

      -- select @vl_saldo_atual,@vl_saldo

    end

    set @dt_saldo_conta = @dt_base - 1

    insert into
      #conta_banco_lancamento_saldo
    values
      (0,
       isnull(@dt_saldo_conta,@dt_base - 1),
       null,
       null,
       'Saldo Anterior',
       0,
       0,
       @vl_saldo_atual,
       IsNull(@vl_limite,0),
       IsNull(@vl_saldo_atual,0) + IsNull(@vl_limite,0),
       @sg_moeda,         --'R$',
       0,
       '0',
       0,
       0,
       0,
       0,
       '',
       0,
       '')
       
    declare cCursorSaldo cursor for

    select 
      cd_lancamento
    from
      #conta_banco_lancamento_saldo
    order by
      cd_conta_banco,
      dt_lancamento,
      cd_lancamento
    
    open cCursorSaldo

    fetch next from cCursorSaldo into @cd_lancamento

    while (@@FETCH_STATUS = 0)
      begin

        select
          @vl_debito  = isnull(vl_debito,0),
          @vl_credito = isnull(vl_credito,0)
        from
          #conta_banco_lancamento_saldo
        where
          cd_lancamento = @cd_lancamento

        set @vl_saldo_atual = IsNull(@vl_saldo_atual,0) - IsNull(@vl_debito,0) + IsNull(@vl_credito,0)

        update
          #conta_banco_lancamento_saldo
        set
          vl_saldo_atual = IsNull(@vl_saldo_atual,0),
          vl_disponivel  = IsNull(@vl_saldo_atual,0) + IsNull(@vl_limite,0)
        where
          cd_lancamento = @cd_lancamento

        fetch next from cCursorSaldo into @cd_lancamento

      end

    close cCursorSaldo
    deallocate cCursorSaldo

    select
      @vl_saldo_atual = isnull(vl_saldo_atual,0)
    from 
      #conta_banco_lancamento_saldo cbl       
        
    order by
       cbl.cd_conta_banco,
       cbl.dt_lancamento,
       cbl.cd_lancamento

    --Mostra a Tabela para Consulta 

    select 
      @cd_conta_banco as cd_conta_banco,
      @vl_saldo_atual as vl_saldo_atual    

     --select * from #conta_banco_lancamento 
    
--     set @ic_parametro = 4

  end


