CREATE TABLE [dbo].[Abisolo_Classificacao] (
    [cd_classificacao_abisolo]  INT          NOT NULL,
    [nm_classificacao_abisolo]  VARCHAR (60) NULL,
    [nm_fantasia_classificacao] VARCHAR (15) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Abisolo_Classificacao] PRIMARY KEY CLUSTERED ([cd_classificacao_abisolo] ASC)
);

