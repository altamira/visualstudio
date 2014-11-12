CREATE TABLE [dbo].[Status_Meta] (
    [cd_status_meta] INT          NOT NULL,
    [nm_status_meta] VARCHAR (40) NULL,
    [sg_status_meta] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Status_Meta] PRIMARY KEY CLUSTERED ([cd_status_meta] ASC) WITH (FILLFACTOR = 90)
);

