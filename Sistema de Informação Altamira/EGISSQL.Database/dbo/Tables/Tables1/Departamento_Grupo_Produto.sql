CREATE TABLE [dbo].[Departamento_Grupo_Produto] (
    [cd_departamento]         INT          NOT NULL,
    [cd_grupo_produto]        INT          NOT NULL,
    [nm_obs_depto_grupo_prod] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Departamento_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_departamento] ASC, [cd_grupo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Grupo_Produto_Grupo_Produto] FOREIGN KEY ([cd_grupo_produto]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto])
);

