CREATE TABLE [dbo].[Cliente_Simulacao] (
    [cd_cliente]         INT       NOT NULL,
    [sg_regiao_geomapas] CHAR (10) NOT NULL,
    [cd_vendedor]        INT       NOT NULL,
    [ic_status]          CHAR (1)  NULL,
    [dt_simulacao]       DATETIME  NULL
);

