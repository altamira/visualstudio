CREATE TABLE [dbo].[Transporte_Adicional] (
    [cd_transporte_adicional] INT          NOT NULL,
    [nm_transporte_adicional] VARCHAR (40) NULL,
    [sg_transporte_adicional] CHAR (10)    NULL,
    [vl_transporte_adcional]  FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Transporte_Adicional] PRIMARY KEY CLUSTERED ([cd_transporte_adicional] ASC) WITH (FILLFACTOR = 90)
);

