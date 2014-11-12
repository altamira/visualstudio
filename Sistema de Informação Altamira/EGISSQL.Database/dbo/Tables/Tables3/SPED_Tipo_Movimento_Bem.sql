CREATE TABLE [dbo].[SPED_Tipo_Movimento_Bem] (
    [cd_tipo_movimento] INT          NOT NULL,
    [nm_tipo_movimento] VARCHAR (60) NULL,
    [sg_tipo_movimento] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_SPED_Tipo_Movimento_Bem] PRIMARY KEY CLUSTERED ([cd_tipo_movimento] ASC)
);

