CREATE TABLE [dbo].[Status_Parcela] (
    [cd_status_parcela] INT          NOT NULL,
    [nm_status_parcela] VARCHAR (20) NULL,
    [sg_status_parcela] CHAR (5)     NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Status_Parcela] PRIMARY KEY CLUSTERED ([cd_status_parcela] ASC) WITH (FILLFACTOR = 90)
);

