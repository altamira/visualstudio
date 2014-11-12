CREATE TABLE [dbo].[Maquina_tipo] (
    [cd_tipo_maquina] INT          NOT NULL,
    [nm_tipo_maquina] VARCHAR (40) NOT NULL,
    [sg_tipo_maquina] CHAR (10)    NOT NULL,
    [cd_imagem]       INT          NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Maquina_tipo] PRIMARY KEY CLUSTERED ([cd_tipo_maquina] ASC) WITH (FILLFACTOR = 90)
);

