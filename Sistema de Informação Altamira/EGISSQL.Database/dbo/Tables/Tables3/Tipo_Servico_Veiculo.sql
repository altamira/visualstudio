CREATE TABLE [dbo].[Tipo_Servico_Veiculo] (
    [cd_tipo_servico_veiculo] INT          NOT NULL,
    [nm_tipo_servico_veiculo] VARCHAR (40) NULL,
    [sg_tipo_servico_veiculo] CHAR (10)    NULL,
    [ic_km_servico_veiculo]   CHAR (1)     NULL,
    [vl_tipo_servico_veiculo] FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_analise_consumo]      CHAR (1)     NULL,
    [ic_oleo_tipo_servico]    CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Servico_Veiculo] PRIMARY KEY CLUSTERED ([cd_tipo_servico_veiculo] ASC) WITH (FILLFACTOR = 90)
);

