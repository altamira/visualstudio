CREATE TABLE [dbo].[Fechamento_Mensal] (
    [cd_ano]                 INT      NOT NULL,
    [cd_mes]                 INT      NOT NULL,
    [cd_departamento]        INT      NULL,
    [ic_mes_fechado]         CHAR (1) NULL,
    [ic_mes_fechado_reserva] CHAR (1) NULL,
    [cd_modulo]              INT      NULL,
    [cd_usuario]             INT      NOT NULL,
    [dt_usuario]             DATETIME NOT NULL,
    [ic_scp]                 CHAR (1) NULL,
    [ic_sce]                 CHAR (1) NULL,
    [ic_scr]                 CHAR (1) NULL,
    [ic_sfp]                 CHAR (1) NULL,
    [ic_slf]                 CHAR (1) NULL,
    [ic_sct]                 CHAR (1) NULL,
    [ic_peps]                CHAR (1) NULL,
    [ic_custo_medio]         CHAR (1) NULL,
    [ic_registro_inventario] CHAR (1) NULL,
    [ic_ajuste_pis_cofins]   CHAR (1) NULL,
    CONSTRAINT [PK_Fechamento_Mensal] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_mes] ASC) WITH (FILLFACTOR = 90)
);

