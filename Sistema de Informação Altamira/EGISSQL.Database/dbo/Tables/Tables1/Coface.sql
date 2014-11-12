CREATE TABLE [dbo].[Coface] (
    [cd_coface]            INT          NOT NULL,
    [dt_coface]            DATETIME     NULL,
    [cd_exportador]        INT          NULL,
    [cd_cliente]           INT          NULL,
    [cd_pais]              INT          NULL,
    [cd_banco]             INT          NULL,
    [vl_solicitado_coface] FLOAT (53)   NULL,
    [vl_aceito_coface]     FLOAT (53)   NULL,
    [vl_provisorio_coface] FLOAT (53)   NULL,
    [dt_provisorio_coface] DATETIME     NULL,
    [cd_status_coface]     INT          NULL,
    [cd_cliente_coface]    INT          NULL,
    [nm_obs_coface]        VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Coface] PRIMARY KEY CLUSTERED ([cd_coface] ASC) WITH (FILLFACTOR = 90)
);

