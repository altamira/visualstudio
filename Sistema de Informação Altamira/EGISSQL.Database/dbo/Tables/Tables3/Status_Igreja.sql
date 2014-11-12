CREATE TABLE [dbo].[Status_Igreja] (
    [cd_status_igreja] INT          NOT NULL,
    [nm_status_igreja] VARCHAR (40) NULL,
    [sg_status_igreja] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Status_Igreja] PRIMARY KEY CLUSTERED ([cd_status_igreja] ASC) WITH (FILLFACTOR = 90)
);

