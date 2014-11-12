CREATE TABLE [dbo].[Centro_Custo] (
    [cd_centro_custo]         INT          NOT NULL,
    [nm_centro_custo]         VARCHAR (40) NULL,
    [sg_centro_custo]         CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_centro_custo]         TEXT         NULL,
    [ic_ativo_centro_custo]   CHAR (1)     NULL,
    [cd_tipo_mao_obra]        INT          NULL,
    [ic_total_centro_custo]   CHAR (1)     NULL,
    [cd_dr_tipo]              INT          NULL,
    [cd_mascara_centro_custo] VARCHAR (20) NULL,
    [ic_fluxo_centro_custo]   CHAR (1)     NULL,
    [cd_centro_custo_pai]     INT          NULL,
    [pc_producao_ativo]       FLOAT (53)   NULL,
    [qt_limite_req_viagem]    INT          NULL,
    [cd_assunto_viagem]       INT          NULL,
    [ic_neutral_centro_custo] CHAR (1)     NULL,
    CONSTRAINT [PK_Centro_Custo] PRIMARY KEY CLUSTERED ([cd_centro_custo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Custo_Assunto_Viagem] FOREIGN KEY ([cd_assunto_viagem]) REFERENCES [dbo].[Assunto_Viagem] ([cd_assunto_viagem]),
    CONSTRAINT [FK_Centro_Custo_Centro_Custo] FOREIGN KEY ([cd_centro_custo_pai]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Centro_Custo_Dr_Tipo] FOREIGN KEY ([cd_dr_tipo]) REFERENCES [dbo].[Dr_Tipo] ([cd_dr_tipo])
);

