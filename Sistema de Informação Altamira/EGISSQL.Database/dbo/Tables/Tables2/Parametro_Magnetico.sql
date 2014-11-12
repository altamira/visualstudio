CREATE TABLE [dbo].[Parametro_Magnetico] (
    [cd_empresa]         INT      NOT NULL,
    [ic_reg_993_geracao] CHAR (1) NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    [ic_reg_991_geracao] CHAR (1) NULL,
    [ic_reg_992_geracao] CHAR (1) NULL,
    [ic_reg_997_geracao] CHAR (1) NULL,
    [ic_reg_998_geracao] CHAR (1) NULL,
    [ic_reg_999_geracao] CHAR (1) NULL,
    [ic_simples_cliente] CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Magnetico] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Magnetico_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

