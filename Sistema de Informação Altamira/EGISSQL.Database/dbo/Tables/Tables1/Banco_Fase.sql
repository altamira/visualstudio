CREATE TABLE [dbo].[Banco_Fase] (
    [cd_banco_fase] INT          NOT NULL,
    [nm_banco_fase] VARCHAR (40) NULL,
    [sg_banco_fase] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Banco_Fase] PRIMARY KEY CLUSTERED ([cd_banco_fase] ASC) WITH (FILLFACTOR = 90)
);

