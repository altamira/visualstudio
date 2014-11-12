CREATE TABLE [dbo].[Unidade_Empresa] (
    [cd_unidade_empresa]  INT          NOT NULL,
    [nm_unidade_empresa]  VARCHAR (60) NULL,
    [nm_fantasia_unidade] VARCHAR (15) NULL,
    [sg_unidade_empresa]  CHAR (10)    NULL,
    [cd_pais]             INT          NULL,
    [cd_inter_unidade]    VARCHAR (15) NULL,
    [nm_obs_unidade]      VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Unidade_Empresa] PRIMARY KEY CLUSTERED ([cd_unidade_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Unidade_Empresa_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

