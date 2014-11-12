CREATE TABLE [dbo].[Ferramenta_Calibracao_Composicao] (
    [cd_ferramenta]         INT          NOT NULL,
    [cd_item_calibracao]    INT          NOT NULL,
    [nm_escala_calibracao]  VARCHAR (40) NULL,
    [nm_faixa_calibracao]   VARCHAR (40) NULL,
    [cd_unidade_medida]     INT          NULL,
    [qt_criterio_aceitacao] FLOAT (53)   NULL,
    [nm_obs_calibracao]     VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Ferramenta_Calibracao_Composicao] PRIMARY KEY CLUSTERED ([cd_ferramenta] ASC, [cd_item_calibracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ferramenta_Calibracao_Composicao_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

