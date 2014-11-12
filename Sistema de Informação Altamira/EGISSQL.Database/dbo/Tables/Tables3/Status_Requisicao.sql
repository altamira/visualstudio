CREATE TABLE [dbo].[Status_Requisicao] (
    [cd_status_requisicao] INT          NOT NULL,
    [nm_status_requisicao] VARCHAR (30) NOT NULL,
    [sg_status_requisicao] CHAR (10)    NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL
);

