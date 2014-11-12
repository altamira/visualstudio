CREATE TABLE [dbo].[Status_Manutencao_Sistema] (
    [cd_status_manutencao_sis] INT          NOT NULL,
    [nm_status_manutencao_sis] VARCHAR (30) NOT NULL,
    [sg_status_manutencao_sis] CHAR (10)    NOT NULL,
    [cd_imagem]                INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Status_Manutencao_Sistema] PRIMARY KEY CLUSTERED ([cd_status_manutencao_sis] ASC) WITH (FILLFACTOR = 90)
);

