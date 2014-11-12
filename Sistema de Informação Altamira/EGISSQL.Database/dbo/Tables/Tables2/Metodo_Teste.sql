CREATE TABLE [dbo].[Metodo_Teste] (
    [cd_metodo_teste] INT          NOT NULL,
    [nm_metodo_teste] VARCHAR (40) NULL,
    [sg_metodo_teste] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Metodo_Teste] PRIMARY KEY CLUSTERED ([cd_metodo_teste] ASC) WITH (FILLFACTOR = 90)
);

