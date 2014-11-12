CREATE TABLE [dbo].[Nota_Vencimento] (
    [cd_nota_fiscal]              INT          NOT NULL,
    [dt_vencimento_nota]          DATETIME     NULL,
    [dt_baixa_nota]               DATETIME     NULL,
    [vl_saldo_nota]               FLOAT (53)   NULL,
    [nm_obs_nota_vencimento]      VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_usuario_responsavel]      INT          NULL,
    [cd_departamento_responsavel] INT          NULL,
    [cd_nota_saida]               INT          NULL,
    CONSTRAINT [PK_Nota_Vencimento] PRIMARY KEY CLUSTERED ([cd_nota_fiscal] ASC) WITH (FILLFACTOR = 90)
);

