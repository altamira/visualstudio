CREATE TABLE [dbo].[Solicitacao_Adiantamento_Baixa] (
    [cd_solicitacao_baixa]      INT          NOT NULL,
    [cd_solicitacao]            INT          NOT NULL,
    [cd_item_baixa]             INT          NOT NULL,
    [dt_baixa_adiantamento]     DATETIME     NULL,
    [vl_baixa_adiantamento]     FLOAT (53)   NULL,
    [nm_obs_baixa_adiantamento] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Solicitacao_Adiantamento_Baixa] PRIMARY KEY CLUSTERED ([cd_solicitacao_baixa] ASC) WITH (FILLFACTOR = 90)
);

