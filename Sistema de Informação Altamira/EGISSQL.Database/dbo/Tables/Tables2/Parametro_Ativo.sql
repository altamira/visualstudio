CREATE TABLE [dbo].[Parametro_Ativo] (
    [cd_empresa]           INT        NOT NULL,
    [cd_indice_monetario]  INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_moeda]             INT        NULL,
    [vl_teto_ativo_fixo]   FLOAT (53) NULL,
    [ic_inicio_dep_ativo]  CHAR (1)   NULL,
    [cd_conta]             INT        NULL,
    [dt_implantacao_ativo] DATETIME   NULL,
    CONSTRAINT [PK_Parametro_Ativo] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Ativo_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

