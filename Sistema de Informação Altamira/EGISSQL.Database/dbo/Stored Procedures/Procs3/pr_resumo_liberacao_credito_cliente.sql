
CREATE PROCEDURE pr_resumo_liberacao_credito_cliente
@dt_inicial as DateTime,
@dt_final   as DateTime
AS

  Select 
    identity(int, 1, 1) as 'cd_codigo',
    ped.cd_cliente,
    cli.nm_fantasia_cliente,
    count(ped.cd_pedido_venda) as 'cd_tot_pedido',
    CAST(sum(ped.vl_total_pedido_venda) as numeric(25,2)) as 'vl_tot_credito_liberar',
    CAST(0 as numeric(25,2)) as 'vl_tot_faturar',
    CAST(0 as int) as 'cd_tot_documento',
    CAST(0 as numeric(25,2)) as 'vl_limite_credito_cliente',
    CAST(0 as numeric(25,2)) as 'vl_saldo_credito_cliente',
    cast(0 as numeric(25,2)) as 'qt_dia_atraso',
    cast(0 as numeric(25,2)) as 'qt_documento_atraso',
    cast(0 as numeric(25,2)) as 'vl_total_atraso'
  Into #Tabela
  From 
    Pedido_Venda ped Inner join Cliente cli on
      ped.cd_cliente = cli.cd_cliente
  Where 
    ped.dt_pedido_venda between @dt_inicial and @dt_final
    and ped.dt_cancelamento_pedido is null
  --  and ic_emitido_pedido_venda = 'N'
  --  and isnull(ic_smo_pedido_venda,'N') = 'N'
    and ped.dt_credito_pedido_venda is null 
  group by
    ped.cd_cliente,
    cli.nm_fantasia_cliente
  Order by 
    cli.nm_fantasia_cliente
  

  Select 
    ped.cd_cliente,
    cli.nm_fantasia_cliente,
    count(ped.cd_pedido_venda) as 'cd_tot_pedido',
    CAST(0 as numeric(25,2)) as 'vl_tot_credito_liberar',
    CAST(sum(ped.vl_total_pedido_venda) as numeric(25,2)) as 'vl_tot_faturar',
    CAST(0 as int) as 'cd_tot_documento',
    CAST(0 as numeric(25,2)) as 'vl_limite_credito_cliente',
    CAST(0 as numeric(25,2)) as 'vl_saldo_credito_cliente'
  Into #TabelaII
  From 
    Pedido_Venda ped Inner Join Cliente cli on
      ped.cd_cliente = cli.cd_cliente
  Where 
    ped.dt_pedido_venda between @dt_inicial and @dt_final
    and ped.dt_cancelamento_pedido is null
  group by
    ped.cd_cliente,
    cli.nm_fantasia_cliente
  Order by 
    cli.nm_fantasia_cliente


  Declare @cd_contador    as int
  Declare @cd_cliente     as int
  Declare @vl_tot_faturar as numeric(25,2)
  Declare @cd_tot_documento as int
  Declare @vl_limite_credito_cliente as numeric(25,2)
  Declare @vl_saldo_credito_cliente as numeric (25,2)

  Set @cd_contador = 1

  While Exists (Select 'X' From #Tabela Where cd_codigo = @cd_contador)
  begin

    Select @cd_cliente = cd_cliente From #Tabela where cd_codigo = @cd_contador

    If Exists (Select 'X' From #TabelaII Where cd_cliente = @cd_cliente)
    begin

      Select @vl_tot_faturar = vl_tot_faturar From #TabelaII Where cd_cliente = @cd_cliente

      Select 
        @cd_tot_documento = COUNT(d.cd_documento_receber),
        @vl_limite_credito_cliente = CAST(c.vl_limite_credito_cliente as numeric(25,2)),
        @vl_saldo_credito_cliente = CAST(c.vl_saldo_credito_cliente as numeric(25,2))
      From 
        Documento_receber d Left Outer Join 
        Cliente_informacao_credito c on d.cd_cliente = c.cd_cliente
      Where 
        d.vl_saldo_documento > 0 and
        d.cd_cliente = @cd_cliente and
        d.dt_emissao_documento between @dt_inicial and @dt_final
      Group By
        c.vl_limite_credito_cliente,c.vl_saldo_credito_cliente 

      Update #Tabela
      Set 
        vl_tot_faturar = ISNULL(@vl_tot_faturar,0),
        cd_tot_documento = ISNULL(@cd_tot_documento,0),
        vl_limite_credito_cliente = ISNULL(@vl_limite_credito_cliente,0),
        vl_saldo_credito_cliente = Isnull(@vl_saldo_credito_cliente,0)
      Where cd_codigo = @cd_contador

      Set @cd_contador = @cd_contador + 1

    End Else
      Set @cd_contador = @cd_contador + 1

  End

  Drop Table #TabelaII

  -- Inclusão dos campos de Atraso - ELIAS
  select
    cd_cliente  as 'Cliente', 
    count(cd_identificacao) as 'QtdDocumento',
    cast(cast(getDate() as float) as int) - cast(cast(dt_vencimento_documento as float) as int) as 'DiasAtraso',
    sum(cast(str(vl_saldo_documento,25,2) as decimal(25,2))) as 'TotalAtraso'
  into
    #Documento_Atraso
  from 
    documento_receber
  where
    dt_vencimento_documento < getDate() and
    cast(str(vl_saldo_documento,25,2) as decimal(25,2)) <> 0.00 and
    cd_cliente in (select cd_cliente from #Tabela)
  group by
    cd_cliente,
    dt_vencimento_documento
  order by
    cd_cliente

  update
    #Tabela
  set
    qt_dia_atraso = a.DiasAtraso,
    qt_documento_atraso = a.QtdDocumento,
    vl_total_atraso = a.TotalAtraso
  from
    #Documento_Atraso a
  where
    cd_cliente = a.Cliente
       
  Select 
    cd_cliente,
    nm_fantasia_cliente,
    cd_tot_pedido,
    vl_tot_credito_liberar,
    vl_tot_faturar,
    cd_tot_documento,
    vl_limite_credito_cliente,
    qt_dia_atraso,
    qt_documento_atraso,
    vl_total_atraso,
    vl_saldo_credito_cliente 
  From
    #Tabela

