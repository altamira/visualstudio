CREATE TABLE [dbo].[Tipo_Movimento_Evento] (
    [cd_tipo_movimento_evento] INT          NOT NULL,
    [nm_tipo_movimento_evento] VARCHAR (40) NULL,
    [sg_tipo_movimento_evento] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Movimento_Evento] PRIMARY KEY CLUSTERED ([cd_tipo_movimento_evento] ASC) WITH (FILLFACTOR = 90)
);

