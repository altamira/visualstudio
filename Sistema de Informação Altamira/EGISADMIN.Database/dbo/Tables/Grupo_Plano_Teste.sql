CREATE TABLE [dbo].[Grupo_Plano_Teste] (
    [cd_plano_teste]       INT          NOT NULL,
    [cd_grupo_plano_teste] INT          NOT NULL,
    [nm_grupo_plano_teste] VARCHAR (50) NULL,
    [ic_nivel_plano_teste] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Plano_Teste] PRIMARY KEY CLUSTERED ([cd_plano_teste] ASC, [cd_grupo_plano_teste] ASC) WITH (FILLFACTOR = 90)
);

