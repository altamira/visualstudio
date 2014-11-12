CREATE TABLE [dbo].[Status_Servidor] (
    [cd_status_servidor] INT          NOT NULL,
    [nm_status_servidor] VARCHAR (30) NOT NULL,
    [sg_status_servidor] VARCHAR (10) NOT NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Status_servidor] PRIMARY KEY NONCLUSTERED ([cd_status_servidor] ASC) WITH (FILLFACTOR = 90)
);

