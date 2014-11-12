CREATE TABLE [dbo].[Metodo_Valoracao] (
    [cd_metodo_valoracao]        INT          NOT NULL,
    [nm_metodo_valoracao]        VARCHAR (40) NULL,
    [sg_metodo_valoracao]        CHAR (10)    NULL,
    [ds_metodo_valoracao]        TEXT         NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [pc_metodo_valoracao]        FLOAT (53)   NULL,
    [qt_metodo_valoracao]        FLOAT (53)   NULL,
    [ic_peps_metodo]             CHAR (1)     NULL,
    [ic_custo_medio_metodo]      CHAR (1)     NULL,
    [ic_valor_metodo_valoracao]  CHAR (1)     NULL,
    [ic_controla_inventario]     CHAR (1)     NULL,
    [ic_padrao_metodo_valoracao] CHAR (1)     NULL,
    CONSTRAINT [PK_Metodo_Valoracao] PRIMARY KEY CLUSTERED ([cd_metodo_valoracao] ASC) WITH (FILLFACTOR = 90)
);

