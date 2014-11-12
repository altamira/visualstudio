CREATE TABLE [dbo].[Status_Suporte] (
    [cd_status_suporte] INT          NOT NULL,
    [nm_status_suporte] VARCHAR (40) NULL,
    [sg_status_suporte] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Status_Suporte] PRIMARY KEY CLUSTERED ([cd_status_suporte] ASC) WITH (FILLFACTOR = 90)
);

