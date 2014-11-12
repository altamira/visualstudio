CREATE TABLE [dbo].[Processo_Juridico_Recurso] (
    [cd_processo_recurso]     INT          NOT NULL,
    [dt_processo_recurso]     DATETIME     NULL,
    [cd_processo_juridico]    INT          NOT NULL,
    [cd_tribunal]             INT          NULL,
    [cd_instancia_processo]   INT          NULL,
    [cd_recurso_processo]     VARCHAR (40) NULL,
    [nm_registro_recurso]     VARCHAR (40) NULL,
    [ds_processo_recurso]     TEXT         NULL,
    [cd_advogado]             INT          NULL,
    [nm_obs_processo_recurso] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Processo_Juridico_Recurso] PRIMARY KEY CLUSTERED ([cd_processo_recurso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Recurso_Advogado] FOREIGN KEY ([cd_advogado]) REFERENCES [dbo].[Advogado] ([cd_advogado])
);

