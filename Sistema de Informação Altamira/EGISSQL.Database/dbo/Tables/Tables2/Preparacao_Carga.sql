CREATE TABLE [dbo].[Preparacao_Carga] (
    [cd_carga]         INT          NOT NULL,
    [dt_carga]         DATETIME     NULL,
    [cd_nota_saida]    INT          NULL,
    [nm_obs_carga]     VARCHAR (40) NULL,
    [cd_usuario_carga] INT          NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Preparacao_Carga] PRIMARY KEY CLUSTERED ([cd_carga] ASC)
);

