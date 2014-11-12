CREATE TABLE [dbo].[Status_Destinatario] (
    [cd_status_destinatario] INT          NOT NULL,
    [nm_status_destinatario] VARCHAR (40) NULL,
    [sg_status_destinatario] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Status_Destinatario] PRIMARY KEY CLUSTERED ([cd_status_destinatario] ASC) WITH (FILLFACTOR = 90)
);

