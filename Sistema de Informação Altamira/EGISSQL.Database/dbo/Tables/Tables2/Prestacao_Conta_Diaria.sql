CREATE TABLE [dbo].[Prestacao_Conta_Diaria] (
    [cd_prestacao_diaria]       INT          NOT NULL,
    [cd_prestacao]              INT          NOT NULL,
    [cd_item_prestacao_diaria]  INT          NOT NULL,
    [hr_inicio_diaria]          VARCHAR (8)  NULL,
    [hr_fim_diaria]             VARCHAR (8)  NULL,
    [qt_item_total_diaria]      FLOAT (53)   NULL,
    [nm_obs_item_diaria]        VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [dt_diaria_prestacao]       DATETIME     NULL,
    [cd_tipo_diaria]            INT          NULL,
    [qt_item_diaria]            FLOAT (53)   NULL,
    [vl_unitario_diaria]        FLOAT (53)   NULL,
    [vl_total_diaria_prestacao] FLOAT (53)   NULL,
    [dt_fim_diaria_prestacao]   DATETIME     NULL,
    CONSTRAINT [PK_Prestacao_Conta_Diaria] PRIMARY KEY CLUSTERED ([cd_prestacao_diaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Prestacao_Conta_Diaria_Prestacao_Conta] FOREIGN KEY ([cd_prestacao]) REFERENCES [dbo].[Prestacao_Conta] ([cd_prestacao])
);

