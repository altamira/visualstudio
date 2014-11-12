CREATE TABLE [dbo].[Funcionario_Contrato] (
    [cd_contrato_funcionario] INT           NOT NULL,
    [dt_contrato_funcionario] DATETIME      NOT NULL,
    [ds_contrato_funcionario] NTEXT         NOT NULL,
    [vl_contrato_funcionario] FLOAT (53)    NOT NULL,
    [dt_vencimento]           DATETIME      NOT NULL,
    [dt_vencimento1]          DATETIME      NOT NULL,
    [qt_parcela]              FLOAT (53)    NOT NULL,
    [qt_intervalo]            FLOAT (53)    NOT NULL,
    [pc_juros]                FLOAT (53)    NOT NULL,
    [nm_contrato_funcionario] VARCHAR (100) NOT NULL,
    [cd_funcionario]          INT           NOT NULL,
    [cd_usuario]              INT           NOT NULL,
    [dt_usuario]              DATETIME      NOT NULL,
    CONSTRAINT [PK_Funcionario_Contrato] PRIMARY KEY CLUSTERED ([cd_contrato_funcionario] ASC) WITH (FILLFACTOR = 90)
);

