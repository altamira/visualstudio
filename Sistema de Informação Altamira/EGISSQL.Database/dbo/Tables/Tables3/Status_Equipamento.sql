CREATE TABLE [dbo].[Status_Equipamento] (
    [cd_status_equipamento] INT          NOT NULL,
    [nm_status_equipamento] VARCHAR (30) NULL,
    [sg_status_equipamento] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_status_equipamento] PRIMARY KEY CLUSTERED ([cd_status_equipamento] ASC) WITH (FILLFACTOR = 90)
);

