CREATE TABLE [dbo].[Fornecedor_Concorrente] (
    [cd_fornecedor]           INT      NOT NULL,
    [cd_concorrente]          INT      NOT NULL,
    [ds_obs_forn_concorrente] TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Fornecedor_Concorrente] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_concorrente] ASC) WITH (FILLFACTOR = 90)
);

