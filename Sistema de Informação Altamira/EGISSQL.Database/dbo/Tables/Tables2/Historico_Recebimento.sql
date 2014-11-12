CREATE TABLE [dbo].[Historico_Recebimento] (
    [cd_historico_recebimento] INT          NOT NULL,
    [nm_historico_recebimento] VARCHAR (40) NULL,
    [sg_historico_recebimento] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Historico_Recebimento] PRIMARY KEY CLUSTERED ([cd_historico_recebimento] ASC) WITH (FILLFACTOR = 90)
);

