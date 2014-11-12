
create procedure pr_movimento_faturamento

@dt_inicial  datetime,
@dt_final    datetime

as

  declare @vl_saldo        float
  declare @vl_venda        float
  declare @vl_faturamento  float
  declare @vl_cancelamento float
  declare @vl_devolucao    float
  declare @dt_aux          datetime
  declare @ic_devolucao_bi char(1)

  set @ic_devolucao_bi = 'N'

  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()


  -- Criacao da Tabela Auxiliar

  create table #tabela 
     ( Data         datetime null,
       Saldo        float,
       Venda        float,
       Faturamento  float,
       Cancelamento float,
       Devolucao    float,
       SaldoAtual   float)


  -- Data Inicial
  set @dt_aux = @dt_inicial
  

while @dt_aux <= @dt_final
begin

  set @vl_saldo       = 0
  set @vl_venda       = 0
  set @vl_faturamento = 0
  set @vl_cancelamento= 0
  set @vl_devolucao   = 0

  --Saldo Anterior de Carteira de Pedidos em Aberto

  select
    @vl_saldo = @vl_saldo + 
                isnull( sum( ipv.qt_saldo_pedido_venda * ipv.vl_unitario_item_pedido ),0 )
                           
   from 
    pedido_venda_item ipv
  where
    ipv.dt_item_pedido_venda < @dt_aux and
    ipv.dt_cancelamento_item is null   

  --Venda do dia

  select
    @vl_venda = @vl_venda + 
                isnull( sum( ipv.qt_item_pedido_venda * ipv.vl_unitario_item_pedido ),0 )
                           
  from 
    pedido_venda_item ipv
  where
    ipv.dt_item_pedido_venda = @dt_aux and
    ipv.dt_cancelamento_item is null   

  --Faturamento do Dia
  select 
      @vl_faturamento = isnull ( sum ( vl_unitario_item_total ), 0 )
  from
      vw_faturamento_bi
   where
      dt_nota_saida = @dt_aux
  
  --Cancelamento do Dia
  select 
      @vl_cancelamento = isnull ( sum ( vl_unitario_item_atual ), 0 )
  from
      vw_faturamento_cancelado
  where
      dt_nota_saida = @dt_aux    


  --Devolução Total do do Dia
  select 
      @vl_devolucao = isnull ( sum ( vl_unitario_item_total ), 0 )
  from
      vw_faturamento_devolucao
  where
      dt_nota_saida = @dt_aux    

  --Verifica se a empresa trabalha com abatimento de devoluções anteriores
  if ( @ic_devolucao_bi = 'S' )
    select 
        @vl_devolucao = @vl_devolucao + isnull ( sum ( vl_unitario_item_total ), 0 )
    from
        vw_faturamento_devolucao_mes_anterior
    where
        dt_restricao_item_nota = @dt_aux    



  --Insere os dados na tabela temporaria        
  insert into #tabela (
    Data,
    Saldo,
    Venda,
    Faturamento,
    Cancelamento,
    Devolucao,
    SaldoAtual ) 
    values (
    @dt_aux,                   
    isnull(@vl_saldo,0),           
    isnull(@vl_venda,0),
    isnull(@vl_faturamento,0),     
    isnull(@vl_cancelamento,0),    
    isnull(@vl_devolucao,0),       

    isnull(@vl_saldo,0)+
    isnull(@vl_venda,0)+
    isnull(@vl_faturamento,0)-(isnull(@vl_cancelamento,0)+
                               isnull(@vl_devolucao,0) ) )

  set @dt_aux = @dt_aux + 1

end

select * from #tabela

