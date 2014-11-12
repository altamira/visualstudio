CREATE TABLE [dbo].[CAGED] (
    [cd_funcionario]         INT      NOT NULL,
    [cd_caged]               INT      NOT NULL,
    [dt_inicial_caged]       DATETIME NULL,
    [dt_final_caged]         DATETIME NULL,
    [ic_gerado_arqmag_caged] CHAR (1) NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_CAGED] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_caged] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CAGED_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

