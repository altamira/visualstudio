CREATE TABLE [dbo].[Tipo_Requisicao_Faturamento] (
    [cd_tipo_requisicao]      INT          NOT NULL,
    [nm_tipo_requisicao]      VARCHAR (40) NULL,
    [sg_tipo_requisicao]      CHAR (10)    NULL,
    [cd_operacao_estado]      INT          NULL,
    [cd_operacao_fora_estado] INT          NULL,
    [cd_condicao_pagamento]   INT          NULL,
    [nm_obs_tipo_requisicao]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_destinacao_produto]   INT          NULL,
    [cd_tipo_destinatario]    INT          NULL,
    CONSTRAINT [PK_Tipo_Requisicao_Faturamento] PRIMARY KEY CLUSTERED ([cd_tipo_requisicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Requisicao_Faturamento_Condicao_Pagamento] FOREIGN KEY ([cd_condicao_pagamento]) REFERENCES [dbo].[Condicao_Pagamento] ([cd_condicao_pagamento]),
    CONSTRAINT [FK_Tipo_Requisicao_Faturamento_Destinacao_Produto] FOREIGN KEY ([cd_destinacao_produto]) REFERENCES [dbo].[Destinacao_Produto] ([cd_destinacao_produto]),
    CONSTRAINT [FK_Tipo_Requisicao_Faturamento_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario])
);

