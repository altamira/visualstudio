CREATE TABLE [dbo].[Status_Contrato] (
    [cd_status_contrato] INT          NOT NULL,
    [nm_status_contrato] VARCHAR (30) NULL,
    [sg_status_contrato] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [ic_gera_isencao]    CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Contrato] PRIMARY KEY CLUSTERED ([cd_status_contrato] ASC) WITH (FILLFACTOR = 90)
);

