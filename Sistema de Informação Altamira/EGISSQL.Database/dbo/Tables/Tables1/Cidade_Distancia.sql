CREATE TABLE [dbo].[Cidade_Distancia] (
    [cd_cidade_distancia] INT        IDENTITY (1, 1) NOT NULL,
    [cd_cidade_origem]    INT        NULL,
    [cd_cidade_destino]   INT        NULL,
    [qt_cidade_distancia] FLOAT (53) NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    [cd_pais]             INT        NULL,
    [cd_estado]           INT        NULL,
    CONSTRAINT [PK_Cidade_Distancia] PRIMARY KEY CLUSTERED ([cd_cidade_distancia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cidade_Distancia_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

