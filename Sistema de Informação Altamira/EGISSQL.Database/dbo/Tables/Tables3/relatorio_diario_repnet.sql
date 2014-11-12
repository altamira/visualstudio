CREATE TABLE [dbo].[relatorio_diario_repnet] (
    [cd_rel_diario]           INT          NOT NULL,
    [nm_cliente_rel_diario]   VARCHAR (40) NULL,
    [nm_filial_rel_diario]    VARCHAR (30) NULL,
    [nm_vendedor_rel_diario]  VARCHAR (25) NULL,
    [dt_rel_diario]           DATETIME     NULL,
    [ds_rel_diario]           TEXT         NULL,
    [ic_conta_nac_rel_diario] CHAR (1)     NULL,
    [ic_oem_rel_diario]       CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_relatorio_diario_repnet] PRIMARY KEY CLUSTERED ([cd_rel_diario] ASC) WITH (FILLFACTOR = 90)
);

