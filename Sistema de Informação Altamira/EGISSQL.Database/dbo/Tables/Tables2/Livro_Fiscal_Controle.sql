CREATE TABLE [dbo].[Livro_Fiscal_Controle] (
    [cd_empresa]                INT          NOT NULL,
    [dt_inicial_livro_controle] DATETIME     NOT NULL,
    [dt_final_livro_controle]   DATETIME     NOT NULL,
    [ic_processado_le]          CHAR (1)     NULL,
    [ic_processado_ls]          CHAR (1)     NULL,
    [ic_manutencao_le]          CHAR (1)     NULL,
    [ic_manutencao_ls]          CHAR (1)     NULL,
    [nm_obs_livro_controle]     VARCHAR (40) NULL,
    [ic_oficial_le]             CHAR (1)     NULL,
    [ic_oficial_ls]             CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Livro_Fiscal_Controle] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [dt_inicial_livro_controle] ASC, [dt_final_livro_controle] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Livro_Fiscal_Controle_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

