CREATE TABLE [dbo].[Instancia_Processo] (
    [cd_instancia_processo] INT          NOT NULL,
    [nm_instancia_processo] VARCHAR (40) NULL,
    [sg_instancia_processo] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Instancia_Processo] PRIMARY KEY CLUSTERED ([cd_instancia_processo] ASC) WITH (FILLFACTOR = 90)
);

