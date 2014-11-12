CREATE TABLE [dbo].[Veiculo_Licenca] (
    [cd_veiculo]             INT          NOT NULL,
    [cd_tipo_licenca]        INT          NOT NULL,
    [cd_numero_licenca]      VARCHAR (30) NULL,
    [dt_emissao_licenca]     DATETIME     NULL,
    [dt_vencimento_licenca]  DATETIME     NULL,
    [ic_bloqueia_processo]   CHAR (1)     NULL,
    [nm_obs_veiculo_licenca] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Veiculo_Licenca] PRIMARY KEY CLUSTERED ([cd_veiculo] ASC, [cd_tipo_licenca] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Licenca_Tipo_Licenca] FOREIGN KEY ([cd_tipo_licenca]) REFERENCES [dbo].[Tipo_Licenca] ([cd_tipo_licenca])
);

