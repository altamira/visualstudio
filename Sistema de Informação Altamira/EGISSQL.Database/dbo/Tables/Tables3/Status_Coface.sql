CREATE TABLE [dbo].[Status_Coface] (
    [cd_status_coface] INT          NOT NULL,
    [nm_status_coface] VARCHAR (40) NULL,
    [sg_status_coface] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Status_Coface] PRIMARY KEY CLUSTERED ([cd_status_coface] ASC) WITH (FILLFACTOR = 90)
);

