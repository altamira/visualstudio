CREATE TABLE [dbo].[Agricultura_Classificacao] (
    [cd_classificacao]          INT          NOT NULL,
    [nm_classificacao]          VARCHAR (60) NULL,
    [nm_fantasia_classificacao] VARCHAR (15) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Agricultura_Classificacao] PRIMARY KEY CLUSTERED ([cd_classificacao] ASC)
);

