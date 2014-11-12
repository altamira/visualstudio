CREATE TABLE [dbo].[Coeficiente_CIAP] (
    [cd_coeficiente]           INT          NOT NULL,
    [cd_ano]                   INT          NOT NULL,
    [cd_mes]                   INT          NULL,
    [vl_total_saida_tributada] FLOAT (53)   NULL,
    [vl_total_saida]           FLOAT (53)   NULL,
    [pc_creditamento_ciap]     FLOAT (53)   NULL,
    [nm_obs_coeficiente_ciap]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [vl_saldo_ciap]            FLOAT (53)   NULL,
    [qt_mes_apropriacao]       INT          NULL,
    [vl_credito_ciap]          FLOAT (53)   NULL,
    [cd_local_bem]             INT          NULL,
    [ic_usa_perc_ciap_bem]     CHAR (1)     NULL,
    CONSTRAINT [PK_Coeficiente_CIAP] PRIMARY KEY CLUSTERED ([cd_coeficiente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Coeficiente_CIAP_Local_Bem_Ciap] FOREIGN KEY ([cd_local_bem]) REFERENCES [dbo].[Local_Bem_Ciap] ([cd_local_bem])
);

