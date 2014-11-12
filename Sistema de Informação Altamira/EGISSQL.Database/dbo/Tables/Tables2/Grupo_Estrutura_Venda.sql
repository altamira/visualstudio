CREATE TABLE [dbo].[Grupo_Estrutura_Venda] (
    [cd_grupo_estrutura_venda]  INT          NOT NULL,
    [nm_grupo_estrutura_venda]  VARCHAR (30) NULL,
    [sg_grupo_estrutura_venda]  CHAR (10)    NULL,
    [ic_grupo_estrutura_venda]  CHAR (1)     NULL,
    [cd_mascara_grup_est_venda] VARCHAR (20) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_grupo_estrutura_pai]    INT          NULL,
    CONSTRAINT [PK_Grupo_Estrutura_Venda] PRIMARY KEY CLUSTERED ([cd_grupo_estrutura_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Estrutura_Venda_Grupo_Estrutura_Venda] FOREIGN KEY ([cd_grupo_estrutura_pai]) REFERENCES [dbo].[Grupo_Estrutura_Venda] ([cd_grupo_estrutura_venda])
);

