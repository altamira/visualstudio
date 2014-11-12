CREATE TABLE [dbo].[Ciap_Calculo] (
    [cd_ciap]         INT      NOT NULL,
    [dt_ciap_calculo] DATETIME NULL,
    [ic_processado]   CHAR (1) NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Ciap_Calculo] PRIMARY KEY CLUSTERED ([cd_ciap] ASC) WITH (FILLFACTOR = 90)
);

