CREATE TABLE [dbo].[Dr_Grupo] (
    [cd_dr_grupo]         INT          NOT NULL,
    [nm_dr_grupo]         VARCHAR (40) NULL,
    [sg_dr_grgrupo]       CHAR (10)    NULL,
    [qt_ordem_dr_grupo]   INT          NULL,
    [ds_dr_grrupo]        TEXT         NULL,
    [cd_procedimento]     INT          NULL,
    [ic_ativo_dr_grupo]   CHAR (1)     NULL,
    [ic_soma_dr_grupo]    CHAR (1)     NULL,
    [cd_tipo_dr]          INT          NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_dr_tipo]          INT          NULL,
    [cd_mascara_dr_grupo] VARCHAR (20) NULL,
    [ic_negrito_dr_grupo] CHAR (1)     NULL,
    [ic_traco_dr_grupo]   CHAR (1)     NULL,
    [ic_titulo_dr_grupo]  CHAR (1)     NULL,
    CONSTRAINT [PK_Dr_Grupo] PRIMARY KEY CLUSTERED ([cd_dr_grupo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Dr_Grupo_Dr_Tipo] FOREIGN KEY ([cd_dr_tipo]) REFERENCES [dbo].[Dr_Tipo] ([cd_dr_tipo])
);

