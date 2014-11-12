CREATE TABLE [dbo].[Falta_Faixa_Ferias] (
    [cd_faixa]            INT          NOT NULL,
    [nm_faixa]            VARCHAR (40) NULL,
    [qt_dia_inicio_faixa] INT          NULL,
    [qt_dia_fim_faixa]    INT          NULL,
    [qt_dias_ferias]      INT          NULL,
    [nm_obs_faixa]        VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Falta_Faixa_Ferias] PRIMARY KEY CLUSTERED ([cd_faixa] ASC)
);

