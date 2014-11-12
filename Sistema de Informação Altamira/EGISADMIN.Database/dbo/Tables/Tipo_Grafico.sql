CREATE TABLE [dbo].[Tipo_Grafico] (
    [cd_tipo_grafico]         INT          NOT NULL,
    [nm_tipo_grafico]         VARCHAR (30) NOT NULL,
    [sg_tipo_grafico]         CHAR (10)    NOT NULL,
    [ic_3d_tipo_grafico]      CHAR (1)     NOT NULL,
    [cd_imagem]               INT          NOT NULL,
    [nm_arquivo_tipo_grafico] VARCHAR (10) NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Grafico] PRIMARY KEY CLUSTERED ([cd_tipo_grafico] ASC) WITH (FILLFACTOR = 90)
);

