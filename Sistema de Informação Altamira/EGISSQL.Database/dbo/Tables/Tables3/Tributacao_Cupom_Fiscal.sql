CREATE TABLE [dbo].[Tributacao_Cupom_Fiscal] (
    [cd_tributacao]          INT          NOT NULL,
    [nm_tributacao]          VARCHAR (40) NULL,
    [qt_parametro]           VARCHAR (5)  NULL,
    [pc_icms]                FLOAT (53)   NULL,
    [nm_obs_tributacao]      VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_totalizador_parcial] VARCHAR (10) NULL,
    CONSTRAINT [PK_Tributacao_Cupom_Fiscal] PRIMARY KEY CLUSTERED ([cd_tributacao] ASC) WITH (FILLFACTOR = 90)
);

