CREATE TABLE [dbo].[Tipo_Promocao] (
    [cd_tipo_promocao] INT          NOT NULL,
    [nm_tipo_promocao] VARCHAR (40) NULL,
    [sg_tipo_promocao] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Promocao] PRIMARY KEY CLUSTERED ([cd_tipo_promocao] ASC) WITH (FILLFACTOR = 90)
);

