CREATE TABLE [dbo].[FN_Previsao] (
    [fnpr_Sequencia] INT           NOT NULL,
    [fnpr_Tipo]      CHAR (1)      NOT NULL,
    [fnpr_Data]      SMALLDATETIME NOT NULL,
    [fnpr_Descricao] VARCHAR (50)  NOT NULL,
    [fnpr_Valor]     MONEY         NOT NULL,
    [fnpr_lock]      BINARY (8)    NULL
);

