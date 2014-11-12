CREATE TABLE [dbo].[Plano_Producao] (
    [cd_plano_producao]         INT          NOT NULL,
    [cd_grupo_producao]         INT          NULL,
    [cd_mascara_plano_producao] VARCHAR (20) NULL,
    [nm_plano_producao]         VARCHAR (40) NULL,
    [sg_plano_producao]         CHAR (10)    NULL,
    [cd_plano_producao_pai]     INT          NULL,
    [cd_procedimento]           INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Plano_Producao] PRIMARY KEY CLUSTERED ([cd_plano_producao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Plano_Producao_Grupo_Producao] FOREIGN KEY ([cd_grupo_producao]) REFERENCES [dbo].[Grupo_Producao] ([cd_grupo_producao])
);

