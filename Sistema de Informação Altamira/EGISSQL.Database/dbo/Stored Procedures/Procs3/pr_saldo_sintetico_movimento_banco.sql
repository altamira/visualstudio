
-------------------------------------------------------------------------------
--sp_helptext pr_saldo_sintetico_movimento_banco
-------------------------------------------------------------------------------
--pr_saldo_sintetico_movimento_banco
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Busca do Saldo Analítico do Movimento Bancário
--Data             : 17.10.2007
--Alteração        : 10.11.2008 - Verificação Geral - Carlos Fernandes
--                   11.09.2010 - Ajustes Diversos - Carlos / Márcio Martins
------------------------------------------------------------------------------
create procedure pr_saldo_sintetico_movimento_banco
@ic_parametro             int,
@dt_base                  datetime,
@cd_conta_banco           int,
@cd_tipo_lancamento_fluxo int,
@dt_inicial               datetime = '',
@dt_final                 datetime = '',
@cd_tipo_extrato          int      = 0, -- 0 = Completo - 1 = Conciliado - 2 = Não Conciliado
@cd_moeda                 int      = 0,
@ic_atualiza_saldo        int      = 0, -- Atualização do Saldo
@cd_usuario               int      = 0,
@vl_saldo_atual_retorno   decimal(25,2) output

as

  --print @dt_base

  declare @cd_lancamento  int
  declare @vl_saldo_atual numeric(25,2)
  declare @vl_debito      numeric(25,2)
  declare @vl_credito     numeric(25,2)
  declare @vl_limite      numeric(25,2)
  declare @dt_saldo_conta datetime
  declare @sg_moeda       char(10)
  declare @vl_saldo       float

  if @dt_final = ''
  begin
    set @dt_final = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
  end

  --select * from moeda
  --select * from conta_banco_lancamento
  --select * from conta_agencia_banco

  if @cd_conta_banco>0 
  begin
     select @sg_moeda = isnull(m.sg_moeda,'R$')
     from 
       Moeda m with (nolock) 
       left outer join Conta_Agencia_Banco cab on cab.cd_moeda = m.cd_moeda
     where 
       @cd_conta_banco = cab.cd_conta_banco
     
  end

--------------------------------------------------------------------------------------------
--Tabela Sintética com o Último Saldo 
--------------------------------------------------------------------------------------------

if @ic_parametro = 9
begin
   
    --Data do Saldo da Conta

    select top 1 @dt_saldo_conta = max(dt_saldo_conta_banco)
    from 
      dbo.Conta_Banco_Saldo with (nolock) 
     where 
           dt_saldo_conta_banco    < @dt_base        and
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
         isnull(hf.nm_historico_financeiro,'')
      else
         isnull(l.nm_historico_lancamento,'')
      end                                                             as nm_historico_lancamento,

      case when l.cd_tipo_operacao = 2 then cast(isnull(l.vl_lancamento,0)  as numeric(25,2)) else 0 end as 'vl_debito',
      case when l.cd_tipo_operacao = 1 then cast(isnull(l.vl_lancamento,0)  as numeric(25,2)) else 0 end as 'vl_credito',
      cast(null as numeric(25,2)) as 'vl_saldo_atual',
      IsNull(@vl_limite,0)        as 'vl_limite',
      cast(null as numeric(25,2)) as 'vl_disponivel',
      m.sg_moeda,
      case 
        when isnull(l.ic_lancamento_conciliado,'N')='S' then 1 else 0 end as Sel,
      l.ic_lancamento_conciliado,
      l.cd_conta_banco,
      l.cd_plano_financeiro,
      l.cd_tipo_operacao,
      l.cd_tipo_lancamento_fluxo,
      hf.nm_historico_financeiro,
      l.cd_documento
    into
      #conta_banco_lancamento_saldo

    from
      conta_banco_lancamento l                 with (nolock) 
      left outer join  plano_financeiro p      with (nolock) on  p.cd_plano_financeiro      = l.cd_plano_financeiro
      left outer join  moeda m                 with (nolock) on  m.cd_moeda                 = l.cd_moeda
      left outer join  historico_financeiro hf with (nolock) on  hf.cd_historico_financeiro = l.cd_historico_financeiro
      left outer join  EgisAdmin.dbo.Empresa e with (nolock) on  e.cd_empresa               = l.cd_empresa
    where
      l.cd_conta_banco           = @cd_conta_banco and
      l.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
      cast(convert(int,l.dt_lancamento,103) as datetime) > cast(convert(int,@dt_base,103)  as datetime) and   
      cast(convert(int,l.dt_lancamento,103) as datetime) < cast(convert(int,@dt_final,103) as datetime) and
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
                                         then cast(isnull(l.vl_lancamento,0)  as numeric(25,2)) * - 1 
                                         else cast(isnull(l.vl_lancamento,0)  as numeric(25,2)) end)),0)
      from
        conta_banco_lancamento l with (nolock) 
      where
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
        l.cd_conta_banco         = @cd_conta_banco and
        --> Alterado: 11.09.2010, foi colocado +1
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
       0)
       
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

--     select
--       cbl.*
--     from 
--       #conta_banco_lancamento_saldo cbl       
--         
--     order by
--        cbl.cd_conta_banco,
--        cbl.dt_lancamento,
--        cbl.cd_lancamento

   --Atualiza o Saldo de Retonro da Procedure

   select @vl_saldo_atual_retorno = @vl_saldo_atual

     --select * from #conta_banco_lancamento 
    
--     set @ic_parametro = 4

  end


