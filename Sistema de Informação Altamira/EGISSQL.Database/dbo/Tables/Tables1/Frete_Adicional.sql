CREATE TABLE [dbo].[Frete_Adicional] (
    [cd_frete_adicional] INT          NOT NULL,
    [nm_frete_adicional] VARCHAR (40) NULL,
    [sg_frete_adicional] CHAR (10)    NULL,
    [vl_frete_adcional]  FLOAT (53)   NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Frete_Adicional] PRIMARY KEY CLUSTERED ([cd_frete_adicional] ASC) WITH (FILLFACTOR = 90)
);

