﻿
/****** Object:  Stored Procedure dbo.SPVE_PEDIDOS_INCLUIR    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_PEDIDOS_INCLUIR    Script Date: 25/08/1999 20:11:52 ******/
CREATE PROCEDURE SPVE_PEDIDOS_INCLUIR

    @Pedido             int,
    @Cliente            char(14),
	@Projeto            char(6),
	@Orcamento          int,
    @PedidoCliente      char(10),
	@TipoPedido         char(1),
	@AliqICMs         int,
    @Representante      char(3),
	@Comissao           real,
    @ValorVenda         money,
    @ValorServico       money,
    @ValorIPI           money,
    @TipoReajuste       tinyint,
    @QtdeViradas        tinyint,
    @TipoEmbalagem      varchar(20),
    @ValorEmbalagem     real,
    @TipoTransporte     tinyint,
    @Transportadora     int,
    @ValorTransporte    real,
    @TipoMontagem       tinyint,
    @ValorMontagem      real,
    @MontagemPaga       char(1),
    @TipoAcabamento     tinyint,
    @ValorAcabamento    real,
    @DataPedido         smalldatetime,
    @DataEntrega        smalldatetime,
    @DataMontagem       smalldatetime,
    @ValorTabela        money,
    @IndiceVenda        real,
    @IndiceFinanceiro   real,
    @NotaFiscal         char(6),
    @Observacao         varchar(250),
    @PedidoServico      int,
    @EntEndereco        varchar(40),
    @EntBairro          varchar(25),
	@EntCidade          varchar(25),
    @EntEstado          varchar(2),
	@EntCGC             varchar(14),
    @EntInscricao       varchar(14),
    @EntDDD             varchar(4),
    @EntTelefone        varchar(10),
    @Dias1              tinyint,
    @Dias2              tinyint,
    @Dias3              tinyint,
    @Dias4              tinyint,
    @Dias5              tinyint,
    @Dias6              tinyint,
    @Dias7              tinyint,
    @Dias8              tinyint,
    @Porcentagem1       real,
    @Porcentagem2       real,
    @Porcentagem3       real,
    @Porcentagem4       real,
    @Porcentagem5       real,
    @Porcentagem6       real,
    @Porcentagem7       real,
    @Porcentagem8       real,
    @Escolha1           tinyint,
    @Escolha2           tinyint,
    @Escolha3           tinyint,
    @Escolha4           tinyint,
    @Escolha5           tinyint,
    @Escolha6           tinyint,
    @Escolha7           tinyint,
    @Escolha8           tinyint,
    @Tipo1              char(1),
    @Tipo2              char(1),
    @Tipo3              char(1),
    @Tipo4              char(1),
    @Tipo5              char(1),
    @Tipo6              char(1),
    @Tipo7              char(1),
    @Tipo8              char(1),
    @Valor1             money,
    @Valor2             money,
    @Valor3             money,
    @Valor4             money,
    @Valor5             money,
    @Valor6             money,
    @Valor7             money,
    @Valor8             money,
    @EntCEP          varchar(8),
    @Aprovação      tinyint
AS

BEGIN

  INSERT INTO VE_Pedidos  (vepe_Pedido,
                           vepe_Cliente,
                           vepe_Projeto,
                           vepe_Orcamento,
                           vepe_PedidoCliente,
                           vepe_TipoPedido,
                           vepe_AliqIcms,
                           vepe_Representante,
                           vepe_Comissao,           
                           vepe_ValorVenda,
                           vepe_ValorServico,
                           vepe_ValorIPI,
                           vepe_TipoReajuste,
                           vepe_QtdeViradas,
                           vepe_TipoEmbalagem,
                           vepe_ValorEmbalagem,
                           vepe_TipoTransporte,     
                           vepe_Transportadora,
                           vepe_ValorTransporte,
                           vepe_TipoMontagem,
                           vepe_ValorMontagem,
                           vepe_MontagemPaga,
                           vepe_TipoAcabamento,
                           vepe_ValorAcabamento,
                           vepe_DataPedido,           
                           vepe_DataEntrega,
                           vepe_DataMontagem,
                           vepe_ValorTabela,
                           vepe_IndiceVenda,
                           vepe_IndiceFinanceiro,
                           vepe_NotaFiscal,
                           vepe_Observacao,
                           vepe_PedidoServico,       
                           vepe_EntEndereco,     
                           vepe_EntBairro,       
                           vepe_EntCidade,      
                           vepe_EntEstado,      
                           vepe_EntCGC, 
                           vepe_EntInscricao, 
                           vepe_EntDDD, 
                           vepe_EntTelefone,
                           vepe_Dias1,
                           vepe_Dias2, 
                           vepe_Dias3,
                           vepe_Dias4, 
                           vepe_Dias5,
                           vepe_Dias6, 
                           vepe_Dias7,
                           vepe_Dias8,                     
                           vepe_Porcentagem1,
                           vepe_Porcentagem2,
                           vepe_Porcentagem3,
                           vepe_Porcentagem4,
                           vepe_Porcentagem5,
                           vepe_Porcentagem6,
                           vepe_Porcentagem7,
                           vepe_Porcentagem8, 
                           vepe_Escolha1,
                           vepe_Escolha2,
                           vepe_Escolha3,
                           vepe_Escolha4,
                           vepe_Escolha5,
                           vepe_Escolha6,
                           vepe_Escolha7,
                           vepe_Escolha8,
                           vepe_Tipo1,     
                           vepe_Tipo2,               
                           vepe_Tipo3,
                           vepe_Tipo4,
                           vepe_Tipo5,
                           vepe_Tipo6,
                           vepe_Tipo7,
                           vepe_Tipo8, 
                           vepe_Valor1,
                           vepe_Valor2,
                           vepe_Valor3,
                           vepe_Valor4,
                           vepe_Valor5,
                           vepe_Valor6,
                           vepe_Valor7,      
                           vepe_Valor8,
		vepe_EntCEP,
		vepe_Montador,
		vepe_Aprovação,
		vepe_Situação,
		vepe_Autoriza, VEPE_INTEGRA)
		            VALUES (@Pedido,
                            @Cliente,
	                        @Projeto,
	                        @Orcamento,
                            @PedidoCliente,
	                        @TipoPedido,
	                        @AliqICMs,
                            @Representante,
	                        @Comissao,
                            @ValorVenda,
                            @ValorServico,
                            @ValorIPI,
                            @TipoReajuste,
                            @QtdeViradas,
                            @TipoEmbalagem,
                            @ValorEmbalagem,
                            @TipoTransporte,
                            @Transportadora,
                            @ValorTransporte,
                            @TipoMontagem,
                            @ValorMontagem,
                            @MontagemPaga,
                            @TipoAcabamento,
                            @ValorAcabamento,
                            @DataPedido,
                            @DataEntrega,
                            @DataMontagem,
                            @ValorTabela,
                            @IndiceVenda,
                            @IndiceFinanceiro,
                            @NotaFiscal,
                            @Observacao,
                            @PedidoServico,
                            @EntEndereco,
                            @EntBairro,
	                        @EntCidade,
                            @EntEstado,
	                        @EntCGC,
                            @EntInscricao,
                            @EntDDD,
                            @EntTelefone,
                            @Dias1,
                            @Dias2,
                            @Dias3,
                            @Dias4,
                            @Dias5,
                            @Dias6,
                            @Dias7,
                            @Dias8,
                            @Porcentagem1,
                            @Porcentagem2,
                            @Porcentagem3,
                            @Porcentagem4,
                            @Porcentagem5,
                            @Porcentagem6,
                            @Porcentagem7,
                            @Porcentagem8,
                            @Escolha1,
                            @Escolha2,
                            @Escolha3,
                            @Escolha4,
                            @Escolha5,
                            @Escolha6,
                            @Escolha7,
                            @Escolha8,
                            @Tipo1,
                            @Tipo2,
                            @Tipo3,
                            @Tipo4,
                            @Tipo5,
                            @Tipo6,
                            @Tipo7,
                            @Tipo8,
                            @Valor1,
                            @Valor2,
                            @Valor3,
                            @Valor4,
                            @Valor5,
                            @Valor6,
                            @Valor7,
                            @Valor8,
		  @EntCEP,
		  1,
		 @Aprovação,
		 0,0,'N' )

END


   

	       

         












