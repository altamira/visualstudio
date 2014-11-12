CREATE TABLE [dbo].[APC_Status_Processo] (
    [cd_status_processo] INT          NOT NULL,
    [nm_status_processo] VARCHAR (40) NULL,
    [sg_status_processo] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_APC_Status_Processo] PRIMARY KEY CLUSTERED ([cd_status_processo] ASC)
);

