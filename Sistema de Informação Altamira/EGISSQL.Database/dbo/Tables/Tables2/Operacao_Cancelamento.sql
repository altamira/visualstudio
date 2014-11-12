CREATE TABLE [dbo].[Operacao_Cancelamento] (
    [cd_operacao_cancelamento] INT          NOT NULL,
    [nm_operacao_cancelamento] VARCHAR (40) NULL,
    [sg_operacao_cancelamento] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Cancelamento] PRIMARY KEY CLUSTERED ([cd_operacao_cancelamento] ASC) WITH (FILLFACTOR = 90)
);

