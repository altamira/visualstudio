CREATE TABLE [dbo].[Processo_WorkFlow] (
    [cd_processo]             INT           NOT NULL,
    [nm_processo]             VARCHAR (60)  NULL,
    [dt_processo]             DATETIME      NULL,
    [nm_documento_processo]   VARCHAR (100) NULL,
    [nm_fluxo_processo]       VARCHAR (100) NULL,
    [ic_ativo_proceso]        CHAR (1)      NULL,
    [nm_obs_processo]         VARCHAR (40)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_departamento_destino] INT           NULL,
    [cd_departamento_Origem]  INT           NULL,
    CONSTRAINT [PK_Processo_WorkFlow] PRIMARY KEY CLUSTERED ([cd_processo] ASC) WITH (FILLFACTOR = 90)
);

