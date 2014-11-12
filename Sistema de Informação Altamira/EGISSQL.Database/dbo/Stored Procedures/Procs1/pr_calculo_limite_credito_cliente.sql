
-------------------------------------------------------------------------------
--pr_calculo_limite_credito_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo do Limite de Crédito do Cliente
--Data             : 04.05.2006
--Alteração        : 25.11.2006
-- 10.10.2008 - Ajustes Diversos - Carlos Fernandes 
-- 15.10.2008 - Opção para Zerar o Limite - Carlos Fernandes / Douglas
------------------------------------------------------------------------------
create procedure pr_calculo_limite_credito_cliente
@ic_parametro int      = 0,  
@cd_cliente   int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@qt_divisor   float    = 0,   --Divisão       do coeficiente para o Limite de Crédito
@qt_fator     float    = 0    --Multiplicação do coeficiente para o Limite de Crédito

------------------------------------------------------------------------------
--Parâmetros
------------------------------------------------------------------------------
--1 : Valor Limite de Crédito Padrão
--2 : Pedido de Venda 
--3 : Documentos Pagos pelo Criente
--4 : Zerar o Valor Geral
------------------------------------------------------------------------------

as

declare @vl_padrao_limite_credito float

set @vl_padrao_limite_credito = 0

select
  @vl_padrao_limite_credito = isnull(vl_padrao_limite_credito,0)
from
  parametro_financeiro with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

------------------------------------------------------------------------------
--Valor de Limite Padrão
------------------------------------------------------------------------------

--select * from cliente_informacao_credito

if @ic_parametro = 1
begin

  --Verificar se Existe o Cliente na tabela de Informação de Crédito

  select
    c.cd_cliente,                  
    null                               as vl_limite_credito_cliente,
    'S'                                as ic_cobranca_eletronica,
    'S'                                as ic_informacao_credito,
    null                               as qt_dia_atraso_cliente,
    null                               as qt_media_atraso_cliente,
    null                               as qt_pagamento_atraso,
    null                               as vl_maior_fatura_cliente,
    null                               as dt_maior_fatura_cliente,
    null                               as vl_ultimo_faturamento,
    null                               as dt_ultimo_faturamento,
    null                               as qt_titulo_aberto_cliente,
    null                               as qt_titulo_protesto,
    null                               as qt_titulo_cartorio,
    cast('' as varchar)                as ds_observacao_credito,
    'N'                                as ic_credito_suspenso,
    null                               as dt_situacao_credito,
    null                               as qt_titulo_pago,
    null                               as qt_maior_atraso,
    null                               as cd_usuario,
    getdate()                          as dt_usuario,
    null                               as dt_ultimo_pagamento_atras,
    null                               as vl_total_faturamento,
    null                               as vl_saldo_atual_aberto,
    null                               as nm_credito_suspenso,
    null                               as qt_total_documentos,
    null                               as dt_orgao_credito,
    null                               as cd_orgao_credito,
    null                               as vl_maior_acumulo,
    null                               as dt_maior_acumulo,
    null                               as qt_nota_debito,
    null                               as vl_nota_debito,
    null                               as dt_suspensao_credito,
    null                               as cd_usuario_cred_susp,
    null                               as vl_total_credito_pendente,
    null                               as cd_suspensao_credito,
    null                               as nm_fantasia_usuario,
    null                               as vl_saldo_credito_cliente,
    null                               as cd_tipo_cobranca,
    null                               as vl_operacao_cambio,
    null                               as vl_embarque_cliente,
    null                               as vl_total_documento_pago,
    null                               as cd_motivo_liberacao,
    null                               as ic_alerta_credito_cliente,
    null                               as cd_condicao_pagamento,
    null                               as cd_conceito_credito,
    null                               as cd_portador,
    null                               as dt_validade_orgao_credito,
    null                               as ic_bloqueio_total_cliente,
    'N'                                as ic_deposito_cliente,
    null                               as cd_conta_banco,
    null                               as cd_forma_pagamento,
    null                               as vl_fat_minimo_cliente,
    cast(''  as varchar)               as ds_msg_boleto,
    null                               as pc_desconto_boleto

  into
    #Cliente_Informacao_Credito

  from
    Cliente c with (nolock) 

  where
    c.cd_cliente not in ( select cd_cliente from Cliente_Informacao_Credito )
  
  insert into
    Cliente_Informacao_Credito
  select
    * 
  from
    #Cliente_Informacao_Credito

  drop table #Cliente_Informacao_Credito

  update
    cliente_informacao_credito
  set
    vl_limite_credito_cliente = @vl_padrao_limite_credito
  where
    cd_cliente = case when @cd_cliente = 0 then cd_cliente else @cd_cliente end and
    isnull(vl_limite_credito_cliente,0)=0

end

------------------------------------------------------------------------------
--Valor dos Pedidos de Venda
------------------------------------------------------------------------------
--select * from pedido_venda

if @ic_parametro = 2
begin

  select
    pv.cd_cliente,
    sum(isnull(pv.vl_total_pedido_venda,0)) as TotalVenda
  into
    #AuxCreditoPedido

  from
    pedido_venda pv with (nolock) 

  where
    pv.cd_cliente = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
    pv.dt_pedido_venda between @dt_inicial and @dt_final and 
    pv.dt_cancelamento_pedido is null

  group by
    pv.cd_cliente

  --select * from #AuxCreditoPedido

  --Atualização geral

  update
    cliente_informacao_credito
  set
    vl_limite_credito_cliente = case when @qt_divisor>0 
                                         then a.TotalVenda/@qt_divisor 
                                         else 
                                case when @qt_fator>0 
                                         then a.TotalVenda*@qt_fator 
                                         else a.TotalVenda end
                                end
  from
    cliente_informacao_credito c, #AuxCreditoPedido a
  where
    c.cd_cliente = a.cd_cliente and
    isnull(c.vl_limite_credito_cliente,0)=0
  
end

------------------------------------------------------------------------------
--Documentos Pagos por Cliente
------------------------------------------------------------------------------
--select * from pedido_venda

if @ic_parametro = 3
begin

  --select * from documento_receber
  --select * from documento_receber_pagamento

  select
    d.cd_cliente,
    sum(isnull(d.vl_documento_receber,0)) as TotalPago
  into
    #AuxCreditoDocumentoPago
  from
    Documento_Receber d                       with (nolock) 
    inner join documento_receber_pagamento dp with (nolock) on dp.cd_documento_receber = d.cd_documento_receber
  where
    d.cd_cliente = case when @cd_cliente = 0 then d.cd_cliente else @cd_cliente end and
    dp.dt_pagamento_documento between @dt_inicial and @dt_final 

  group by
    d.cd_cliente

  select * from #AuxCreditoDocumentoPago

  --Atualização geral

  update
    cliente_informacao_credito
  set
    vl_limite_credito_cliente = case when @qt_divisor>0 
                                         then a.TotalPago/@qt_divisor 
                                         else 
                                case when @qt_fator>0 
                                         then a.TotalPago*@qt_fator 
                                         else a.TotalPago end
                                end
  from
    cliente_informacao_credito c, #AuxCreditoDocumentoPago a
  where
    c.cd_cliente = a.cd_cliente and
    isnull(c.vl_limite_credito_cliente,0)=0
  
end

------------------------------------------------------------------------------
--zerar o limite de Crédito
------------------------------------------------------------------------------

if @ic_parametro = 4

begin
  update
    cliente_informacao_credito
  set
    vl_limite_credito_cliente = 0.00
  
end
