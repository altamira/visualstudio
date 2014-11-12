CREATE TABLE [dbo].[Processo_WorkFlow_Fluxo] (
    [cd_processo]                INT          NOT NULL,
    [cd_fluxo_processo]          INT          NOT NULL,
    [cd_departamento_origem]     INT          NULL,
    [cd_departamento_destino]    INT          NULL,
    [cd_aviso]                   INT          NULL,
    [nm_obs_fluxo_processo]      VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [nm_fluxo_processo]          VARCHAR (60) NULL,
    [cd_ordem_fluxo_processo]    INT          NULL,
    [cd_anterior_fluxo_processo] INT          NULL,
    [nm_fantasia_fluxo_processo] VARCHAR (20) NULL,
    [qt_altura]                  INT          NULL,
    [qt_comprimento]             FLOAT (53)   NULL,
    [ic_tipo_fluxo_processo]     CHAR (1)     NULL,
    [ic_imagem_fluxo_processo]   CHAR (1)     NULL,
    [cd_imagem]                  INT          NULL,
    [nm_cor_fluxo_processo]      VARCHAR (15) NULL,
    CONSTRAINT [PK_Processo_WorkFlow_Fluxo] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_fluxo_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_WorkFlow_Fluxo_Aviso_WorkFlow] FOREIGN KEY ([cd_aviso]) REFERENCES [dbo].[Aviso_WorkFlow] ([cd_aviso]),
    CONSTRAINT [FK_Processo_WorkFlow_Fluxo_Imagem] FOREIGN KEY ([cd_imagem]) REFERENCES [dbo].[Imagem] ([cd_imagem])
);

