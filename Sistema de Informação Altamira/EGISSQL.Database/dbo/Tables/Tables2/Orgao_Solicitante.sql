CREATE TABLE [dbo].[Orgao_Solicitante] (
    [cd_orgao_solicitante]         INT          NOT NULL,
    [nm_orgao_solicitante]         VARCHAR (40) NULL,
    [sg_orgao_solicitante]         CHAR (10)    NULL,
    [ic_governo_orgao_solicitante] CHAR (1)     NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [nm_obs_orgao_solicitante]     VARCHAR (40) NULL,
    CONSTRAINT [PK_Orgao_Solicitante] PRIMARY KEY CLUSTERED ([cd_orgao_solicitante] ASC) WITH (FILLFACTOR = 90)
);

