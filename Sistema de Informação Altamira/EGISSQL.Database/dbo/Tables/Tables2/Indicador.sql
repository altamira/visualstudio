CREATE TABLE [dbo].[Indicador] (
    [cd_indicador]           INT          NOT NULL,
    [nm_indicador]           VARCHAR (40) NULL,
    [ds_indicador]           TEXT         NULL,
    [ic_ativo_indicador]     CHAR (1)     NULL,
    [nm_obs_indicador]       VARCHAR (40) NULL,
    [vl_fator_indicador]     FLOAT (53)   NULL,
    [qt_padrao_indicador]    FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_modulo]              INT          NULL,
    [cd_procedimento]        INT          NULL,
    [ic_apresenta_indicador] CHAR (1)     NULL,
    [qt_tempo_apresentacao]  FLOAT (53)   NULL,
    [ic_tipo_indicador]      CHAR (1)     NULL,
    [ic_forma_apresentacao]  CHAR (1)     NULL,
    CONSTRAINT [PK_Indicador] PRIMARY KEY CLUSTERED ([cd_indicador] ASC) WITH (FILLFACTOR = 90)
);

