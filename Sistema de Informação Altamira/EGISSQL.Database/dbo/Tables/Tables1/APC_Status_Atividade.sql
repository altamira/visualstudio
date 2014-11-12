CREATE TABLE [dbo].[APC_Status_Atividade] (
    [cd_status_atividade] INT          NOT NULL,
    [nm_status_atividade] VARCHAR (40) NULL,
    [sg_status_atividade] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_APC_Status_Atividade] PRIMARY KEY CLUSTERED ([cd_status_atividade] ASC)
);

