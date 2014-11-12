CREATE TABLE [dbo].[Pontos_Chave_Relatorio_Repnet] (
    [cd_pontos_chave_rel] INT          NOT NULL,
    [sg_pontos_chave_rel] VARCHAR (10) NULL,
    [nm_pontos_chave_rel] VARCHAR (20) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Pontos_Chave_Relatorio_Repnet] PRIMARY KEY CLUSTERED ([cd_pontos_chave_rel] ASC) WITH (FILLFACTOR = 90)
);

