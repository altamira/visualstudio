CREATE TABLE [dbo].[Status_Di] (
    [cd_status_di] INT          NOT NULL,
    [nm_status_di] VARCHAR (30) NULL,
    [sg_status_di] CHAR (10)    NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Status_Di] PRIMARY KEY CLUSTERED ([cd_status_di] ASC) WITH (FILLFACTOR = 90)
);

