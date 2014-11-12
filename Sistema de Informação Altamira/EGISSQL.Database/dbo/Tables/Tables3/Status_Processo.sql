CREATE TABLE [dbo].[Status_Processo] (
    [cd_status_processo]     INT          NOT NULL,
    [nm_status_processo]     VARCHAR (30) NULL,
    [sg_status_processo]     CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_pad_status_processo] CHAR (1)     NULL,
    [ic_programacao]         CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Processo] PRIMARY KEY CLUSTERED ([cd_status_processo] ASC) WITH (FILLFACTOR = 90)
);

