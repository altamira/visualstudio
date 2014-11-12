CREATE TABLE [dbo].[Estrutura_Empresa] (
    [cd_estrutura_empresa]      INT          NOT NULL,
    [nm_estrutura_empresa]      VARCHAR (40) NULL,
    [sg_estrutura_empresa]      CHAR (10)    NULL,
    [cd_grupo_empresa]          INT          NULL,
    [nm_mascara_estrut_empresa] VARCHAR (20) NULL,
    [cd_departamento]           INT          NULL,
    [cd_cargo]                  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_estrutura_empresa_pai]  INT          NULL,
    [cd_cor]                    INT          NULL,
    [cd_cor_texto]              INT          NULL,
    CONSTRAINT [PK_Estrutura_Empresa] PRIMARY KEY CLUSTERED ([cd_estrutura_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Estrutura_Empresa_Cargo] FOREIGN KEY ([cd_cargo]) REFERENCES [dbo].[Cargo] ([cd_cargo]),
    CONSTRAINT [FK_Estrutura_Empresa_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Estrutura_Empresa_Grupo_Empresa] FOREIGN KEY ([cd_grupo_empresa]) REFERENCES [dbo].[Grupo_Empresa] ([cd_grupo_empresa])
);

