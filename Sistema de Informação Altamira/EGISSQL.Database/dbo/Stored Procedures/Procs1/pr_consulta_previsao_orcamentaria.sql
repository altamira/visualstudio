
CREATE PROCEDURE pr_consulta_previsao_orcamentaria

--------------------------------------------------------------------------------------------
--sp_helptext pr_consulta_previsao_orcamentaria
--------------------------------------------------------------------------------------------
--GBS - Global Business Solution               2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s)        : Anderson Messias da Silva
--Banco de Dados  : EGISSQL
--Objetivo        : Consultar Documentos a Receber e a Pagar de uma só vez.
--Data            : 12/02/2007
--                : 28.03.2007 - Acertos Diversos - Carlos Fernandes
--                               Documentos não pagos menor que a data de Hoje não entra 
--                               na Previsão
--                : 16.04.2007 - Montagem de uma Tabela Temporária com Saldos
--                               Deleção dos Pagamentos que estão no movimento Bancário - Carlos Fernandes
--                : 21.04.2007 - Busca dos Saldos Inicias do Movimento Bancário
--                : 19.07.2007 - Verificação - Carlos Fernandes
--                : 25.07.2007 - Saldo Inicial - Carlos Fernandes
--                : 17.10.2007 - Ajustes de Saldos - Carlos Fernandes
-- 14.01.2008 - Acerto do Desconto do Documento a Receber - Carlos Fernandes
----------------------------------------------------------------------------------------------------------

@dt_inicial    datetime = '',
@dt_final      datetime = '',
@dt_inicio_mes datetime = '',
@cd_usuario    int      = 0

--with recompile  

as  
  
declare @dt_base                  datetime  
declare @cd_tipo_lancamento_fluxo int  
declare @dt_saldo_conta           datetime  
declare @dt_inicio_movimento      datetime
  
set @dt_base                  = getdate() --Data de Hoje  
set @cd_tipo_lancamento_fluxo = 2         --Realizado  


--Início do Movimento

set @dt_inicio_movimento = @dt_inicial

----------------------------------------------------------------------------------------------------------
--Verifica se a Data Inicial é dia primeiro
--Trecho abaixo é responsável pela composição do Saldo no meio do período
--
----------------------------------------------------------------------------------------------------------
if day(@dt_inicial)>1 
begin

  set @dt_inicial = @dt_inicio_mes

--    set @dt_inicial          = cast( cast(month(@dt_inicio_movimento) as varchar(2))+'/'+
--                                     '01/'+
--                                     cast(year(@dt_inicio_movimento)  as varchar(4)) as datetime )

  --select @dt_inicial
  --print @dt_inicial

end
  
--select * from documento_pagar_pagamento  
  
  select  
    *  
  into  
    #Documento  
  from  
    (  
     -- Contas a Pagar  
     select  
       p.nm_portador                             as Portador,  
       'CP'                                      as ic_tipo,   
       d.cd_identificacao_document               as Documento,  
       d.dt_emissao_documento_paga               as Emissao,  
       case when dp.dt_pagamento_documento is null or d.dt_vencimento_documento>dp.dt_pagamento_documento   
       then  
         d.dt_vencimento_documento  
       else  
         dp.dt_pagamento_documento end           as Vencimento,  
      (cast(str(d.vl_documento_pagar,25,2)       as decimal(25,2)) * -1) as 'vl_saldo_documento',  
       case when (isnull(d.cd_empresa_diversa    , 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
            when (isnull(d.cd_contrato_pagar     , 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
            when (isnull(d.cd_funcionario        , 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
            when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
       end                                       as 'nm_fantasia_destinatario',  
       t.nm_tipo_documento                       as Tipo,  
       d.nm_observacao_documento                 as Obsevacao,  
       tcp.nm_tipo_conta_pagar                   as TipoConta,  
       cab.cd_banco                              as Banco,  
       cab.nm_conta_banco                        as ContaBanco,  
       dp.dt_pagamento_documento                 as DataPagamento,
       d.cd_documento_pagar                      as cd_documento  
     from  
       Documento_Pagar d   with (nolock) 
       left outer join Fornecedor_Contato f         on d.nm_fantasia_fornecedor = f.nm_fantasia_fornecedor and   
                                                       f.cd_contato_fornecedor  = 1   
       left outer join Tipo_documento t             on t.cd_tipo_documento      = d.cd_tipo_documento   
       left outer join Portador p                   on p.cd_portador            = d.cd_portador   
       left outer join Tipo_Conta_Pagar tcp         on tcp.cd_tipo_conta_pagar  = d.cd_tipo_conta_pagar  
       left outer join Documento_Pagar_Pagamento dp on dp.cd_documento_pagar    = d.cd_documento_pagar   
       left outer join Conta_Agencia_Banco cab      on cab.cd_conta_banco       = dp.cd_conta_banco   
     where  
       d.dt_vencimento_documento between @dt_inicial and @dt_final and   
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final)) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento    > @dt_final)) 

   ) s1   
  
   union  
  
   (  
  
     -- Contas a Receber  
  
     select   
       p.nm_portador                               as Portador,  
       'CR'                                        as ic_tipo,  
       d.cd_identificacao                          as Documento,  
       d.dt_emissao_documento                      as Emissao,  
       case when dp.dt_pagamento_documento is null or d.dt_vencimento_documento>dp.dt_pagamento_documento   
       then  
         case when drd.dt_desconto_documento is null then
           d.dt_vencimento_documento                 
         else
           drd.dt_desconto_documento
         end
       else   
         dp.dt_pagamento_documento
       end                                         as Vencimento,  
       cast(str(d.vl_documento_receber,25,2)       as decimal(25,2))
                                                   as 'vl_saldo_documento',  
       vw.nm_fantasia                              as 'nm_fantasia_destinatario',  
       tp.nm_tipo_documento                        as Tipo,  
       cast(d.ds_documento_receber as varchar(40)) as Obsevacao,  
       'Faturamento'                               as TipoConta,  
       cab.cd_banco                                as Banco,  
       cab.nm_conta_banco                          as ContaBanco,  
       dp.dt_pagamento_documento                   as DataPagamento,  
       d.cd_documento_receber                      as cd_documento    
     from  
       documento_receber d   with (nolock) 
       inner join vw_destinatario_rapida vw           on d.cd_cliente            = vw.cd_destinatario and  
                                                         d.cd_tipo_destinatario  = vw.cd_tipo_destinatario   
       left outer join Tipo_Documento tp              on tp.cd_tipo_documento    = d.cd_tipo_documento   
       left outer join Portador p                     on p.cd_portador           = d.cd_portador   
       left outer join Documento_Receber_Pagamento dp on dp.cd_documento_receber = d.cd_documento_receber   
       left outer join Conta_Agencia_Banco cab        on cab.cd_conta_banco      = dp.cd_conta_banco   
       left outer join Documento_Receber_Desconto drd on drd.cd_documento_receber = d.cd_documento_receber and
                                                         drd.dt_desconto_documento between @dt_inicial and @dt_final 

    where   
       d.dt_vencimento_documento between @dt_inicial and @dt_final and  
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final)) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento > @dt_final))      
    )  
  
  order by  
    5 asc  

  
--------------------------------------------------------------------------------------------  
-- Verifica todos os Documentos a Receber que não foram pagos menor que a Data Base  
--------------------------------------------------------------------------------------------  
delete from #Documento where ic_tipo = 'CR'        and   
                             DataPagamento is null and  
                             Vencimento < @dt_base   


--------------------------------------------------------------------------------------------  
-- Verifica todos os Documentos a Receber que já estão no Movimento Bancário
--------------------------------------------------------------------------------------------  
--select * from documento_pagar
--select * from documento_receber
--select * from conta_banco_lancamento

delete from #Documento where ic_tipo = 'CR'              and   
                             DataPagamento is not null   and 
                             DataPagamento < @dt_inicial 

  
--select * from #Documento  
  
  
  -- Adicionando coluna saldo pra calculo  
  
  select  
    *,  
    cast( 0.00 as float ) as Saldo      
  into  
    #DocumentoSaldo  
  from  
    #Documento  
  
  -- Declarando e pegando saldo inicial das contas  
  
  declare @SaldoInicial     float  
  declare @SaldoContaBanco  float  
  declare @cd_conta_banco   int  
  declare ContaBanco_Cursor CURSOR FOR  
  
  select cd_conta_banco from Conta_Agencia_Banco  
  where
    isnull(ic_ativo_conta,'S')       = 'S'   and
    isnull(ic_fluxo_caixa_conta,'S') = 'S'


  OPEN ContaBanco_Cursor  
  FETCH NEXT FROM ContaBanco_Cursor  
  INTO @cd_conta_banco  
  
  -- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
  
  set @SaldoInicial    = 0.00  
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN  
  
      exec pr_saldo_sintetico_movimento_banco  9, 
                                               @dt_inicio_movimento,
                                               @cd_conta_banco,
                                               @cd_tipo_lancamento_fluxo,
                                               @dt_inicio_movimento,
                                               @dt_inicio_movimento,
                                               0, 
                                               1,
                                               0,
                                               @cd_usuario,
                                               @vl_saldo_atual_retorno = @SaldoContaBanco output

--     select @dt_inicial,@dt_final,'@SaldoContaBanco', @SaldoContaBanco
  
    --Saldo Inicial  
    set @SaldoInicial    = @SaldoInicial + isnull(@SaldoContaBanco,0)  
  
    --print 'conta : '+cast(@cd_conta_banco  as varchar)  
    --print 'saldo : '+cast(@saldocontabanco as varchar)  
  
    --select @cd_conta_banco, @dt_inicial, @SaldoContaBanco, @SaldoInicial  
  
    -- This is executed as long as the previous fetch succeeds.  

    FETCH NEXT FROM ContaBanco_Cursor  
    INTO @cd_conta_banco  
  
  END  
  
  CLOSE      ContaBanco_Cursor  
  DEALLOCATE ContaBanco_Cursor  

  --select @SaldoInicial
  
  -- Adicionando Saldo Inicial aos Documentos  
  
  insert into  
    #DocumentoSaldo  
  Values (  
    null,  
    'SD',  
    'Saldo Inicial',  
    null,  
    case when @dt_inicial<>@dt_inicio_movimento 
    then @dt_inicio_movimento-1
    else @dt_inicial-1 end,  
    @SaldoInicial,  
    null,  
    null,  
    null,  
    null,  
    null,  
    null,  
    null,  
    null,
    @SaldoInicial
  )  

  --select @SaldoInicial
  
  -----------------------------------------------------------------------------------------------------  
  -- Calculando Saldos  
  -----------------------------------------------------------------------------------------------------  
  
  DECLARE @Saldo        float  
  DECLARE @SaldoTotal   float  
  Declare @Documento    varchar(20)  
  
  DECLARE DocumentoSaldo_Cursor CURSOR FOR  
  
  Select  
    vl_saldo_documento, 
    Documento  
  From  
    #DocumentoSaldo  
  order by   
    Vencimento  

  --select * from #DocumentoSaldo
  
  OPEN DocumentoSaldo_Cursor  
  
  FETCH NEXT FROM DocumentoSaldo_cursor  
  INTO @saldo, @Documento  
  
  -- Check @@FETCH_STATUS to see if there are any more rows to fetch.  
  
  set @SaldoTotal = 0  

  WHILE @@FETCH_STATUS = 0  
  BEGIN  
  
    -- Atualizando Saldo  
    set @SaldoTotal = @SaldoTotal + @saldo  
  
    update #DocumentoSaldo  
    set   
      saldo     = @SaldoTotal   
    where   
      Documento = @Documento  and cd_documento is not null
 
  FETCH NEXT FROM DocumentoSaldo_Cursor  
    INTO @saldo, @Documento  
  
  END  
  
  CLOSE DocumentoSaldo_Cursor  
  
  DEALLOCATE DocumentoSaldo_Cursor  


--  select * from #documentoSaldo

  --Verifica a Data de Início para atualização do Saldo correto

--  select @dt_inicio_movimento,@dt_inicial,@dt_inicio_mes

  if @dt_inicio_movimento<>@dt_inicial
  begin

    --Montagem de uma Tabela Temporária com os Saldos 

    select
      d.Vencimento,
      max(d.Saldo)              as Saldo,
      ValorDocumento = (select sum(x.vl_saldo_documento) from #Documento x where x.Vencimento = d.Vencimento group by x.vencimento    )
    into
      #AuxSaldo
    from
      #DocumentoSaldo d
    Group by
      d.Vencimento    
    order by
      d.Vencimento

--    select * from #AuxSaldo

    declare @vl_saldo_movimento float

    set @vl_saldo_movimento = 0.00

--    select * from #AuxSaldo    order by Vencimento

    --select @vl_saldo_movimento

    select top 1 @vl_saldo_movimento = isnull(Saldo,0) + case when day(vencimento)=1 then isnull(ValorDocumento,0) else 0.00 end
    from 
     #AuxSaldo
    where 
      --Vencimento = @dt_inicio_movimento - case when day(@dt_inicio_movimento)>1 then 1 else 0 end
      Vencimento = @dt_inicio_movimento - 1

--    select @vl_saldo_movimento
--    select @vl_saldo_movimento


--    Comentado em 17.10.2007
--     update
--       #DocumentoSaldo
--     set
--       Saldo              = @vl_saldo_movimento,
--       vl_saldo_documento = @vl_saldo_movimento
--       --vencimento         = @dt_inicial
--     where    
--       ic_tipo = 'SD'

  end
  
  -- mostrando documentos calculados  

  select  
    *   
  from   
    #DocumentoSaldo   
  where
     (ic_tipo='SD' or Vencimento between @dt_inicio_movimento and @dt_final )
  order by   
    Vencimento  


