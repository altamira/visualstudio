CREATE TABLE [dbo].[Status_Cobranca] (
    [cd_status_cobraca]  INT          NOT NULL,
    [nm_status_cobranca] VARCHAR (40) NULL,
    [sg_status_cobranca] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Status_Cobranca] PRIMARY KEY CLUSTERED ([cd_status_cobraca] ASC) WITH (FILLFACTOR = 90)
);

