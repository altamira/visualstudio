
-----------------------------------------------------------------------------------------------------
--pr_busca_operacao_fiscal_pedido_venda
-----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure           : Microsoft SQL Server       2000
--Autor(es)		     : Elias Pereira da Silva
--Banco de Dados	     : EGISSQL
--Objetivo		     : Busca a Operação Fiscal através de Dados do Pedido de Venda
--Data			     : ???
--Desc. Alteração            : 03/08/2004 - Incluído novo Parâmetro que identifica 
--                               CFOP quando o PV é de Consignação - ELIAS
--                           : 16.12.2006 - Entrega Futura
--                                        - Acertos Diversos - Carlos Fernandes
----------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_busca_operacao_fiscal_pedido_venda
@cd_mascara_operacao_fiscal char(6),
@cd_tributacao              int,
@cd_destinacao_produto      int,
@ic_zona_franca             char(1) = 'N',
@ic_consignacao             char(1) = 'N',
@ic_entrega_futura          char(1) = 'N'

as

  set @ic_zona_franca    = isnull(@ic_zona_franca,    'N')

  set @ic_consignacao    = isnull(@ic_consignacao,    'N')

  set @ic_entrega_futura = isnull(@ic_entrega_futura, 'N')

--   select @cd_mascara_operacao_fiscal,
--          @cd_tributacao             ,
--          @cd_destinacao_produto     ,
--          @ic_zona_franca            ,
--          @ic_consignacao            ,
--          @ic_entrega_futura         


  declare @cd_operacao_fiscal int

  select
    top 1 
    @cd_operacao_fiscal = isnull(cd_operacao_fiscal,0) 
  from
    Operacao_Fiscal
  where
    replace(cd_mascara_operacao,'.','')  = replace(@cd_mascara_operacao_fiscal,'.','') and
    cd_destinacao_produto                = @cd_destinacao_produto                      and
    isnull(ic_zfm_operacao_fiscal,'N')   = @ic_zona_franca                             and
    isnull(ic_consignacao_op_fiscal,'N') = @ic_consignacao                             and
    isnull(ic_entrega_futura,'N')        = @ic_entrega_futura
  order by
    cd_operacao_fiscal

  select isnull(@cd_operacao_fiscal,0) as cd_operacao_fiscal

