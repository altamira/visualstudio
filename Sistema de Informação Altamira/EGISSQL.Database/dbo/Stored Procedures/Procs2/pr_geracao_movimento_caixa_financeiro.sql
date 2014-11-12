
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_movimento_caixa_financeiro
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Movimento de Caixa para o Financeiro
--                   Contas a Receber
--Data             : 10.11.2007
--Alteração        : 
--20.05.2008 - Grava o Movimento de Caixa na Tabela do Contas a Receber
--                                 
---------------------------------------------------------------------------------
create procedure pr_geracao_movimento_caixa_financeiro
@cd_movimento_caixa int = 0,
@cd_usuario         int = 0

as

--select * from parametro_loja

declare @ic_gera_financeiro char(1)

select
  @ic_gera_financeiro = isnull(ic_gera_financeiro,'N')
from
  parametro_loja
where
  cd_empresa = dbo.fn_empresa()

--select * from movimento_caixa
 
if @cd_movimento_caixa>0 and isnull(@ic_gera_financeiro,'N')='S'
begin


  declare @Tabela	              varchar(50)
  declare @cd_documento_receber       int 
  declare @cd_portador                int
  declare @cd_tipo_documento          int
  declare @cd_tipo_cobranca           int
  declare @cd_vendedor                int
  declare @cd_centro_custo            int
  declare @cd_plano_financeiro        int
  declare @ic_gera_baixa_documento    int
  declare @cd_conta_banco             int
  declare @cd_tipo_caixa              int
  declare @cd_cartao_credito          int
  declare @cd_identificacao_documento varchar(25)
  declare @dt_movimento_caixa         datetime
  declare @cd_cliente                 int
  declare @vl_movimento_caixa         decimal(25,2)
  declare @ds_documento_receber       varchar(40)
  declare @cd_pedido_venda            int
  declare @cd_nota_saida              int

  select
    @cd_portador         = cd_portador,
    @cd_tipo_documento   = cd_tipo_documento,
    @cd_tipo_cobranca    = cd_tipo_cobranca,
    @cd_plano_financeiro = cd_plano_financeiro,
    @cd_centro_custo     = cd_centro_custo,
    @cd_conta_banco      = cd_conta_banco,
    @cd_tipo_caixa       = cd_tipo_caixa
  from  
    Parametro_Financeiro_Caixa
  where
    cd_empresa = dbo.fn_empresa()


  --Movimento de Caixa

  select
    @cd_identificacao_documento = dbo.fn_STRZERO(cd_movimento_caixa,6),
    @dt_movimento_caixa         = dt_movimento_caixa,
    @ds_documento_receber       = 'MC-'+dbo.fn_STRZERO(cd_movimento_caixa,6)+' '+
                                  case when isnull(cd_cupom_fiscal,0)>0 
                                  then cast(cd_cupom_fiscal as varchar)
                                  else '' end,
    @cd_cliente                 = isnull(cd_cliente,0),
    @cd_vendedor                = cd_vendedor,
    @cd_cartao_credito          = isnull(cd_cartao_credito,0),
    @vl_movimento_caixa         = isnull(vl_movimento_caixa,0)
    
  from
    Movimento_Caixa with (nolock)
  where
    cd_movimento_caixa = @cd_movimento_caixa    

--  select @ds_documento_receber  

  --select * from movimento_caixa_item

  --Busca o Pedido de Venda da Movimentação do Item

  select
    top 1
    @cd_pedido_venda = isnull(cd_pedido_venda,0)
  from
    Movimento_Caixa_item with (nolock) 
  where
    cd_movimento_caixa = @cd_movimento_caixa and
    isnull(cd_pedido_venda,0)>0  
  order by
    cd_pedido_venda


  --Verifica se houve pagamento com cartão de crédito

  if @cd_cartao_credito>0 
  begin
    select
      @cd_portador         = cd_portador,
      @cd_tipo_documento   = cd_tipo_documento,
      @cd_tipo_cobranca    = cd_tipo_cobranca,
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @cd_conta_banco      = cd_conta_banco,
      @cd_tipo_caixa       = cd_tipo_caixa
    from  
      Cartao_Credito_Caixa
    where
      cd_cartao_credito = @cd_cartao_credito
  end

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

  -- campo chave utilizando a tabela de códigos
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output

  while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento_receber)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
  end

  --Geração da Documento Receber

  --select * from documento_receber
  
	        -- montagem da identificação do documento
	        exec pr_documento_receber 
	           2, 
	           null, 
	           null, 
	           @cd_documento_receber, 
	           @cd_identificacao_documento,
	           @dt_movimento_caixa, 
	           @dt_movimento_caixa, 
	           @dt_movimento_caixa, 
	           @vl_movimento_caixa,
	           @vl_movimento_caixa,           --Saldo do Documento Receber
	           null, 
	           null, 
	           0, 
	           null, 
	           @ds_documento_receber,
	           'N', 
	           null,
	           null, 
	           null, 
	           @cd_portador, 
	           @cd_tipo_cobranca, 
	           @cd_cliente, 
	           @cd_tipo_documento, 
	           @cd_pedido_venda, 
	           @cd_nota_saida, 
	           @cd_vendedor,
	           null, 
	           0, 
	           'A', 
	           null, 
	           @cd_plano_financeiro, 
	           @cd_usuario, 
	           '',
	           1,
	           0,
	           0,
	           null, 
	           '',
	           'N',
                   1,  --Moeda R$
                   0,
                   0, --@cd_loja,
                   @cd_centro_custo,
                   null,
                   null,
                   null,
                   @cd_movimento_caixa 


  --Geração da Baixa do Documento Receber


  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'

end

