CREATE TABLE [dbo].[Cliente_Grupo] (
    [cd_cliente_grupo]          INT          NOT NULL,
    [nm_cliente_grupo]          VARCHAR (30) NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [cd_criterio_visita]        INT          NULL,
    [qt_freq_visit_client_grup] FLOAT (53)   NULL,
    [qt_final_cliente_grupo]    FLOAT (53)   NULL,
    [qt_inicial_cliente_grupo]  FLOAT (53)   NULL,
    [vl_final_cliente_grupo]    FLOAT (53)   NULL,
    [vl_inicial_cliente_grupo]  FLOAT (53)   NULL,
    [sg_cliente_grupo]          CHAR (10)    NULL,
    [pc_desconto_cliente_grupo] FLOAT (53)   NULL,
    [ic_ativo_cliente_grupo]    CHAR (1)     NULL,
    [nm_obs_cliente_grupo]      VARCHAR (40) NULL,
    [ds_cliente_grupo]          TEXT         NULL,
    [pc_desconto_tabela_grupo]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Cliente_Grupo] PRIMARY KEY CLUSTERED ([cd_cliente_grupo] ASC) WITH (FILLFACTOR = 90)
);

