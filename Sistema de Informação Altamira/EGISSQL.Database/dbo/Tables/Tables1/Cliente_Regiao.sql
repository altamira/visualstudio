CREATE TABLE [dbo].[Cliente_Regiao] (
    [cd_cliente_regiao] INT          NOT NULL,
    [nm_cliente_regiao] VARCHAR (30) NOT NULL,
    [sg_cliente_regiao] CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    [cd_grupo_regiao]   INT          NULL,
    CONSTRAINT [PK_Cliente_Regiao] PRIMARY KEY CLUSTERED ([cd_cliente_regiao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Regiao_Grupo_Regiao] FOREIGN KEY ([cd_grupo_regiao]) REFERENCES [dbo].[Grupo_Regiao] ([cd_grupo_regiao])
);

