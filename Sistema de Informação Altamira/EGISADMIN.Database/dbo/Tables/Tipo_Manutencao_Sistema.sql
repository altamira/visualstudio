CREATE TABLE [dbo].[Tipo_Manutencao_Sistema] (
    [cd_tipo_manut_sistema] INT          NOT NULL,
    [nm_tipo_manut_sistema] VARCHAR (30) NOT NULL,
    [sg_tipo_manut_sistema] CHAR (10)    NOT NULL,
    [cd_imagem]             INT          NOT NULL,
    [ds_tipo_manut_sistema] TEXT         NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Manutencao_Sistema] PRIMARY KEY CLUSTERED ([cd_tipo_manut_sistema] ASC) WITH (FILLFACTOR = 90)
);

