CREATE TABLE [dbo].[Tipo_Agente] (
    [cd_tipo_agente] INT          NOT NULL,
    [nm_tipo_agente] VARCHAR (40) NULL,
    [sg_tipo_agente] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Agente] PRIMARY KEY CLUSTERED ([cd_tipo_agente] ASC) WITH (FILLFACTOR = 90)
);

