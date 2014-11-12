CREATE TABLE [dbo].[Tipo_Contrato] (
    [cd_tipo_contrato]        INT          NOT NULL,
    [sg_tipo_contrato]        CHAR (10)    NULL,
    [nm_tipo_contrato]        VARCHAR (50) NULL,
    [nm_cam_tipo_contrato]    VARCHAR (50) NULL,
    [cd_cemiterio]            INT          NULL,
    [ds_tipo_contrato]        TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_tipo_contrato]        CHAR (1)     NULL,
    [nm_sufixo_tipo_contrato] VARCHAR (10) NULL,
    [cd_tipo_contrato_manut]  INT          NULL,
    CONSTRAINT [PK_Tipo_Contrato] PRIMARY KEY CLUSTERED ([cd_tipo_contrato] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Contrato_Tipo_Contrato_Manutencao] FOREIGN KEY ([cd_tipo_contrato_manut]) REFERENCES [dbo].[Tipo_Contrato_Manutencao] ([cd_tipo_contrato_manut])
);

