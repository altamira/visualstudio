CREATE TABLE [dbo].[Grupo_Servico] (
    [cd_grupo_servico]         INT          NOT NULL,
    [nm_grupo_servico]         VARCHAR (40) NOT NULL,
    [sg_grupo_servico]         CHAR (10)    NOT NULL,
    [cd_mascara_grupo_servico] INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ds_grupo_servico]         TEXT         NULL,
    [cd_iss_grupo_servico]     INT          NULL,
    CONSTRAINT [PK_Grupo_Servico] PRIMARY KEY CLUSTERED ([cd_grupo_servico] ASC) WITH (FILLFACTOR = 90)
);

