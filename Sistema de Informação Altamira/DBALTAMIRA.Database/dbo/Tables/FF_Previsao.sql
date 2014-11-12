CREATE TABLE [dbo].[FF_Previsao] (
    [ffpr_Sequencia] INT           NOT NULL,
    [ffpr_Tipo]      CHAR (1)      NOT NULL,
    [ffpr_Data]      SMALLDATETIME NOT NULL,
    [ffpr_Descricao] VARCHAR (50)  NOT NULL,
    [ffpr_Valor]     MONEY         NOT NULL,
    [ffpr_lock]      BINARY (8)    NULL
);

