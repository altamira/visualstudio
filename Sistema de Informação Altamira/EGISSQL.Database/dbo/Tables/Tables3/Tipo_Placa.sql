CREATE TABLE [dbo].[Tipo_Placa] (
    [cd_tipo_placa]            INT          NOT NULL,
    [nm_tipo_placa]            VARCHAR (50) NOT NULL,
    [sg_tipo_placa]            CHAR (15)    NULL,
    [ic_sobremetal_orcamento]  CHAR (1)     NULL,
    [cdc_usuario]              INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_tolerancia_sobremetal] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Placa] PRIMARY KEY CLUSTERED ([cd_tipo_placa] ASC) WITH (FILLFACTOR = 90)
);

