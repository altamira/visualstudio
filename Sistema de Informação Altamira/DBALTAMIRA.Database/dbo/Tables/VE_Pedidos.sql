CREATE TABLE [dbo].[VE_Pedidos] (
    [vepe_Pedido]              INT           NOT NULL,
    [vepe_Cliente]             CHAR (40)     NULL,
    [vepe_Projeto]             CHAR (6)      NULL,
    [vepe_Orcamento]           INT           NULL,
    [vepe_PedidoCliente]       CHAR (10)     NULL,
    [vepe_TipoPedido]          CHAR (1)      NOT NULL,
    [vepe_AliqICMS]            INT           NULL,
    [vepe_Representante]       CHAR (3)      NOT NULL,
    [vepe_Comissao]            REAL          NOT NULL,
    [vepe_ValorVenda]          MONEY         NOT NULL,
    [vepe_ValorServico]        MONEY         NOT NULL,
    [vepe_ValorIPI]            MONEY         NOT NULL,
    [vepe_TipoReajuste]        TINYINT       NOT NULL,
    [vepe_QtdeViradas]         TINYINT       NULL,
    [vepe_TipoEmbalagem]       VARCHAR (20)  NULL,
    [vepe_ValorEmbalagem]      REAL          NOT NULL,
    [vepe_TipoTransporte]      TINYINT       NOT NULL,
    [vepe_Transportadora]      INT           NOT NULL,
    [vepe_ValorTransporte]     REAL          NOT NULL,
    [vepe_TipoMontagem]        INT           NOT NULL,
    [vepe_ValorMontagem]       REAL          NOT NULL,
    [vepe_MontagemPaga]        CHAR (1)      NOT NULL,
    [vepe_TipoAcabamento]      TINYINT       NOT NULL,
    [vepe_ValorAcabamento]     REAL          NOT NULL,
    [vepe_DataPedido]          SMALLDATETIME NULL,
    [vepe_DataEntrega]         SMALLDATETIME NULL,
    [vepe_DataMontagem]        SMALLDATETIME NULL,
    [vepe_DataSaida]           SMALLDATETIME NULL,
    [vepe_ValorTabela]         MONEY         NOT NULL,
    [vepe_IndiceVenda]         REAL          NOT NULL,
    [vepe_IndiceFinanceiro]    REAL          NOT NULL,
    [vepe_NotaFiscal]          CHAR (8)      NULL,
    [vepe_Observacao]          VARCHAR (250) NULL,
    [vepe_PedidoServico]       INT           NULL,
    [vepe_EntEndereco]         VARCHAR (40)  NULL,
    [vepe_EntBairro]           VARCHAR (25)  NULL,
    [vepe_EntCidade]           VARCHAR (25)  NULL,
    [vepe_EntEstado]           VARCHAR (2)   NULL,
    [vepe_EntCGC]              VARCHAR (14)  NULL,
    [vepe_EntInscricao]        VARCHAR (14)  NULL,
    [vepe_EntDDD]              VARCHAR (4)   NULL,
    [vepe_EntTelefone]         VARCHAR (10)  NULL,
    [vepe_EntCEP]              VARCHAR (8)   NULL,
    [vepe_Dias1]               TINYINT       NOT NULL,
    [vepe_Dias2]               TINYINT       NULL,
    [vepe_Dias3]               TINYINT       NULL,
    [vepe_Dias4]               TINYINT       NULL,
    [vepe_Dias5]               TINYINT       NULL,
    [vepe_Dias6]               TINYINT       NULL,
    [vepe_Dias7]               TINYINT       NULL,
    [vepe_Dias8]               TINYINT       NULL,
    [vepe_Porcentagem1]        REAL          NOT NULL,
    [vepe_Porcentagem2]        REAL          NULL,
    [vepe_Porcentagem3]        REAL          NULL,
    [vepe_Porcentagem4]        REAL          NULL,
    [vepe_Porcentagem5]        REAL          NULL,
    [vepe_Porcentagem6]        REAL          NULL,
    [vepe_Porcentagem7]        REAL          NULL,
    [vepe_Porcentagem8]        REAL          NULL,
    [vepe_Escolha1]            TINYINT       NOT NULL,
    [vepe_Escolha2]            TINYINT       NULL,
    [vepe_Escolha3]            TINYINT       NULL,
    [vepe_Escolha4]            TINYINT       NULL,
    [vepe_Escolha5]            TINYINT       NULL,
    [vepe_Escolha6]            TINYINT       NULL,
    [vepe_Escolha7]            TINYINT       NULL,
    [vepe_Escolha8]            TINYINT       NULL,
    [vepe_Tipo1]               CHAR (1)      NOT NULL,
    [vepe_Tipo2]               CHAR (1)      NULL,
    [vepe_Tipo3]               CHAR (1)      NULL,
    [vepe_Tipo4]               CHAR (1)      NULL,
    [vepe_Tipo5]               CHAR (1)      NULL,
    [vepe_Tipo6]               CHAR (1)      NULL,
    [vepe_Tipo7]               CHAR (1)      NULL,
    [vepe_Tipo8]               CHAR (1)      NULL,
    [vepe_Valor1]              MONEY         NOT NULL,
    [vepe_Valor2]              MONEY         NULL,
    [vepe_Valor3]              MONEY         NULL,
    [vepe_Valor4]              MONEY         NULL,
    [vepe_Valor5]              MONEY         NULL,
    [vepe_Valor6]              MONEY         NULL,
    [vepe_Valor7]              MONEY         NULL,
    [vepe_Valor8]              MONEY         NULL,
    [vepe_Status]              CHAR (1)      NULL,
    [vepe_DtStatus]            SMALLDATETIME NULL,
    [vepe_ObservacaoEnt]       VARCHAR (600) NULL,
    [vepe_Montador]            INT           NULL,
    [vepe_PorcMontadora]       MONEY         NULL,
    [vepe_PorcAltamira]        MONEY         NULL,
    [vepe_PorcCliente]         MONEY         NULL,
    [vepe_Baixado]             CHAR (1)      NULL,
    [vepe_BaixaMontagem]       CHAR (1)      NULL,
    [vepe_DataDaBaixa]         SMALLDATETIME NULL,
    [vepe_DataPendente]        SMALLDATETIME NULL,
    [vepe_Autoriza]            TINYINT       NULL,
    [vepe_Aprovação]           SMALLINT      NULL,
    [vepe_Carro]               CHAR (10)     NULL,
    [vepe_Situação]            TINYINT       NULL,
    [vepe_Integra]             CHAR (1)      NULL,
    [vepe_DataCliente]         SMALLDATETIME NULL,
    [vepe_DataPgtoSinal]       SMALLDATETIME NULL,
    [vepe_DataPedidoOld]       SMALLDATETIME NULL,
    [vepe_Sinal]               CHAR (1)      NULL,
    [vepe_Acompanhamento]      CHAR (1)      NULL,
    [vepe_ObservacaoMontadora] VARCHAR (250) NULL,
    [vepe_Peso]                FLOAT (53)    NULL,
    [vepe_Lock]                BINARY (8)    NULL,
    CONSTRAINT [PK_VE_Pedidos] PRIMARY KEY NONCLUSTERED ([vepe_Pedido] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Pedidos]
    ON [dbo].[VE_Pedidos]([vepe_Cliente] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Pedidos_1]
    ON [dbo].[VE_Pedidos]([vepe_Projeto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Pedidos_2]
    ON [dbo].[VE_Pedidos]([vepe_Orcamento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_VE_Pedidos_3]
    ON [dbo].[VE_Pedidos]([vepe_NotaFiscal] ASC) WITH (FILLFACTOR = 90);


GO
GRANT SELECT
    ON OBJECT::[dbo].[VE_Pedidos] TO [interclick]
    AS [dbo];

