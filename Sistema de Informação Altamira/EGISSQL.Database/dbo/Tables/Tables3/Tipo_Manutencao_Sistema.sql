CREATE TABLE [dbo].[Tipo_Manutencao_Sistema] (
    [cd_tipo_manutencao_sis] INT          NOT NULL,
    [nm_tipo_manutencao_sis] VARCHAR (30) NOT NULL,
    [sg_tipo_manutencao_sis] CHAR (10)    NOT NULL,
    [cd_imagem]              INT          NOT NULL,
    [ds_tipo_manutencao_sis] TEXT         NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Manutencao_Sistema] PRIMARY KEY CLUSTERED ([cd_tipo_manutencao_sis] ASC) WITH (FILLFACTOR = 90)
);

