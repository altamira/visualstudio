CREATE TABLE [dbo].[Status_Pendencia] (
    [cd_status_pendencia] INT          NOT NULL,
    [nm_status_pendencia] VARCHAR (40) NULL,
    [sg_status_pendencia] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Status_Pendencia] PRIMARY KEY CLUSTERED ([cd_status_pendencia] ASC) WITH (FILLFACTOR = 90)
);

