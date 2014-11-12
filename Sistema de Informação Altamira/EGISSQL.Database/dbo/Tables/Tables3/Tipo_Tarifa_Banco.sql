CREATE TABLE [dbo].[Tipo_Tarifa_Banco] (
    [cd_tipo_tarifa_banco]  INT          NOT NULL,
    [nm_tipo_tarifa_banco]  VARCHAR (40) NULL,
    [sg_tipo_tarifa_banco]  CHAR (10)    NULL,
    [vl_padrao_tipo_tarifa] FLOAT (53)   NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Tarifa_Banco] PRIMARY KEY CLUSTERED ([cd_tipo_tarifa_banco] ASC) WITH (FILLFACTOR = 90)
);

