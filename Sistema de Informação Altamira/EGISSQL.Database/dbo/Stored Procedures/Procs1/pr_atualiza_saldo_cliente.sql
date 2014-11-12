Create Procedure pr_atualiza_saldo_cliente
------------------------------------------------------------------------
--Global Business Solution          2004
--Banco Dados : Sql Server 2000
--Autor : Igor Gama
--Data  : 30.03.2004
--Observações : Procedure para atualizar o saldo do cliente, todas vez
--             que surgirem novas parcelas no documento_receber ou as mesmas
--             forem quitadas total ou parcialmente
--Parametros  : @atualizado  - Indica se com os parametros informados, foi possível
--                             realizar a atualização do saldo do cliente.
------------------------------------------------------------------------
 @cd_cliente   int,
 @vl_documento float,
 @atualizado char(1) out
as

  Declare @vl_saldo_cliente float
  Declare @vl_limite_cliente float

  --Verifica o saldo do cliente se é possível liberar.
  select 
    @vl_saldo_cliente = sum(d.vl_saldo_documento) + @vl_documento
  From
    Documento_Receber d
  where
    d.cd_cliente = @cd_cliente and
    IsNull(d.vl_saldo_documento, -1) > 0

  --Verficia o limite do cliente
  Select 
    @vl_limite_cliente = vl_limite_credito_cliente
  From Cliente_Informacao_Credito
  Where cd_cliente = @cd_cliente

  --Faz o abate do saldo do cliente para os documentos em aberto do 
  --saldo do limite de crédito do mesmo.
  If ((@vl_limite_cliente - @vl_saldo_cliente) >= 0) and
     (@vl_saldo_cliente > 0) 
  Begin
    Update Cliente_Informacao_Credito
    Set vl_saldo_credito_cliente = @vl_limite_cliente - @vl_saldo_cliente
    Where cd_cliente = @cd_cliente

    --Define que a atualização foi efetuada com sucesso.
    Set @atualizado = 'S'
  End Else
    --Define que este novo documento não pode ser feito, devido ao saldo do cliente
    -- estar abaixo do limite permitido.
    Set @atualizado = 'N'
