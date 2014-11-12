CREATE TABLE [dbo].[Funcionario_Ferias] (
    [cd_funcionario]            INT          NOT NULL,
    [cd_item_funcionario]       INT          NOT NULL,
    [dt_inicio_ferias]          DATETIME     NULL,
    [dt_final_ferias]           DATETIME     NULL,
    [ic_recebe_adto_ferias]     CHAR (1)     NULL,
    [nm_obs_funcionario_ferias] VARCHAR (60) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [dt_vencimento_ferias]      DATETIME     NULL,
    [dt_inicio_a_ferias]        DATETIME     NULL,
    [dt_final_a_ferias]         DATETIME     NULL,
    [dt_inicio_g_ferias]        DATETIME     NULL,
    [dt_final_g_ferias]         DATETIME     NULL,
    [qt_dia_ferias]             INT          NULL,
    CONSTRAINT [PK_Funcionario_Ferias] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_item_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Ferias_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

