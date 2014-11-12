CREATE TABLE [dbo].[Estilo_Grafico] (
    [cd_tipo_grafico]   INT          NOT NULL,
    [cd_estilo_grafico] INT          NOT NULL,
    [nm_estilo_grafico] VARCHAR (40) NOT NULL,
    [sg_estilo_grafico] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    CONSTRAINT [PK_Estilo_Grafico] PRIMARY KEY CLUSTERED ([cd_tipo_grafico] ASC, [cd_estilo_grafico] ASC) WITH (FILLFACTOR = 90)
);

