CREATE TABLE [dbo].[Etapa_Proposta] (
    [cd_etapa_proposta]       INT          NOT NULL,
    [nm_etapa_proposta]       VARCHAR (60) NULL,
    [ds_etapa_proposta]       TEXT         NULL,
    [ic_resp_etapa_proposta]  CHAR (1)     NULL,
    [nm_obs_etapa_proposta]   VARCHAR (40) NULL,
    [ic_ativa_etapa_proposta] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Etapa_Proposta] PRIMARY KEY CLUSTERED ([cd_etapa_proposta] ASC) WITH (FILLFACTOR = 90)
);

