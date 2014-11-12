CREATE TABLE [dbo].[Grupo_Gerencial] (
    [cd_grupo_gerencial]       INT          NOT NULL,
    [nm_grupo_gerencial]       VARCHAR (30) NULL,
    [nu_ordem]                 INT          NULL,
    [cd_ordem_grupo_gerencial] INT          NULL,
    [cd_procedimento]          INT          NULL,
    [nm_obs_grupo_gerencial]   VARCHAR (20) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_modulo]                INT          NULL,
    CONSTRAINT [PK_Grupo_Gerencial] PRIMARY KEY CLUSTERED ([cd_grupo_gerencial] ASC) WITH (FILLFACTOR = 90)
);

