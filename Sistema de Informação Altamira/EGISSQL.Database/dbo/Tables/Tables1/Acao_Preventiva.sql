CREATE TABLE [dbo].[Acao_Preventiva] (
    [cd_acao_preventiva] INT          NOT NULL,
    [nm_acao_preventiva] VARCHAR (40) NULL,
    [sg_acao_preventiva] CHAR (10)    NULL,
    [ds_acao_preventiva] TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Acao_Preventiva] PRIMARY KEY CLUSTERED ([cd_acao_preventiva] ASC) WITH (FILLFACTOR = 90)
);

