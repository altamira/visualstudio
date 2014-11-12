CREATE TABLE [dbo].[Status_Invoice] (
    [cd_status_invoice] INT          NOT NULL,
    [nm_status_invoice] VARCHAR (30) NULL,
    [sg_status_invoice] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Status_Invoice] PRIMARY KEY CLUSTERED ([cd_status_invoice] ASC) WITH (FILLFACTOR = 90)
);

