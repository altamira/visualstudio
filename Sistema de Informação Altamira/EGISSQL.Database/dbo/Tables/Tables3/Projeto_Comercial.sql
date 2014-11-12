CREATE TABLE [dbo].[Projeto_Comercial] (
    [cd_projeto_comercial]     INT          NOT NULL,
    [nm_projeto_comercial]     VARCHAR (60) NULL,
    [dt_projeto_comercial]     DATETIME     NULL,
    [cd_identificacao_projeto] VARCHAR (15) NULL,
    [cd_cliente]               INT          NULL,
    [cd_vendedor]              INT          NULL,
    [cd_ramo_atividade]        INT          NULL,
    [nm_area_atuacao]          VARCHAR (40) NULL,
    [nm_responsavel_projeto]   VARCHAR (40) NULL,
    [dt_contato_projeto]       DATETIME     NULL,
    [ds_participante_projeto]  TEXT         NULL,
    [ds_projeto_comercial]     TEXT         NULL,
    [cd_status_projeto]        INT          NULL,
    [dt_cancelamento_projeto]  DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Projeto_Comercial] PRIMARY KEY CLUSTERED ([cd_projeto_comercial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Comercial_Status_Projeto] FOREIGN KEY ([cd_status_projeto]) REFERENCES [dbo].[Status_Projeto] ([cd_status_projeto])
);

