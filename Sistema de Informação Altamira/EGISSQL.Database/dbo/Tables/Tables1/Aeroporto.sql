CREATE TABLE [dbo].[Aeroporto] (
    [cd_aeroporto] INT          NOT NULL,
    [nm_aeroporto] VARCHAR (30) NULL,
    [sg_aeroporto] CHAR (5)     NULL,
    [cd_pais]      INT          NULL,
    [cd_estado]    INT          NULL,
    [cd_cidade]    INT          NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Aeroporto] PRIMARY KEY CLUSTERED ([cd_aeroporto] ASC) WITH (FILLFACTOR = 90)
);

