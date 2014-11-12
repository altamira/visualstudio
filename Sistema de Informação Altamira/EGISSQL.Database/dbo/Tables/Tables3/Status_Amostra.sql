CREATE TABLE [dbo].[Status_Amostra] (
    [cd_status_amostra] INT          NOT NULL,
    [nm_status_amostra] VARCHAR (30) NULL,
    [sg_status_amostra] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [ds_status_amostra] TEXT         NULL,
    CONSTRAINT [PK_Status_Amostra] PRIMARY KEY CLUSTERED ([cd_status_amostra] ASC) WITH (FILLFACTOR = 90)
);

