CREATE TABLE [dbo].[Refrigeracao_Ferramenta] (
    [cd_refrig_ferramenta] INT          NOT NULL,
    [nm_refrig_ferramenta] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_refrig_ferramenta] VARCHAR (5)  COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    CONSTRAINT [PK_Refrigeracao_Ferramenta] PRIMARY KEY CLUSTERED ([cd_refrig_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

