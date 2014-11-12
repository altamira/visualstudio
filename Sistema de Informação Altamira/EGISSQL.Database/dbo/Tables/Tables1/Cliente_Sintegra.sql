CREATE TABLE [dbo].[Cliente_Sintegra] (
    [cd_cliente]              INT          NOT NULL,
    [dt_cliente_sintegra]     DATETIME     NOT NULL,
    [cd_status_retorno]       INT          NULL,
    [cd_retorno]              INT          NULL,
    [nm_obs_cliente_sintegra] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Sintegra] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [dt_cliente_sintegra] ASC) WITH (FILLFACTOR = 90)
);

