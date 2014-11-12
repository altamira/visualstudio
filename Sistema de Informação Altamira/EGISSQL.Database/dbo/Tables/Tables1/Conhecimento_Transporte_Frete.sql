CREATE TABLE [dbo].[Conhecimento_Transporte_Frete] (
    [cd_controle]        INT          NOT NULL,
    [cd_item_frete]      INT          NULL,
    [qt_peso_frete]      FLOAT (53)   NULL,
    [qt_volume_frete]    FLOAT (53)   NULL,
    [vl_frete]           FLOAT (53)   NULL,
    [vl_sec_cat]         FLOAT (53)   NULL,
    [vl_ctrcc]           FLOAT (53)   NULL,
    [vl_despacho]        FLOAT (53)   NULL,
    [vl_pedagio]         FLOAT (53)   NULL,
    [vl_outros]          FLOAT (53)   NULL,
    [vl_total_prestacao] FLOAT (53)   NULL,
    [vl_base_calculo]    FLOAT (53)   NULL,
    [pc_aliquota_icms]   FLOAT (53)   NULL,
    [vl_icms]            FLOAT (53)   NULL,
    [nm_obs_item_frete]  VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Conhecimento_Transporte_Frete] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90)
);

