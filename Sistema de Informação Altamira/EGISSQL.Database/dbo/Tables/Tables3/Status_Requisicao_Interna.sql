CREATE TABLE [dbo].[Status_Requisicao_Interna] (
    [cd_status_requisicao] INT          NOT NULL,
    [nm_status_requisicao] VARCHAR (30) NULL,
    [sg_status_requisicao] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Status_Requisicao_Interna] PRIMARY KEY CLUSTERED ([cd_status_requisicao] ASC)
);

