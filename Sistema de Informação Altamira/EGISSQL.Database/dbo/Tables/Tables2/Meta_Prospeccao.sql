CREATE TABLE [dbo].[Meta_Prospeccao] (
    [cd_empresa]              INT          NOT NULL,
    [dt_inicio_prospeccao]    DATETIME     NOT NULL,
    [dt_fim_prospeccao]       DATETIME     NOT NULL,
    [qt_ligacao_meta]         INT          NULL,
    [qt_visita_meta]          INT          NULL,
    [qt_apresentacao_meta]    INT          NULL,
    [ic_padrao_meta]          CHAR (1)     NULL,
    [nm_obs_meta]             VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [qt_meta_pipe_prospeccao] FLOAT (53)   NULL,
    CONSTRAINT [PK_Meta_Prospeccao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [dt_inicio_prospeccao] ASC, [dt_fim_prospeccao] ASC) WITH (FILLFACTOR = 90)
);

