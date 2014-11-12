CREATE TABLE [dbo].[Status_Manutencao] (
    [cd_status_manut]     INT       NOT NULL,
    [nm_status_manut]     CHAR (20) NOT NULL,
    [sg_status_manut]     CHAR (3)  NOT NULL,
    [cd_imagem]           INT       NULL,
    [cd_usuario_atualiza] INT       NULL,
    [dt_atualiza]         DATETIME  NULL,
    CONSTRAINT [PK_Status_Manutencao] PRIMARY KEY CLUSTERED ([cd_status_manut] ASC) WITH (FILLFACTOR = 90)
);

