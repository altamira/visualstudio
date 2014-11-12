CREATE TABLE [dbo].[Status_Manutencao_Sistema] (
    [cd_status_manut_sistema] INT          NOT NULL,
    [nm_status_manut_sistema] VARCHAR (30) NOT NULL,
    [sg_status_manut_sistema] CHAR (10)    NOT NULL,
    [cd_imagem]               INT          NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Status_Manutencao_Sistema] PRIMARY KEY CLUSTERED ([cd_status_manut_sistema] ASC) WITH (FILLFACTOR = 90)
);

