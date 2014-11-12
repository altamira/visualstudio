CREATE TABLE [dbo].[Acao_Recomendada] (
    [cd_acao_recomendada] INT          NOT NULL,
    [nm_acao_recomendada] VARCHAR (50) NULL,
    [ds_acao_recomendada] TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Acao_Recomendada] PRIMARY KEY CLUSTERED ([cd_acao_recomendada] ASC) WITH (FILLFACTOR = 90)
);

