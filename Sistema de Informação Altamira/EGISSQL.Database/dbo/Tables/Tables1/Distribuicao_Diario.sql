CREATE TABLE [dbo].[Distribuicao_Diario] (
    [cd_departamento]         INT          NOT NULL,
    [cd_usuario_distribuicao] INT          NOT NULL,
    [cd_distribuicao_diario]  INT          NOT NULL,
    [nm_obs_distrib_diario]   VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Distribuicao_Diario] PRIMARY KEY CLUSTERED ([cd_departamento] ASC, [cd_usuario_distribuicao] ASC, [cd_distribuicao_diario] ASC) WITH (FILLFACTOR = 90)
);

