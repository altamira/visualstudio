CREATE TABLE [dbo].[Requisito_Legal] (
    [cd_requisito_legal]         INT           NOT NULL,
    [dt_requisito_legal]         DATETIME      NULL,
    [nm_requisito_legal]         VARCHAR (60)  NULL,
    [ds_requisito_legal]         TEXT          NULL,
    [nm_doc_requisito_legal]     VARCHAR (100) NULL,
    [nm_endereco_requisito]      VARCHAR (100) NULL,
    [nm_tema_requisito_legal]    VARCHAR (40)  NOT NULL,
    [ic_aplicacao_requisito]     CHAR (1)      NULL,
    [ic_ativo_requisito]         CHAR (1)      NULL,
    [dt_validacao_requisito]     DATETIME      NULL,
    [cd_usuario_validacao]       INT           NULL,
    [nm_obs_requisito_legal]     VARCHAR (40)  NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [cd_origem_requisito]        INT           NULL,
    [nm_justificativa_requisito] VARCHAR (100) NULL,
    CONSTRAINT [PK_Requisito_Legal] PRIMARY KEY CLUSTERED ([cd_requisito_legal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisito_Legal_Origem_Requisito] FOREIGN KEY ([cd_origem_requisito]) REFERENCES [dbo].[Origem_Requisito] ([cd_origem_requisito]),
    CONSTRAINT [FK_Requisito_Legal_Usuario] FOREIGN KEY ([cd_usuario_validacao]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

