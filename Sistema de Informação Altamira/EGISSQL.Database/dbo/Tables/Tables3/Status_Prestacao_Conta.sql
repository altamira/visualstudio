CREATE TABLE [dbo].[Status_Prestacao_Conta] (
    [cd_status_prestacao] INT          NOT NULL,
    [nm_status_prestacao] VARCHAR (40) NULL,
    [sg_status_prestacao] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Status_Prestacao_Conta] PRIMARY KEY CLUSTERED ([cd_status_prestacao] ASC) WITH (FILLFACTOR = 90)
);

