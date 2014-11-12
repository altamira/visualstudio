CREATE TABLE [dbo].[Tipo_Relatorio] (
    [cd_tipo_relatorio] INT          NOT NULL,
    [nm_tipo_relatorio] VARCHAR (40) NULL,
    [sg_tipo_relatorio] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Relatorio] PRIMARY KEY CLUSTERED ([cd_tipo_relatorio] ASC)
);

