CREATE TABLE [dbo].[Operacao_Fiscal_Retorno] (
    [cd_operacao_fiscal]  INT          NOT NULL,
    [cd_operacao_retorno] INT          NOT NULL,
    [nm_obs_operacao]     VARCHAR (60) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Fiscal_Retorno] PRIMARY KEY CLUSTERED ([cd_operacao_fiscal] ASC, [cd_operacao_retorno] ASC),
    CONSTRAINT [FK_Operacao_Fiscal_Retorno_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_retorno]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal])
);

