CREATE TABLE [dbo].[Laudo_Produto_Quimico] (
    [cd_laudo]              INT           NOT NULL,
    [cd_dcb_produto]        VARCHAR (30)  NULL,
    [cd_dci_produto]        VARCHAR (30)  NULL,
    [cd_cas_produto]        VARCHAR (100) NULL,
    [nm_obs_laudo_produto]  VARCHAR (40)  NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [cd_guia_fracionamento] INT           NULL,
    CONSTRAINT [PK_Laudo_Produto_Quimico] PRIMARY KEY CLUSTERED ([cd_laudo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Laudo_Produto_Quimico_Laudo] FOREIGN KEY ([cd_laudo]) REFERENCES [dbo].[Laudo] ([cd_laudo])
);

