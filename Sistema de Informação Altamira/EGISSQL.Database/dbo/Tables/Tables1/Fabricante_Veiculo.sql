CREATE TABLE [dbo].[Fabricante_Veiculo] (
    [cd_fabricante_veiculo]     INT           NOT NULL,
    [nm_fabricante_veiculo]     VARCHAR (30)  NULL,
    [sg_fabricante_veiculo]     CHAR (10)     NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_obs_fabricante_veiculo] VARCHAR (40)  NULL,
    [nm_logotipo_fabricante]    VARCHAR (100) NULL,
    CONSTRAINT [PK_Fabricante_Veiculo] PRIMARY KEY CLUSTERED ([cd_fabricante_veiculo] ASC) WITH (FILLFACTOR = 90)
);

