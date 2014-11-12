CREATE TABLE [dbo].[Acao_Corretiva] (
    [cd_acao_corretiva] INT          NOT NULL,
    [nm_acao_corretiva] VARCHAR (40) NULL,
    [sg_acao_corretiva] CHAR (10)    NULL,
    [ds_acao_corretiva] TEXT         NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Acao_Corretiva] PRIMARY KEY CLUSTERED ([cd_acao_corretiva] ASC) WITH (FILLFACTOR = 90)
);

