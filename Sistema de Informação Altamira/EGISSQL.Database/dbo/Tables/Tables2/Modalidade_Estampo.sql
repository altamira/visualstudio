CREATE TABLE [dbo].[Modalidade_Estampo] (
    [cd_modalidade_estampo] INT          NOT NULL,
    [nm_modalidade_estampo] VARCHAR (40) NULL,
    [sg_modalidade_estampo] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Modalidade_Estampo] PRIMARY KEY CLUSTERED ([cd_modalidade_estampo] ASC) WITH (FILLFACTOR = 90)
);

