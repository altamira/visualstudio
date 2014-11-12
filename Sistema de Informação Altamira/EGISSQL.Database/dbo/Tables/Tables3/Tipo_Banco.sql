CREATE TABLE [dbo].[Tipo_Banco] (
    [cd_banco]             INT          NOT NULL,
    [cd_tipo_tarifa_banco] INT          NOT NULL,
    [vl_tarifa_banco]      FLOAT (53)   NULL,
    [nm_obs_tarifa_banco]  VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Banco] PRIMARY KEY CLUSTERED ([cd_banco] ASC, [cd_tipo_tarifa_banco] ASC) WITH (FILLFACTOR = 90)
);

