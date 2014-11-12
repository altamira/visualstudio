CREATE TABLE [dbo].[Etiqueta_Tipo_Layout] (
    [cd_etiqueta_tipo_layout] INT          NOT NULL,
    [nm_etiqueta_tipo_layout] VARCHAR (30) NULL,
    [sg_etiqueta_tipo_layout] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tam_altura_etiqueta]  INT          NULL,
    [cd_tam_largura_etiqueta] INT          NULL,
    CONSTRAINT [PK_Etiqueta_Tipo_Layout] PRIMARY KEY CLUSTERED ([cd_etiqueta_tipo_layout] ASC) WITH (FILLFACTOR = 90)
);

