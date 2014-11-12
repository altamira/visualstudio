CREATE TABLE [dbo].[Consulta_Parcela] (
    [cd_consulta]               INT          NOT NULL,
    [cd_parcela_consulta]       INT          NOT NULL,
    [dt_vcto_parcela_consulta]  DATETIME     NULL,
    [vl_parcela_consulta]       FLOAT (53)   NULL,
    [nm_obs_parcela_consulta]   VARCHAR (30) NULL,
    [ic_dt_especifica_consulta] CHAR (1)     NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [dt_vencto_parcela_consult] DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Parcela] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_parcela_consulta] ASC) WITH (FILLFACTOR = 90)
);

