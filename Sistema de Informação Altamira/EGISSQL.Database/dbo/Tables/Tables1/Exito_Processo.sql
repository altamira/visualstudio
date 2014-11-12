CREATE TABLE [dbo].[Exito_Processo] (
    [cd_exito_processo] INT          NOT NULL,
    [nm_exito_processo] VARCHAR (40) NULL,
    [sg_exito_processo] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Exito_Processo] PRIMARY KEY CLUSTERED ([cd_exito_processo] ASC) WITH (FILLFACTOR = 90)
);

