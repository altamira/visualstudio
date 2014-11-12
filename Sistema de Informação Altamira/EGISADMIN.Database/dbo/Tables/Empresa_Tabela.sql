CREATE TABLE [dbo].[Empresa_Tabela] (
    [cd_empresa]            INT          NOT NULL,
    [cd_empresa_destino]    INT          NOT NULL,
    [cd_tabela]             INT          NOT NULL,
    [nm_obs_empresa_tabela] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Empresa_Tabela] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_empresa_destino] ASC, [cd_tabela] ASC) WITH (FILLFACTOR = 90)
);

