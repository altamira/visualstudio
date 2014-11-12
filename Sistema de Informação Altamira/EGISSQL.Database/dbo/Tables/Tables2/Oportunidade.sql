CREATE TABLE [dbo].[Oportunidade] (
    [cd_oportunidade]     INT          NOT NULL,
    [dt_oportunidade]     DATETIME     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [nm_obs_oportunidade] VARCHAR (40) NULL,
    [cd_ordem_servico]    INT          NULL,
    [ic_tipo_servico]     CHAR (1)     NULL,
    [dt_fim_servico]      DATETIME     NULL,
    [dt_inicio_servico]   DATETIME     NULL,
    CONSTRAINT [PK_Oportunidade] PRIMARY KEY CLUSTERED ([cd_oportunidade] ASC) WITH (FILLFACTOR = 90)
);

