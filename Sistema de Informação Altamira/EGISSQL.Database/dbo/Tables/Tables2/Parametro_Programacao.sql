CREATE TABLE [dbo].[Parametro_Programacao] (
    [cd_empresa]                  INT      NOT NULL,
    [ic_mostra_comp_processo]     CHAR (1) NULL,
    [ic_ordem_comp_processo]      CHAR (1) NULL,
    [ic_layout_ordem_servico]     CHAR (1) NULL,
    [ic_projeto_programacao]      CHAR (1) NULL,
    [ic_pedido_programacao]       CHAR (1) NULL,
    [ic_mapa_disponibilidade]     CHAR (1) NULL,
    [dt_usuario]                  DATETIME NULL,
    [cd_usuario]                  INT      NULL,
    [ic_apontamento_bx_prog]      CHAR (1) NULL,
    [ic_horario_programacao]      CHAR (1) NULL,
    [ic_tipo_programacao]         CHAR (1) NULL,
    [ic_alfa_maquina_programacao] CHAR (1) NULL,
    [ds_texto_ordem_servico]      TEXT     NULL,
    [ic_conv_hora_programacao]    CHAR (1) NULL,
    [ic_qtd_programacao]          CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Programacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

