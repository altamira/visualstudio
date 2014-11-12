CREATE TABLE [dbo].[Ramo_Atividade] (
    [cd_ramo_atividade]         INT          NOT NULL,
    [nm_ramo_atividade]         VARCHAR (60) NOT NULL,
    [sg_ramo_atividade]         CHAR (10)    NULL,
    [pc_cliente_ramo_atividade] FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ds_ramo_atividade]         TEXT         NULL,
    [nm_especificacao_ramo]     VARCHAR (40) NULL,
    [qt_cliente_ramo_atividade] INT          NULL,
    [ic_analise_ramo_atividade] CHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([cd_ramo_atividade] ASC) WITH (FILLFACTOR = 90)
);

