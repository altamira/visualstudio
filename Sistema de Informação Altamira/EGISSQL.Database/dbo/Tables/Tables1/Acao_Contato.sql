CREATE TABLE [dbo].[Acao_Contato] (
    [cd_acao_contato] INT          NOT NULL,
    [nm_acao_contato] VARCHAR (40) NULL,
    [ds_acao_contato] TEXT         NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Acao_Contato] PRIMARY KEY CLUSTERED ([cd_acao_contato] ASC) WITH (FILLFACTOR = 90)
);

