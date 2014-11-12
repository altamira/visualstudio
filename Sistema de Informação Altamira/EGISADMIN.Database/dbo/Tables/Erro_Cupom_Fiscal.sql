CREATE TABLE [dbo].[Erro_Cupom_Fiscal] (
    [cd_erro_cupom_fiscal]   INT           NOT NULL,
    [cd_posicao_fiscal]      INT           NULL,
    [nm_msg_erro_impressora] VARCHAR (200) NULL,
    [nm_msg_usuario]         TEXT          NULL,
    [cd_acao_tomada]         INT           NULL,
    [cd_ususario]            INT           NULL,
    [dt_usuario]             DATETIME      NULL
);

