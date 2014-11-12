CREATE TABLE [dbo].[Amostra_Modelo] (
    [cd_amostra_modelo] INT          NOT NULL,
    [nm_amostra_modelo] VARCHAR (50) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Amostra_Modelo] PRIMARY KEY CLUSTERED ([cd_amostra_modelo] ASC) WITH (FILLFACTOR = 90)
);

