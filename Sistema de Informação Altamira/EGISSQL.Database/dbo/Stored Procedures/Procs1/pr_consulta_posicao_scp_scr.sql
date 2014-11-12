
CREATE PROCEDURE pr_consulta_posicao_scp_scr
------------------------------------------------------------------------------------------------------
--pr_consulta_posicao_scp_scr
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution               2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s)        : Daniel Carrasco / Paulo Santos
--Banco de Dados  : EGISSQL
--Objetivo        : Consultar Documentos a Receber e a Pagar de uma só vez.
--Data            : 14/10/2004 
--Data            : 02/02/2007 - Adicionando portador, observação do documento, e Calculando Saldo - Anderson
--                : 25.07.2007 - Saldos Iniciais - Carlos Fernandes
--                : 03.09.2007 - Acerto do Saldo Inicial - Carlos Fernandes
--                : 17.10.2007 - Ajuste do SAldo - Carlos Fernandes
-- 14.01.2008 - Correção para mostrar o data do desconto do documento - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_usuario int      = 0

as

declare @cd_tipo_lancamento_fluxo int

set @cd_tipo_lancamento_fluxo = 2

  select
    *
  into
    #Documento
  from
    (
     -- Contas a Pagar
     select
       p.nm_portador               as Portador,
       'CP'                        as ic_tipo, 
       d.cd_identificacao_document as Documento,
       d.dt_emissao_documento_paga as Emissao,
       d.dt_vencimento_documento   as Vencimento,
       (cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) * -1) as 'vl_saldo_documento',
       case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
            when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))
            when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))
            when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))
       end                             as 'nm_fantasia_destinatario',
       t.nm_tipo_documento as Tipo,
       d.nm_observacao_documento as Obsevacao,
       tcp.nm_tipo_conta_pagar as TipoConta
     from
       Documento_Pagar d with (nolock) 
       left outer join 
       Fornecedor_Contato f on d.nm_fantasia_fornecedor = f.nm_fantasia_fornecedor and 
                               f.cd_contato_fornecedor = 1 left outer join
       Tipo_documento t on t.cd_tipo_documento = d.cd_tipo_documento left outer join 
       Portador p on p.cd_portador = d.cd_portador left outer join 
       Tipo_Conta_Pagar tcp on tcp.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar
     where
       d.dt_vencimento_documento  between @dt_inicial and @dt_final and 
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final)) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento    > @dt_final)) and
       cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) <> 0 

     ) s1 

     union

     (

     -- Contas a Receber
     -- select * from documento_receber_desconto

     select 
       p.nm_portador               as Portador,
       'CR'                        as ic_tipo,
       d.cd_identificacao          as Documento,
       d.dt_emissao_documento      as Emissao,

       case when drd.dt_desconto_documento is not null then
          drd.dt_desconto_documento
       else
          d.dt_vencimento_documento  
       end                         as Vencimento,

       cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) 
                                   as 'vl_saldo_documento',
       vw.nm_fantasia              as 'nm_fantasia_destinatario',
       tp.nm_tipo_documento        as Tipo,
       cast(d.ds_documento_receber as varchar(40)) as Obsevacao,
       'Faturamento'               as TipoConta
     from
       documento_receber d with (nolock) 
       inner join vw_destinatario_rapida vw           on d.cd_cliente             = vw.cd_destinatario and
                                                         d.cd_tipo_destinatario   = vw.cd_tipo_destinatario
       left outer join Tipo_Documento tp              on tp.cd_tipo_documento     = d.cd_tipo_documento 
       left outer join Portador p                     on p.cd_portador            = d.cd_portador
       left outer join Documento_Receber_Desconto drd on drd.cd_documento_receber = d.cd_documento_receber and
                                                         drd.dt_desconto_documento between @dt_inicial and @dt_final 
                        
                                                
    where 
       d.dt_vencimento_documento between @dt_inicial and @dt_final and
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final)) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento > @dt_final))       and
       
       cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) <> 0 
    )
  order by
    5 asc

  -- Adicionando coluna saldo pra calculo

  select
    *,
    cast( 0 as float ) as Saldo    
  into
    #DocumentoSaldo
  from
    #Documento

  -- Declarando e pegando saldo inicial das contas
  declare @SaldoInicial    float
  declare @SaldoContaBanco float
  declare @cd_conta_banco  int
  declare @dt_saldo_conta  datetime

  declare ContaBanco_Cursor CURSOR FOR

  select cd_conta_banco from Conta_Agencia_Banco
  where
     isnull(ic_ativo_conta,'S')       = 'S'   and  --Conta Ativa
     isnull(ic_fluxo_caixa_conta,'S') = 'S'        --Conta entra no Fluxo de Caixa


  OPEN ContaBanco_Cursor

  FETCH NEXT FROM ContaBanco_Cursor
  INTO @cd_conta_banco

  -- Check @@FETCH_STATUS to see if there are any more rows to fetch.
  set @SaldoInicial    = 0
  WHILE @@FETCH_STATUS = 0
  BEGIN

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
                                               @vl_saldo_atual_retorno = @SaldoContaBanco output

     
      --select @dt_inicial,@dt_final,'@SaldoContaBanco', @SaldoContaBanco
	
    set @SaldoInicial    = @SaldoInicial + @SaldoContaBanco

--    select @cd_conta_banco, @dt_inicial, @SaldoContaBanco, @SaldoInicial, @vl_saldo

    -- This is executed as long as the previous fetch succeeds.
    FETCH NEXT FROM ContaBanco_Cursor
    INTO @cd_conta_banco

  END

  CLOSE ContaBanco_Cursor

  DEALLOCATE ContaBanco_Cursor

  -- Adicionando Saldo Inicial aos Documentos

  insert into
    #DocumentoSaldo
  Values (
    null,
    'SD',
    'Saldo Inicial',
    null,
    @dt_inicial-1,
    @SaldoInicial,
    null,
    null,
    null,
    null,
    @SaldoInicial
  )

  -- Calculando Saldos
  DECLARE @Saldo                float
  DECLARE @SaldoTotal           float
  Declare @Documento            varchar(20)
  DECLARE DocumentoSaldo_Cursor CURSOR FOR

  Select
    vl_saldo_documento, 
    Documento
  From
    #DocumentoSaldo

  OPEN DocumentoSaldo_Cursor

  FETCH NEXT FROM DocumentoSaldo_cursor
  INTO
    @saldo, @Documento

  -- Check @@FETCH_STATUS to see if there are any more rows to fetch.
  set @SaldoTotal      = 0

  WHILE @@FETCH_STATUS = 0
  BEGIN

    -- Atualizando Saldo

    set @SaldoTotal = @SaldoTotal + @saldo

    update 
       #DocumentoSaldo
    set 
      saldo = @SaldoTotal 
    where 
      Documento = @Documento

    -- This is executed as long as the previous fetch succeeds.

    FETCH NEXT FROM DocumentoSaldo_Cursor
    INTO @saldo, @Documento

  END

  CLOSE      DocumentoSaldo_Cursor

  DEALLOCATE DocumentoSaldo_Cursor

  -- mostrando documentos calculados
  select 
    * 
  from 
    #DocumentoSaldo 
  order by 
    Vencimento

