CREATE TABLE [dbo].[Plano_MRP] (
    [cd_plano_mrp]         INT          NOT NULL,
    [nm_plano_mrp]         VARCHAR (60) NULL,
    [dt_plano_mrp]         DATETIME     NOT NULL,
    [qt_plano_mrp]         FLOAT (53)   NULL,
    [cd_origem_plano_mrp]  INT          NULL,
    [cd_status_plano_mrp]  INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [nm_obs_plano_mrp]     TEXT         NULL,
    [cd_departamento]      INT          NULL,
    [ic_gerado_plano_mrp]  CHAR (1)     NULL,
    [ic_processo_plano]    CHAR (1)     NULL,
    [ic_req_compra_plano]  CHAR (1)     NULL,
    [ic_req_interna_plano] CHAR (1)     NULL,
    CONSTRAINT [PK_Plano_MRP] PRIMARY KEY CLUSTERED ([cd_plano_mrp] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Plano_MRP_Status_Plano_MRP] FOREIGN KEY ([cd_status_plano_mrp]) REFERENCES [dbo].[Status_Plano_MRP] ([cd_status_plano_mrp])
);

