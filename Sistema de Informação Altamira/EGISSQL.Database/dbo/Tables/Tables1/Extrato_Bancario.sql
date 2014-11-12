CREATE TABLE [dbo].[Extrato_Bancario] (
    [cd_extrato_bancario]     INT          NULL,
    [dt_inicio_extrato_banco] DATETIME     NULL,
    [dt_fim_extrato_banco]    DATETIME     NULL,
    [cd_banco]                INT          NULL,
    [cd_conta_banco]          INT          NULL,
    [dt_extrato_banco]        DATETIME     NULL,
    [nm_extrato_banco]        VARCHAR (40) NULL,
    [vl_extrato_banco]        FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [FK__Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco])
);

