CREATE TABLE [dbo].[Indicador_Contabilidade] (
    [cd_indicador]        INT          NOT NULL,
    [nm_indicador]        VARCHAR (40) NULL,
    [ic_ativo_indicador]  CHAR (1)     NULL,
    [cd_procedimento]     INT          NULL,
    [cd_view]             INT          NULL,
    [cd_funcao_sql]       INT          NULL,
    [ds_indicador]        TEXT         NULL,
    [qt_padrao_indicador] FLOAT (53)   NULL,
    [vl_fator_indicador]  FLOAT (53)   NULL,
    [nm_obs_indicador]    VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_ordem_indicador]  INT          NULL,
    CONSTRAINT [PK_Indicador_Contabilidade] PRIMARY KEY CLUSTERED ([cd_indicador] ASC) WITH (FILLFACTOR = 90)
);

